//
//  FHHollowLabel.h
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

/**一个展示镂空字的Label，想要正常使用，必须使用initWithFrame方法，而不能使用init*/

@interface FHHollowLabel : UILabel

@property (nonatomic, strong) NSString *hollowText1;

@property (nonatomic, assign, getter= isHollow) BOOL hollow;

@property (nonatomic, assign) CGBlendMode mode;

- (void)mySetText:(NSString *)text;

//- (NSString *)trueText;
@end
