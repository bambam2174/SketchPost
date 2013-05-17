//
//  ADDRAWViewController.h
//  DrawAppClient
//
//  Created by Sedat Kilinc on 06.03.12.
//  Copyright (c) 2012 Internship. All rights reserved.
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

#define kShowToolBars @"kShowToolBars"
#define kHideToolBars @"kHideToolBars"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ADDRAWViewControllerDelegate;

@interface ADDRAWViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    UILabel *_lblAnzeige;
    CGFloat _radius;
    UILabel *_lblTopAnzeige;
    UIImagePickerController *picker;
    UIToolbar *tBar;
    CALayer *theLayer;
    CGPoint lastPoint;
    BOOL mouseSwiped;
    //
    UIImageView *tmpImgVw;
    UIImage *bild;
    NSMutableArray *_arrPaths;
    NSMutableArray *_intermediatePaths;
    int pc;
//    int lastPC;
    CAShapeLayer *shapeLayer;
    CGMutablePathRef path;
    
    UIView *colorPicker;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    NSMutableDictionary *dictPaths;
    
    UIButton *textButton;
    BOOL drawText;
    NSString *overlayText;
    UITextField *tfOverlayText;
    UIFont *overlayFont;
    BOOL need2turn;
    id<ADDRAWViewControllerDelegate> __unsafe_unretained _delegate;
    BOOL canvas2Top;
    CGFloat vOffset;
    
    UIButton *_colorButton;
    UIView *_colorPoint;
    UIButton *_widthButton;
    UISlider *_widthSlider;
    UIView *_colorView;
    
    UIAlertView *cancelAlertView;
    UIView *_topToolBar;
    UISegmentedControl *_toolButtons;
    UIView *_graySheet;
    BOOL _topToolBarVisible;
    BOOL _bottomToolBarVisible;
    UIButton *_btnSave;
    UIButton *_btnCancel;
}


- (bool) hasChanges;

@property (nonatomic, unsafe_unretained) id<ADDRAWViewControllerDelegate> delegate;

-(void)setDeviceOrientation:(UIDeviceOrientation)orientation;
- (void)showToolbars;
- (void)hideToolbars;

@end

@protocol ADDRAWViewControllerDelegate <NSObject>

@optional
- (void) OnSketchADDRAWViewControllerCancel:(ADDRAWViewController*)ctrl;
- (void) OnSketchADDRAWViewController:(ADDRAWViewController *)ctrl saveImage:(UIImage*)image;
-(void)swipeGesture:(UISwipeGestureRecognizerDirection)direction;
@end