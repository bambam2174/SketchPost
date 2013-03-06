//
//  SFABorderedTextfield.m
//  iSFA
//
//  Created by Sedat Kilinc on 08.02.13.
//
//

#import "ADSBorderedTextfield.h"

@implementation ADSBorderedTextfield

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _padding = 5.0f;
        _cornerRadius = 5.0f;
        _borderColor = [UIColor lightGrayColor];
        _borderWidth = 1.0f;
        _paddingHorizontal = 5.0f;
        _paddingVertical = 4.0f;
        
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;
}

-(void)setPadding:(CGFloat)padding {
    _padding = padding;
    _paddingHorizontal = padding;
    _paddingVertical = padding;
    [self setNeedsLayout];
}

-(void)setPaddingHorizontal:(CGFloat)paddingHorizontal {
    _paddingHorizontal = paddingHorizontal;
    [self setNeedsLayout];
}

-(void)setPaddingVertical:(CGFloat)paddingVertical {
    _paddingVertical = paddingVertical;
    [self setNeedsLayout];
}

-(void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsLayout];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsLayout];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _paddingHorizontal, bounds.origin.y + _paddingVertical,
                      bounds.size.width - 2*_paddingHorizontal, bounds.size.height - 2*_paddingVertical);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
