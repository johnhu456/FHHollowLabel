//
//  ViewController.m
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"
#import "FHHollowLabel.h"
#import <objc/runtime.h>

static CGFloat const kLabelWidth = 100.f;
static CGFloat const kLabelHeight = 50.f;

@interface ViewController ()

@property (nonatomic, strong) FHHollowLabel *textHollowedLabel;

@property (nonatomic, strong) FHHollowLabel *backHollowedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textHollowedLabel = [[FHHollowLabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - kLabelWidth/2, 50, kLabelWidth, kLabelHeight)];
    self.textHollowedLabel.hollowText = @"Yosemite";
    self.textHollowedLabel.hollowBackgroundColor = [UIColor whiteColor];
    self.textHollowedLabel.hollowFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
    self.textHollowedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textHollowedLabel];
    
    FHHollowLabel *backHollowedLabel = [[FHHollowLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textHollowedLabel.frame), 50 * 2 + kLabelHeight, kLabelWidth, kLabelHeight) hollowType:FHHollowTypeHollowBackground];
    backHollowedLabel.hollowText = @"Yosemite";
    backHollowedLabel.hollowBackgroundColor = [UIColor whiteColor];
    backHollowedLabel.hollowFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
    backHollowedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backHollowedLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.textHollowedLabel.hollowType = FHHollowTypeHollowBackground;
    self.backHollowedLabel.hollowType = FHHollowTypeHollowDefault;
}

@end
