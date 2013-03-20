//
//  BAMAppDelegate.h
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const SCSessionStateChangedNotification;

@interface BAMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

-(void)openReadSession;
-(void)openPublishSession;

@end
