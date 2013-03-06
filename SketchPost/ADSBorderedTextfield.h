//
//  SFABorderedTextfield.h
//  iSFA
//
//  Created by Sedat Kilinc on 08.02.13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ADSBorderedTextfield : UITextField

@property (assign, nonatomic) CGFloat padding;
@property (assign, nonatomic) CGFloat paddingHorizontal;
@property (assign, nonatomic) CGFloat paddingVertical;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;

@end
