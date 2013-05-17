//
//  SketchPostTests.m
//  SketchPostTests
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
/*  All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SketchPostTests.h"

@implementation SketchPostTests

- (void)setUp
{
    [super setUp];
    _mgr = [BAMFacebookManager shared];
    _mgr.delegate = self;
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    _mgr.delegate = nil;
    _mgr = nil;
    [super tearDown];
}

- (void)testFacebookManager
{
    BAMFacebookManager *obj = [BAMFacebookManager shared];
    STAssertTrue([obj isKindOfClass:[BAMFacebookManager class]], @"Klasse ist richtig/falsch");
}

-(void)testFriendsPickerController {
    FBFriendPickerViewController *ctrl = [[BAMFacebookManager shared] friendsPickerController];
    STAssertNotNil(ctrl, @"FBFriendPickerViewController ist null");
}

#pragma mark - BAMFacebookManagerDelegate

-(void)userDetailsFetched:(NSDictionary<FBGraphUser> *)user {
    
}

-(void)friendspickerDoneWasPressed:(id)sender {
    
}

-(void)friendspickerCancelWasPressed:(id)sender {
    
}

-(void)fbRequestDidFinishWithResult:(id)result error:(NSError *)err {
    
}


@end
