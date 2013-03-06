//
//  SADDRAWViewController.h
//  DrawAppClient
//
//  Created by Sedat Kilinc on 06.03.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//
#define FESTO_STYLE




#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreGraphics/CoreGraphics.h>


@protocol SADDRAWViewControllerDelegate;

@interface SADDRAWViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIPopoverControllerDelegate> {
    UILabel *_lblAnzeige;
    CGFloat _radius;
    UILabel *_lblTopAnzeige;
    UIImagePickerController *picker;
    UIToolbar *tBar;
    CALayer *theLayer;
    CGPoint lastPoint;
    BOOL mouseSwiped;
    //
    UIImageView *tmpImgVw; //
    UIImage *bild;
    NSMutableArray *_arrPaths;
    NSMutableArray *_intermediatePaths;
    int pc;
//    int lastPC;
    CAShapeLayer *shapeLayer;
    CGMutablePathRef path;
    
    UIView *colorPicker;
    BOOL colorPickerVisible;
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
    UIButton *btnColor;
    BOOL canvas2Top;
    CGFloat vOffset;
    
    UIView *_topNavBar;
    UIView *_bottomBar;
    bool _viewActive;
    bool _alreadyTurned;
    BOOL _locked;
    UIButton *attachmentButton;
    UIButton *_btnAddAttachment;
    UIButton *_currentAttachmentIcon;
    NSInteger _attachmentCount;
    NSInteger _attachmentCountAll;
    NSString *_currentAttachmentType;
    NSArray *_arrAttachments;
    BOOL _toolBarVisible;
    UISegmentedControl *_toolButtons;
    UITextView *_tvNote;
    UIView *_canvasContainer;
    BOOL _isFirstCall;
}

//@property (strong) ExhibitionLeadDetailNoteView *noteView;

@property (nonatomic, assign) id<SADDRAWViewControllerDelegate> delegatex;
@property (nonatomic, retain) UIPopoverController *m_PopoverController;

//-(void)lockDrawing:(NSNumber *)lock;
-(void)saveCurrentImage;
//-(ExhibitionLeadAttachmentType)getCurrentAttachmenType;

@end

@protocol SADDRAWViewControllerDelegate <NSObject>

@optional
- (void) OnSketchADDRAWViewControllerCancel:(SADDRAWViewController*)ctrl;
- (void) OnSketchADDRAWViewController:(SADDRAWViewController *)ctrl saveImage:(UIImage*)image;

@end
