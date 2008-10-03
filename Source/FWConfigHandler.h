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
 * FWConfigHandler.h, created on 01.10.2008.
 */

#import <Cocoa/Cocoa.h>


@class FWipfwModel;


/**
 *	This class can parse specally annotated ipfw.conf file and
 *	write a ruleset back to such a file as well.
 */
@interface FWConfigHandler : NSObject
{
	FWipfwModel *mModel;
}

/**
 *	Creates the handler with a model, this model will receive all the
 *	new rules if you parse via parseFile: and it will also be used to
 *	gather data when using writeRulesToFile:.
 */
- (id)initWithModel:(FWipfwModel*)model;

/**
 *	Parses the specialy annotated ipfw.conf file and addRule:s them
 *	into the model.
 */
- (void)parseFile:(int)ipfwConfFd;

/**
 *	
 */
- (void)writeRulesToFile:(int)ipfwConfFd;

@end
