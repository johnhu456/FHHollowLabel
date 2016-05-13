//
//  FHHollowLabel.m
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHHollowLabel.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation FHHollowLabel
{
    UIFont * _font;
    UIColor * _backgroundColor;
    NSException *_errorExcption;
}

#pragma mark - 重写对应的set方法

- (void)setText:(NSString *)text
{
    [self dynamicErrorMethodWithPropertyName:@"text"];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _hollowFont = font;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    _hollowBackgroundColor = backgroundColor;
}

- (void)setHollowType:(FHHollowType)hollowType
{
    _hollowType = hollowType;
    [self setNeedsDisplay];
}

- (void)dynamicErrorMethodWithPropertyName:(NSString *)name
{
    NSString *errorName = [NSString stringWithFormat:@"error With set %@",name];
    NSString *firstUppercaseCharacter = [[name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    NSString *propertyName = [NSString stringWithFormat:@"hollow%@",[name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstUppercaseCharacter]];
    NSString *errorReason = [NSString stringWithFormat:@"Please use property 'hollow%@' instead of '%@'",propertyName,name];
    _errorExcption = [[NSException alloc] initWithName:errorName reason:errorReason userInfo:nil];
    [_errorExcption raise];
}

- (void)sizeToFit
{
    _errorExcption = [[NSException alloc] initWithName:@"methodError" reason:@"Can't use method 'sizeToFit'" userInfo:nil];
    [_errorExcption raise];
}

- (instancetype)init
{
    _errorExcption = [[NSException alloc] initWithName:@"initError" reason:@"Please Use Method 'initWithFrame: hollowType' to init" userInfo:nil];
    [_errorExcption raise];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame hollowType:(FHHollowType)type
{
    if (self = [super initWithFrame:frame]) {
        _hollowType = type;
    }
    return self;
}


#pragma mark - 绘制
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.clearsContextBeforeDrawing = YES;
    switch (self.hollowType) {
        case FHHollowTypeHollowDefault:
        {
            self.layer.borderWidth = 0;
            [self drawSubtractedTextInContext:context withBlendMode:kCGBlendModeDestinationOut];
        }
            break;
        case FHHollowTypeHollowBackground:
        {
            [self drawSubtractedTextInContext:context withBlendMode:kCGBlendModeNormal];
            self.layer.borderColor = self.hollowBackgroundColor.CGColor;
            self.layer.borderWidth = 2.0;
        }
            break;
        default:
            break;
    }
}

- (void)drawSubtractedTextInContext:(CGContextRef)context withBlendMode:(CGBlendMode)mode {
    // Save context state to not affect other drawing operations
    CGContextSaveGState(context);
    
    // Magic blend mode
    CGContextSetBlendMode(context, mode);

    // Label to center and adjust font automatically
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.font = self.hollowFont;
    label.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    label.text = self.hollowText;
    label.textAlignment = self.textAlignment;
    switch (mode) {
        case kCGBlendModeDestinationOut:
        {
            label.backgroundColor = self.hollowBackgroundColor;
        }
            break;
        case kCGBlendModeNormal:
        {
            label.backgroundColor = [UIColor clearColor];
            label.textColor = self.hollowBackgroundColor;
        }
        default:
            break;
    }
    [label.layer drawInContext:context];
    
    // Restore the state of other drawing operations
    CGContextRestoreGState(context);
}   
@end
