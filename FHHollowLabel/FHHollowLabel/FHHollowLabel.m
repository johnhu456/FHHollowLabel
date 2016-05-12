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

@interface FHHollowLabel()
{
    NSException *_errorExcption;
}

@end

@implementation FHHollowLabel
{
    UIFont * _font;
    UIColor * _backgroundColor;
    CGRect _frame;
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
    NSException *excption = [[NSException alloc] initWithName:@"initError" reason:@"Please use method 'initWithFrame:' instead of 'init'" userInfo:nil];
    [excption raise];
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


#pragma mark - 绘制
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawSubtractedText:self.hollowText inRect:rect inContext:context];
}

- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect inContext:(CGContextRef)context {
    // Save context state to not affect other drawing operations
    CGContextSaveGState(context);
    
    // Magic blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);

    // Label to center and adjust font automatically
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.font = self.hollowFont;
    label.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    label.text = text;
    label.textAlignment = self.textAlignment;
    label.backgroundColor = self.hollowBackgroundColor;
    [label.layer drawInContext:context];
    
    // Restore the state of other drawing operations
    CGContextRestoreGState(context);
}   
@end
