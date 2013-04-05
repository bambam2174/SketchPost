//
//  ADDRAWViewController.h
//  DrawAppClient
//
//  Created by Sedat Kilinc on 06.03.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//

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
}


- (bool) hasChanges;

@property (nonatomic, unsafe_unretained) id<ADDRAWViewControllerDelegate> delegate;

@end

@protocol ADDRAWViewControllerDelegate <NSObject>

@optional
- (void) OnSketchADDRAWViewControllerCancel:(ADDRAWViewController*)ctrl;
- (void) OnSketchADDRAWViewController:(ADDRAWViewController *)ctrl saveImage:(UIImage*)image;
-(void)swipeGesture:(UISwipeGestureRecognizerDirection)direction;
@end