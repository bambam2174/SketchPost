//
//  SketchPostTests.m
//  SketchPostTests
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

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


@end
