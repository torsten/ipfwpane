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
 * FWRootRunner.h, created on 03.10.2008.
 */

#import <Cocoa/Cocoa.h>
#import <Security/Authorization.h>


/**
 *	This class provides some convienience methods to work with the
 *	AuthorizationExecuteWithPrivileges API.
 */
@interface FWRootRunner : NSObject
{
	AuthorizationRef mAuthRef;
}

@property AuthorizationRef authorizationRef;

/**
 *	Set the AuthorizationRef to use for executing the commands.
 */
- (void)setAuthorizationRef:(AuthorizationRef)authRef;

/**
 *	Just to have a full property implementation.
 */
- (AuthorizationRef)authorizationRef;

/**
 *	Just open the pipe and return the descriptor.  Returns -1 on error.
 */
- (int)openPipeToCommand:(const char*)cmd withArgs:(const char*)arg, ...;

/**
 *	Runs ipfw with the given arguments and returns the output as a string.
 *	The list is terminated by a NULL pointer.
 *
 *	If this method returns nil, something went wrong.
 */
- (NSString*)runCommand:(const char*)cmd withArgs:(const char*)arg, ...;

@end


@interface FWRootRunner (Private)

/**
 *	This is the base implementation of the method.  The maximum size of
 *	the arguments accepted is 100.
 */
- (FILE*)openPipeToCommand:(const char*)cmd withArg:(const char*)arg
	andList:(va_list)vaList;

@end
