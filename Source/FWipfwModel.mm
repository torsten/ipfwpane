/*
 * Copyright (C) 2008 Torsten Becker. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * FWipfwModel.mm, created on 20.09.2008.
 */

#import "FWPrefPane.h"
#import "FWRule.h"
#import "FWipfwModel.h"
#import "FWLaunchDaemon.h"
#import "FWipfwConfHandler.h"

#import "DebugFU.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// #include <vector>  --  has already been done in FWipfwModel.h

#define IPFW "/sbin/ipfw"
#define IPFW_CONF "/Library/Preferences/SystemConfiguration/" \
		"net.pixelshed.ipfwpane.ipfw.conf"


@implementation FWipfwModel


#pragma mark NSObject


- (id)init
{
	if((self = [super init]))
	{
		mRules = new FWipfwRuleContainer();
		mAuthRef = NULL;
		mConfHandler = [[FWipfwConfHandler alloc] initWithModel:self];
	}
	return self;
}

- (void)dealloc
{
	[self clearRules];
	delete mRules;
	[mConfHandler release];
	
	[super dealloc];
}


#pragma mark Public Methods


- (unsigned int)numberOfRules
{
	return mRules->size();
}

- (FWRule*)ruleForIndex:(unsigned int)pIndex
{
	return (*mRules)[pIndex];
}

- (void)addRule:(FWRule*)pNewRule
{
	[pNewRule retain];
	mRules->push_back(pNewRule);
}

- (void)removeRuleAtIndex:(unsigned int)pIndex
{
	[((*mRules)[pIndex]) release];
	mRules->erase(mRules->begin()+pIndex);
}

- (void)reloadRules
{
	FULog(@"reloadRules");
	
	[self clearRules];
	
	// open .conf file
	int pipe = open(IPFW_CONF, O_RDONLY);
	
	FULog(@"pipe: %d", pipe);
	
	[mConfHandler parseFile:pipe];
	close(pipe);
}

- (void)saveRules
{
	FULog(@"saveRules");
	
	int pipe = [self openPipeToCommand:"/bin/sh"
			withArgs:"-c", "/bin/cat - > "IPFW_CONF, NULL];
	
	// set right chmod to the config file
	[self runCommand:"/bin/chmod" withArgs:"0644", IPFW_CONF, NULL];
	
	[self writeFrameworkRulesToFile:pipe];
	[mConfHandler writeRulesToFile:pipe];
	
	close(pipe);
	
	// delete current rules via ipfw
	[self flushRules];
	
	// read the file again with ipfw
	[self runCommand:IPFW withArgs:IPFW_CONF, NULL];
}

- (void)setAuthorizationRef:(AuthorizationRef)pAuthRef
{
	mAuthRef = pAuthRef;
	
	if(pAuthRef)
		FULog(@"setAuthorizationRef:YAY");
	else
		FULog(@"setAuthorizationRef:NULL");
}

- (void)enableFirewall:(BOOL)pEnable
{
	if(pEnable)
	{
		FULog(@"enableFirewall:YES");
		
		[self installLaunchDaemon];
		[self saveRules];
	}
	else
	{
		FULog(@"enableFirewall:NO");
		
		[self flushRules];
		[self removeLaunchDaemon];
	}
}

// TODO: maybe implement a isFirewallEnabled method which
// returns if the launch daemon file exists.  or encode this in the .conf, too.

@end


@implementation FWipfwModel (Private)

#define DROP_ALL_RULE "65534"
#define CUSTOM_RULES "41337"
#define PRE_RULES "41336"
#define POST_RULES "41338"
#define RULE_SET "23"

#define ADD_RULE(RULE_ID, RULE_BODY) \
	"add " RULE_ID " set " RULE_SET " " RULE_BODY "\n"

- (void)writeFrameworkRulesToFile:(int)pFd
{
	// TODO: configureable rule ids and sets (via defaults)
	
	// This are the default rules which provide the framework
	// for the user rules to work properply.
	// These are based on the rules from ipfw-securosis.
	const char *framworkRules =
	
	// Warn curious users because the format of this file is essential to
	// parse it when reading the current rules.
	"# This file was generated by ipfwPane.\n"
	"# DO NOT, UNDER NO CIRCUMSTANCES, CHANGE IT MANUALLY!!!11\n\n"
	
	// Allow everthing on lo0
	ADD_RULE(PRE_RULES, "allow ip from any to any via lo0")
	
	// Deny loopback traffic on other interfaces.
	ADD_RULE(PRE_RULES, "deny ip from any to 127.0.0.0/8")
	
	// Keep track of UDP connections we did open.
	ADD_RULE(PRE_RULES, "allow udp from any to any out keep-state")
	
	// Deny all incoming connections (exept for those the user wants)
	ADD_RULE(POST_RULES, "deny tcp from any to any in setup")
	
	// Allow all the rest of TCP.
	ADD_RULE(POST_RULES, "allow tcp from any to any")
	
	// DHCP answers
	ADD_RULE(POST_RULES, "allow udp from any 67 to any dst-port 68 in")
	
	// Deny all other UDP traffic.
	ADD_RULE(POST_RULES, "deny udp from any to any")
	
	// MTU discovery
	ADD_RULE(POST_RULES, "allow icmp from any to any icmptypes 3")
	
	// Source quench
	ADD_RULE(POST_RULES, "allow icmp from any to any icmptypes 4")
	
	// Ping out; accept ping answers.
	ADD_RULE(POST_RULES, "allow icmp from any to any icmptypes 8 out")
	ADD_RULE(POST_RULES, "allow icmp from any to any icmptypes 0 in")
	
	// Allow outbound traceroute.
	ADD_RULE(POST_RULES, "allow icmp from any to any icmptypes 11 in")
	
	// Deny everything else.
	ADD_RULE(DROP_ALL_RULE, "deny ip from any to any\n")
	;
	
	write(pFd, framworkRules, strlen(framworkRules));
}

#undef ADD_RULE


- (void)openTempFileAndSaveFDAt:(int*)pFileDesPtr saveNameAt:(NSString**)pStrPtr
{
	char name[] = "/tmp/ipfw-input-XXXXXXXXXX";
	
	*pFileDesPtr = mkstemp(name);
	*pStrPtr = [NSString stringWithUTF8String:name];
	
	FULog(@"openTempFileAndSaveFDAt:%d saveNameAt:%@", *pFileDesPtr, *pStrPtr);
}

- (FILE*)openPipeToCommand:(const char*)pCmd
	withArg:(const char*)pArg andList:(va_list)pVaList
{
	unsigned int argumentCount;
	char* argv[101];
	
	// Yeah, I know this is bad...
	argv[0] = (char*)pArg;
	
	// Cound and collect the arguments into a argv
	if(pArg == NULL)
		argumentCount = 0;
	
	else
	{
		for(argumentCount = 1; argumentCount < 101; ++argumentCount)
		{
			argv[argumentCount] = va_arg(pVaList, char*);
			
			if(argv[argumentCount] == NULL)
				break;
		}
	}
	
#ifdef DEBUG
	fprintf(stderr, "oPtC:wA:aL: %s with %d args: ", pCmd, argumentCount);
	
	for(unsigned int i = 0; i < argumentCount; ++i)
		fprintf(stderr, "(%u)'%s' ", i, argv[i]);
	
	fputc('\n', stderr);
#endif
	
	// This 2 get changed
	OSStatus status;
	FILE *communicationsPipe;
	
	// Constant stuff for the next call
	const AuthorizationFlags options = kAuthorizationFlagDefaults;
	
	// TODO: Ensure somehow at this point, that the command is not bad.
	
	status = AuthorizationExecuteWithPrivileges(
			mAuthRef, pCmd, options, argv, &communicationsPipe);
	
	if(status == errAuthorizationSuccess)
	{
		FULog(@"YES, errAuthorizationSuccess, continuing...");
		return communicationsPipe;
	}
	else
	{
		FULog(@"NO errAuthorizationSuccess, STOP.");
		return NULL;
	}
}

- (int)openPipeToCommand:(const char*)pCmd withArgs:(const char*)pArg, ...
{
	va_list argumentList;
	FILE *pipeFile;
	
	va_start(argumentList, pArg);
	pipeFile = [self openPipeToCommand:pCmd withArg:pArg andList:argumentList];
	va_end(argumentList);
	
	if(pipeFile != NULL)
		return fileno(pipeFile);
	else
		return -1;
}

- (NSString*)runCommand:(const char*)pCmd withArgs:(const char*)pArg, ...
{
	va_list argumentList;
	FILE *pipeFile;
	
	va_start(argumentList, pArg);
	pipeFile = [self openPipeToCommand:pCmd withArg:pArg andList:argumentList];
	va_end(argumentList);
	
	// manpage says: "These functions should not fail [...]"
	int fd = fileno(pipeFile);
	
	NSFileHandle *fh = [[[NSFileHandle alloc]
			initWithFileDescriptor:fd] autorelease];
	NSData *data = [fh readDataToEndOfFile];
	
	if(fclose(pipeFile) != 0)
		FULog(@"rC:wA: fclose() ERROR");
	
	NSString *str = [[[NSString alloc] 
			initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	return str;
}

- (void)installLaunchDaemon
{
	FULog(@"installLaunchDaemon");
	
	int pipe = [self openPipeToCommand:"/bin/sh"
			withArgs:"-c", "/bin/cat - > "FW_LAUNCH_DAEMON_FILENAME, NULL];
	
	[self runCommand:"/bin/chmod"
			withArgs:"0644", FW_LAUNCH_DAEMON_FILENAME, NULL];
	
	write(pipe, FW_LAUNCH_DAEMON_DATA, strlen(FW_LAUNCH_DAEMON_DATA));
	close(pipe);
}

- (void)removeLaunchDaemon
{
	FULog(@"removeLaunchDaemon");
	[self runCommand:"/bin/rm" withArgs:"-f", FW_LAUNCH_DAEMON_FILENAME, NULL];
}

- (void)flushRules
{
	FULog(@"flushRules");
	
	[self runCommand:IPFW withArgs:
			"delete", DROP_ALL_RULE, PRE_RULES, CUSTOM_RULES, POST_RULES, NULL];
}

- (void)clearRules
{
	FWipfwRuleContainer::iterator iter(mRules->begin());
	
	// release each rule in the container.
	for(; iter != mRules->end(); ++iter)
		[(*iter) release];
	
	mRules->clear();
}


@end
