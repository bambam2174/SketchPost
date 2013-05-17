//
//  SFABorderedTextfield.m
//
//  Created by Sedat Kilinc on 08.02.13.
//
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
