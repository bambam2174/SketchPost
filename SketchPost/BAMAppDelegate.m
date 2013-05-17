//
//  BAMAppDelegate.m
//  SketchPost
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

#import "BAMAppDelegate.h"
#import "BAMViewController.h"
#import "ADDRAWViewController.h"
#import "BAMLoginController.h"

NSString *const SCSessionStateChangedNotification = @"de.adrodev.kilinc.sketchpost:SCSessionStateChangedNotification";

@implementation BAMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    BAMViewController *ctrl = [[BAMViewController alloc] init];
    _navController = [[UINavigationController alloc] initWithRootViewController:ctrl];
    _window.rootViewController = _navController;
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openPublishSession];
    } else {
        [self showLoginView];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
    [self handleAudioSession];
}

-(void)handleAudioSession {
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, audioVolumeChangeListenerCallback, (__bridge void *)(self));
}

Float32 _currentCount;

void audioVolumeChangeListenerCallback(void *inUserData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData) {
    Float32 newCount = *(Float32 *)inData;
    NSLog(@"%@", inUserData);
    NSLog(@"%f", newCount);
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, NULL, NULL);
    if (newCount > _currentCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideToolBars object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowToolBars object:nil];
    }
    _currentCount = newCount;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)sessionStateChanged:(FBSession *)session
                     state:(FBSessionState)state
                     error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            {
                UIViewController *topViewController = [self.navController topViewController];
                if ([topViewController.presentedViewController isKindOfClass:[BAMLoginController class]]) {
                    [topViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [_navController popToRootViewControllerAnimated:YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            [self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)openReadSession {

    
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"session %@, status %d, error %@", session, status, error);
        [self sessionStateChanged:session state:status error:error];
    }];

}

-(void)openPublishSession {
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", nil]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"session %@, status %d, error %@", session, status, error);
        [self sessionStateChanged:session state:status error:error];
    }];
}

-(void)showLoginView {
    UIViewController *topViewController = _navController.topViewController;
    UIViewController *modalViewController = topViewController.presentedViewController;
    
    if (![modalViewController isKindOfClass:[BAMLoginController class]]) {
        BAMLoginController *ctrl = [[BAMLoginController alloc] init];
        [topViewController presentViewController:ctrl animated:YES completion:nil];
    } else {
        BAMLoginController *ctrl = (BAMLoginController *)modalViewController;
        [ctrl loginFailed];
    }
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    NSLog(@"accessToken %@", accessToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

@end
