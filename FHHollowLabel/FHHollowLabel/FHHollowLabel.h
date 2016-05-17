//
//  FHHollowLabel.h
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

/**设置镂空字（TypeDefault）只能使用hollowText,hollowFont,hollowBackgroundColor属性，不能使用原生属性，否则没有镂空效果。*/




@interface FHHollowLabel : UILabel

typedef NS_ENUM(NSInteger){
    FHHollowTypeHollowDefault = 0,
    FHHollowTypeHollowBackground = 1
}FHHollowType;

@property (nonatomic, strong) NSString *hollowText;

@property (nonatomic, strong) UIFont *hollowFont;

@property (nonatomic, strong) UIColor *hollowBackgroundColor;

@property (nonatomic, assign) FHHollowType hollowType;

@property (nonatomic, assign, getter= isHollow) BOOL hollow;

- (instancetype)initWithFrame:(CGRect)frame hollowType:(FHHollowType)type;

@end

#pragma mark - FHLyricLabel

@interface FHLyricLabel : FHHollowLabel

typedef NS_ENUM(NSInteger){
    FHLyricStateStandBy,
    FHLyricStateFinished,
    FHLyricStateUnFinished,
    FHLyricStateAnimating,
    FHLyricStateStoping
}FHLyricState;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) UIColor *lyricColor;

@property (nonatomic, assign, readonly) FHLyricState lyricState;

- (instancetype)initWithFrame:(CGRect)frame andDuration:(CGFloat)duration;

- (void)start;

- (void)pause;

- (void)stop;

- (void)moveToProgress:(CGFloat)progress withAnimate:(BOOL)animate;

@end