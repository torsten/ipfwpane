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
 * FWRootRunner.m, created on 03.10.2008.
 */

#import "FWRootRunner.h"

#import "DebugFU.h"

#include <stdarg.h>
#include <stdio.h>


@implementation FWRootRunner


#pragma mark NSObject


- (id)init
{
	if((self = [super init]))
	{
		mAuthRef = NULL;
	}
	return self;
}


#pragma mark Public Methods


- (void)setAuthorizationRef:(AuthorizationRef)pAuthRef
{
	mAuthRef = pAuthRef;
	
	if(pAuthRef)
		FULog(@"setAuthorizationRef:YAY");
	else
		FULog(@"setAuthorizationRef:NULL");
}

- (AuthorizationRef)authorizationRef
{
	return mAuthRef;
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

@end


@implementation FWRootRunner (Private)

- (FILE*)openPipeToCommand:(const char*)pCmd
	withArg:(const char*)pArg andList:(va_list)pVaList
{
	unsigned int argumentCount;
	char* argv[101];
	
	// Yeah, I know this cast is bad...
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

@end