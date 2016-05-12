//
//  FHHollowLabel.h
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

/**设置镂空字只能使用hollowText属性，不能使用text属性。*/

@interface FHHollowLabel : UILabel

@property (nonatomic, strong) NSString *hollowText;

@property (nonatomic, strong) UIFont *hollowFont;

@property (nonatomic, strong) UIColor *hollowBackgroundColor;

@property (nonatomic, assign, getter= isHollow) BOOL hollow;

@property (nonatomic, assign) CGBlendMode mode;

@end
