//
//  BAMLoginController.h
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ADSBorderedTextfield;

@interface BAMLoginController : UIViewController <UITextFieldDelegate> {
    ADSBorderedTextfield *_tfUsername;
    ADSBorderedTextfield *_tfPassword;
    UIButton *_btnLogin;
    UIActivityIndicatorView *_spinner;
}

-(void)loginFailed;

@end
