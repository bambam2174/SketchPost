//
//  BAMViewController.h
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class ADDRAWViewController;

@interface BAMView  : UIView {
    UIImageView *_imvProfile;
    UILabel *_lblStuff;
}

@end

//################################################################################################################################
//################################################################################################################################

@interface BAMViewController : UIViewController {
    ADDRAWViewController *m_sketchController;
    BAMView *_otherView;
    BOOL _isOtherViewVisible;
}

@end
