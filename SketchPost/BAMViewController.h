//
//  BAMViewController.h
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BAMFacebookManager.h"
#import "ADDRAWViewController.h"

@class ADDRAWViewController;

@protocol BAMViewDelegate <NSObject>


@end

@interface BAMView  : UIView  {
    
    FBProfilePictureView *_profilePictureView;
    UILabel *_lblStuff;
    UIButton *_btnStart;
    UIButton *_btnFriends;
}

@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;

-(void)addButtonStartTarget:(id)target action:(SEL)selector;
-(void)addButtonFriendTarget:(id)target action:(SEL)selector;

@end

#pragma mark -
/*
################################################################################################################################
################################################################################################################################
*/
#pragma mark -

@interface BAMViewController : UIViewController<BAMFacebookManagerDelegate, ADDRAWViewControllerDelegate> {
    ADDRAWViewController *m_sketchController;
    BAMView *_otherView;
    BOOL _isOtherViewVisible;
    BAMFacebookManager *_mgr;
    FBFriendPickerViewController *_friendsPicker;
    UIView *_graySheet;
}

@end
