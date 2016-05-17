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

#pragma mark - FHLyricLabel
@interface FHLyricLabel()
{
    UIColor *_lyricColor;
}
@property (nonatomic, strong) UILabel *backMoveLabel;

@property (nonatomic, strong) FHHollowLabel *realHollowLabel;

@property (nonatomic, strong) NSTimer *lyricTimer;

@property (nonatomic, assign, readwrite) FHLyricState lyricState;

@property (nonatomic, assign) CGFloat countDuration;
//
//@property (nonatomic, assign, readwrite) BOOL animating;
//
//@property (nonatomic, assign, readwrite) BOOL finished;

@end

@implementation FHLyricLabel

/**防止两边超出的保护宽度*/
static CGFloat const kSideSafeWith = 2;

- (UIColor *)lyricColor
{
    if (_lyricColor == nil){
        _lyricColor = [UIColor blackColor];
    }
    return _lyricColor;
}

- (void)setLyricColor:(UIColor *)lyricColor
{
    _lyricColor = lyricColor;
    self.backMoveLabel.backgroundColor = _lyricColor;
}


- (UILabel *)backMoveLabel
{
    if (_backMoveLabel == nil) {
        _backMoveLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideSafeWith, 0, 0, self.bounds.size.height)];
        _backMoveLabel.backgroundColor = self.lyricColor;
    }
    return _backMoveLabel;
}

- (instancetype)initWithFrame:(CGRect)frame andDuration:(CGFloat)duration
{
    if(self = [super initWithFrame:frame hollowType:FHHollowTypeHollowDefault]){
        _duration = duration;
        _lyricState = FHLyricStateStandBy;
        _countDuration = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.realHollowLabel = [[FHHollowLabel alloc] initWithFrame:self.bounds hollowType:FHHollowTypeHollowDefault];
    self.realHollowLabel.hollowText = self.hollowText;
    self.realHollowLabel.hollowFont = self.hollowFont;
    self.realHollowLabel.hollowBackgroundColor = self.hollowBackgroundColor;
    [self addSubview:self.backMoveLabel];
    [self addSubview:self.realHollowLabel];
}

#pragma mark - LyricOperate
- (void)start
{
    if ([self.lyricTimer isValid] && self.lyricState != FHLyricStateStandBy) {
        return;
    }
    self.lyricTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveByProgress) userInfo:nil  repeats:YES];
}

- (void)pause
{
    [self.lyricTimer invalidate];
    self.lyricState = FHLyricStateUnFinished;
}

- (void)stop
{
    [self pause];
    self.backMoveLabel.frame = CGRectMake(kSideSafeWith, 0, 0, self.bounds.size.height);
    self.lyricState = FHLyricStateStandBy;
}
- (void)moveToProgress:(CGFloat)progress withAnimate:(BOOL)animate
{
    __weak typeof(self) weakSelf = self;
    CGFloat desWidth = self.bounds.size.width * progress;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backMoveLabel.frame = CGRectMake(kSideSafeWith, 0, desWidth, self.bounds.size.height);
        }];
    }
    else
    {
        self.backMoveLabel.frame = CGRectMake(kSideSafeWith, 0, desWidth, self.bounds.size.height);
    }
    _countDuration = progress * _duration;
    
}

-(void)moveByProgress{
    if (self.lyricState != FHLyricStateAnimating) {
        self.lyricState = FHLyricStateAnimating;
    }
    if (_countDuration >= _duration) {
        [self.lyricTimer invalidate];
        self.lyricState = FHLyricStateFinished;
        _countDuration = 0;
        return ;
    }
    CGFloat stepWidth = (CGFloat)(self.bounds.size.width/_duration)/100.0;
    self.backMoveLabel.frame = CGRectMake(kSideSafeWith, 0, self.backMoveLabel.frame.size.width + stepWidth, self.bounds.size.height);
    _countDuration += 0.01;
}
@end
