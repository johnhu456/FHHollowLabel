//
//  FHHollowLabel.m
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHHollowLabel.h"
#import <objc/runtime.h>

//@implementation FHHollowLabel
//{
//    CGRect _hollowFrame;
//    NSString * _hollowText;
//    UIFont * _hollowFont;
//    UIColor * _hollowBackgroundColor;
//    NSTextAlignment _hollowTextAlignment;
//    
//    UILabel *_fakeBackgroundLabel;
//    
//    NSString *_returnValue;
//}
//
////- (void)setText:(NSString *)text
////{
//////    [super setText:text];
////////////    [self mySetText:text];
////////////    NSLog(@"DOING");
//////////    
//////////    
////    _hollowText = text;
//////////
//////////    
////////////    _text = text;
////////////    _returnValue = text;
////}
//
////-(NSString *)text
////{
////    return _returnValue;
////}
//
//- (void)setFont:(UIFont *)font
//{
//    _hollowFont = font;
//}
//
//- (UIFont *)font
//{
//    return _hollowFont;
//}
//
//- (void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    _hollowBackgroundColor = backgroundColor;
//}
//
//-(UIColor *)backgroundColor
//{
//    return _hollowBackgroundColor;
//}
//
//- (void)setTextAlignment:(NSTextAlignment)textAlignment
//{
//    _hollowTextAlignment = textAlignment;
//}
//
//-(NSTextAlignment)textAlignment
//{
//    return _hollowTextAlignment;
//}
//
////- (void)setHollow:(BOOL)hollow
////{
////    _hollow = hollow;
////    if (_hollow) {
////        _fakeBackgroundLabel.backgroundColor = [UIColor clearColor];
////    }
////    else{
////        _fakeBackgroundLabel.backgroundColor = self.textColor;
////    }
////}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        _hollowFrame = frame;
////        _fakeBackgroundLabel = [[UILabel alloc] initWithFrame:self.bounds];
////        _fakeBackgroundLabel.backgroundColor = self.textColor;
////        [self addSubview:_fakeBackgroundLabel];
//    
//    }
//    return self;
//}
//
//- (void)methodSwizzling
//{
////    Method originSet = class_getInstanceMethod([UILabel class], @selector(setText:));
////    Method mySet = class_getInstanceMethod([UILabel class], @selector(mySetText:));
////    method_exchangeImplementations(originSet, mySet);
//}
//
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self addHollowTextInContext:context inRect:_hollowFrame];
//}
//
//- (void)addHollowTextInContext:(CGContextRef)context inRect:(CGRect)rect
//{
//    CGContextSaveGState(context);
//    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
//    
//    UILabel *drawLabel = [[UILabel alloc] initWithFrame:rect];
//    [drawLabel setText:self.text];
//    drawLabel.font = [UIFont boldSystemFontOfSize:20];
//    drawLabel.backgroundColor = _hollowBackgroundColor;
//    drawLabel.textAlignment = _hollowTextAlignment;
//    [drawLabel.layer drawInContext:context];
//    
//    CGContextRestoreGState(context);
//}

@implementation FHHollowLabel
{
    NSString * _text;
    UIFont * _font;
    UIColor * _backgroundColor;
    CGRect _frame;
}

#pragma mark - 重写对应的set方法
//- (void)setText:(NSString *)text
//{
//    _text = text;
//}

- (void)setFont:(UIFont *)font
{
    _font = font;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
}

//这个方法会出问题，因而重写置空
- (void)sizeToFit
{
    
}

- (instancetype)init//禁止使用此方法初始化
{
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
    }
    return self;
}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawSubtractedText:_text inRect:_frame inContext:context];
}

- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect inContext:(CGContextRef)context
{
    //将当前图形状态推入堆栈
    CGContextSaveGState(context);
    
    //设置混合色
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    
    //label上面添加label
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = _font;
    label.text = self.text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = _backgroundColor;
    
    [label.layer drawInContext:context];
    
    //把堆栈顶部的状态弹出，返回到之前的图形状态
    CGContextRestoreGState(context);
}
@end
