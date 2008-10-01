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

#import "DebugFU.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// #include <vector>  --  has already been done in FWipfwModel.h


@implementation FWipfwModel


#pragma mark NSObject


- (id)init
{
	if((self = [super init]))
	{
		mRules = new FWipfwRuleContainer();
		mAuthRef = NULL;
	}
	return self;
}

- (void)dealloc
{
	FWipfwRuleContainer::iterator iter(mRules->begin());
	
	// delete/free/dealloc each rule in the container.
	for(; iter != mRules->end(); ++iter)
		[(*iter) release];
	
	
	delete mRules;
	
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
	
	
}

- (void)saveRules
{
	FULog(@"saveRules");
	
	
}

- (void)setAuthorizationRef:(AuthorizationRef)pAuthRef
{
	mAuthRef = pAuthRef;
	
	if(pAuthRef)
		[self getRuleList];
}

- (void)setFirewallEnabled:(BOOL)enable
{
	
}

- (BOOL)firewallEnabled
{
	return NO;
}


@end


@implementation FWipfwModel (Private)

- (void)getRuleList
{
	[self addRulesToIpfw];
	NSLog(@"%@", [self runIpfwWithArgs:"-S", "list", NULL]);
}                 


- (void)writeActiveRulesToFile:(int)pFd
{
	// TODO: configureable rule ids (via defaults)
	const char *preamble =
	"add 41336 set 23 allow ip from any to any via lo0\n"
	"add 41336 set 23 deny ip from any to 127.0.0.0/8\n"
	"add 41336 set 23 allow udp from any to any out keep-state\n";
	
	const char *postamble =
	"add 41338 set 23 deny tcp from any to any in setup\n"
	"add 41338 set 23 allow tcp from any to any\n"
	"add 41338 set 23 allow udp from any 67 to any dst-port 68 in\n"
	"add 41338 set 23 allow igmp from any to any\n"
	"add 41338 set 23 allow icmp from any to any icmptypes 3\n"
	"add 41338 set 23 allow icmp from any to any icmptypes 4\n"
	"add 41338 set 23 allow icmp from any to any icmptypes 8 out\n"
	"add 41338 set 23 allow icmp from any to any icmptypes 0 in\n"
	"add 41338 set 23 allow icmp from any to any icmptypes 11 in\n"
	"add 64535 set 23 deny ip from any to any\n";
	
	
	write(pFd, preamble, strlen(preamble));
	
	
	const char *body =
	"add 41337 set 23 allow tcp from any to me dst-port 8008 in\n"
	"add 41337 set 23 allow tcp from any to me dst-port 17328 in\n";
	write(pFd, body, strlen(body));
	
	
	write(pFd, postamble, strlen(postamble));
}


- (void)addRulesToIpfw
{
	int fd;
	NSString *tempFileName;
	
	// TODO: Write to the same file the startup-item uses it it gets integrated.
	
	[self openTempFileAndSaveFDAt:&fd saveNameAt:&tempFileName];
	
	if(fd == -1)
	{
		NSLog(@"BAEM, got a invalid temp fd.");
		return;
	}
	
	[self writeActiveRulesToFile:fd];
	
	NSString *result;
	
	// Delete the old rules first
	result = [self runIpfwWithArgs:
			"delete", "64535", "41338", "41337", "41336", NULL];
	FULog(@"%@ ", result);
	
	// Create the new ones from the file
	result = [self runIpfwWithArgs:[tempFileName UTF8String], NULL];
	FULog(@"%@ ", result);
	
	// Delete the temp file.
	if(unlink([tempFileName UTF8String]) != 0)
		NSLog(@"unlink() of %@ failed.", tempFileName);
	
	close(fd);
}

- (void)openTempFileAndSaveFDAt:(int*)pFileDesPtr saveNameAt:(NSString**)pStrPtr
{
	char name[] = "/tmp/ipfw-input-XXXXXXXXXX";
	
	*pFileDesPtr = mkstemp(name);
	*pStrPtr = [NSString stringWithUTF8String:name];
	
	FULog(@"openTempFileAndSaveFDAt:%d saveNameAt:%@", *pFileDesPtr, *pStrPtr);
}

- (NSString*)runIpfwWithArgs:(const char*)pArg, ...
{
	va_list argumentList;
	unsigned int argumentCount;
	
	// Count the arguments
	if(pArg == NULL)
		argumentCount = 0;
	
	else
	{
		argumentCount = 1;
		va_start(argumentList, pArg);
		
		while(va_arg(argumentList, char*) != NULL)
			++argumentCount;
		
		va_end(argumentList);
	}
	
	// Collect the arguments into a argv
	char* argv[argumentCount+1];
	
	if(argumentCount >= 1)
	{
		argv[0] = (char*)pArg;
		
		va_start(argumentList, pArg);
	
		for(unsigned int i = 1; i <= argumentCount; ++i)
			argv[i] = va_arg(argumentList, char*);
		
		va_end(argumentList);
	}
	else // argumentCount == 0
		argv[0] = NULL;
	
#ifdef DEBUG
	fprintf(stderr, "runIpfwWithArgs got %d args: ", argumentCount);
	
	for(unsigned int i = 0; i < argumentCount; ++i)
		fprintf(stderr, "(%u)'%s' ", i, argv[i]);
	
	fputc('\n', stderr);
#endif	
	
	// This 2 get changed
	OSStatus status;
	FILE *communicationsPipe;
	
	// Constant stuff for the next call
	const char *ipfw = "/sbin/ipfw";
	const AuthorizationFlags options = kAuthorizationFlagDefaults;
	
	// TODO: Ensure somehow at this point, that the command is not bad.
	
	status = AuthorizationExecuteWithPrivileges(
			mAuthRef, ipfw, options, argv, &communicationsPipe);
	
	if(status == errAuthorizationSuccess)
		FULog(@"errAuthorization__Success__, continuing...");
	
	else
	{
		FULog(@"NO errAuthorizationSuccess, STOP.");
		return nil;
	}
	
	// manpage says: "These functions should not fail [...]"
	int fd = fileno(communicationsPipe);
    
	NSFileHandle *fh = [[[NSFileHandle alloc]
			initWithFileDescriptor:fd] autorelease];
	
	NSData *data = [fh readDataToEndOfFile];
	
	if(fclose(communicationsPipe) != 0)
		FULog(@"fclose() ERROR");
	
	NSString *str = [[[NSString alloc] 
			initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	return str;
}


@end
