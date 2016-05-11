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

@interface FHHollowLabel()

@property (nonatomic, strong) NSMutableDictionary  *propertyDic;

@end
@implementation FHHollowLabel
{
//    NSString * _text;
    UIFont * _font;
    UIColor * _backgroundColor;
    CGRect _frame;
}

#pragma mark - 重写对应的set方法
//- (void)setText:(NSString *)text
//{
//    [self.propertyDic setValue:[text copy] forKey:@"text"];
//    [super setText:text];
////    [super setText:[text stringByAppendingString:@"哈"]];
////    _hollowText1 = text;
//}
//
//- (NSString *)fakeText{
//    NSString *text = [self.propertyDic valueForKey:@"text"];
//    return [text stringByAppendingString:@"哈"];
//}
//
//- (NSString *)trueText{
//    return [self.propertyDic valueForKey:@"text"];
////    return [[self fakeText] stringByReplacingCharactersInRange:NSMakeRange([self fakeText].length - 1, 1) withString:@""];
//}
//
//- (NSString *)text{
//    return [self trueText];
//}

//- (NSString *)text
//{
//    return [self trueText];
//
////    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:[super text]];
////    [mutableString deleteCharactersInRange:NSMakeRange([super text].length - 1, 1)];
////    return [mutableString copy];
////    return @"dsadasd";
////    NSString *resultString = [self fakeText];
////    return [resultString stringByReplacingCharactersInRange:NSMakeRange(resultString.length - 1, 1) withString:@""];
//}

//- (NSString *)text
//{
//    self.mode ++;
//    NSLog(@"%d",self.mode);
//    if (self.mode == 1)
//    {
//        return [self fakeText];
//    }
//    else{
//        return [self.propertyDic valueForKey:@"text"];
//    }
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
//- (void)sizeToFit
//{
//
//    
//}

- (instancetype)init//禁止使用此方法初始化
{
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.mode = kCGBlendModeNormal;
//        [self exchangeGetMethod];
        self.propertyDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)exchangeGetMethod{
    Method originGetMethod = class_getInstanceMethod([FHHollowLabel class], @selector(text));
    Method myGetMethod = class_getInstanceMethod([FHHollowLabel class], @selector(trueText));
    method_exchangeImplementations(myGetMethod, originGetMethod);
}

id dynmaicGetMethod(id self,SEL _cmd)
{
    NSString *key = NSStringFromSelector(_cmd);
    FHHollowLabel *selfLabel = (FHHollowLabel *)self;
    return [selfLabel.propertyDic objectForKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selectorName = NSStringFromSelector(sel);
    if ([selectorName hasPrefix:@"text"]) {
        //是Set方法
        class_addMethod(self, sel, (IMP)dynmaicGetMethod, "@:@");
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    [self drawSubtractedText:self.text inRect:_frame inContext:context];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetWidth(rect)/2, 0, 2*M_PI, YES);
    CGContextFillPath(context);
//    [self performSelector:NSSelectorFromString(@"_contentInsetsFromFonts") withObject:nil afterDelay:0];
//    objc_msgSend(NSSelectorFromString(@"_contentInsetsFromFonts"));
//    objc_msgSend();
//    objc_msgSend(self,NSSelectorFromString(@"_contentInsetsFromFonts"));
    [self drawSubtractedText:self.text inRect:rect inContext:context];
}

//- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect inContext:(CGContextRef)context
//{
//    //将当前图形状态推入堆栈
//    CGContextSaveGState(context);
//
//    //设置混合色
//    CGContextSetBlendMode(context, self.mode);
//    
//    //label上面添加label
//    UILabel *label = [[UILabel alloc] initWithFrame:rect];
//    label.font = _font;
//    NSString *title = [self.propertyDic valueForKey:@"text"];
//    label.text = title;
//    
////    label.text = [self fakeText];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = _backgroundColor;
//    
//    [label.layer drawInContext:context];
////    [self drawLayer:label.layer inContext:context];
//    
//    //把堆栈顶部的状态弹出，返回到之前的图形状态
//    CGContextRestoreGState(context);
//    class_addMethod([self class], @selector(text), (IMP)dynmaicGetMethod, "@:@");
    
    
    
    
//}

- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect inContext:(CGContextRef)context {
    // Save context state to not affect other drawing operations
    CGContextSaveGState(context);
    
    // Magic blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    
    // This seemingly random value adjusts the text
    // vertically so that it is centered in the circle.
    CGFloat Y_OFFSET = -2 * (float)[text length] + 5;
    
    // Context translation for label
    CGFloat LABEL_SIDE = CGRectGetWidth(rect);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(rect)/2-LABEL_SIDE/2+Y_OFFSET);
//    NSString *title = self.text;
    // Label to center and adjust font automatically
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LABEL_SIDE, LABEL_SIDE)];
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:120];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label.layer drawInContext:context];
    
    // Restore the state of other drawing operations
    CGContextRestoreGState(context);
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
//    if ([self.text containsString:@"哈"]) {
//        self.text = [self trueText];
//        NSLog(@"哈：%@   %@",self.text,[self trueText]);
//        [super drawLayer:layer inContext:ctx];
//    }
//    else
//    {
//        
//        self.text = [self fakeText];
//         NSLog(@"shi:%@   %@",self.text,[self fakeText]);
//        [super drawLayer:layer inContext:ctx];
//    }
    if ([self.text containsString:@"哈"]){
        NSString *title = self.text;
//        self.text = [title stringByReplacingCharactersInRange:NSMakeRange(self.text.length - 1, 1) withString:@""];
        self.text = @"s787564645535dfgghghjhj";
        [super drawLayer:layer inContext:ctx];
    }
    else
    {
        self.text = [self.text stringByAppendingString:@"哈"];
        [super drawLayer:layer inContext:ctx];
    }
}
@end
