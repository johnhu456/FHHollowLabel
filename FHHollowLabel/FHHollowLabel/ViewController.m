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

@property (nonatomic, strong) FHLyricLabel *lyricLabel;
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
    
    self.backHollowedLabel = [[FHHollowLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textHollowedLabel.frame), 50 * 2 + kLabelHeight, kLabelWidth, kLabelHeight) hollowType:FHHollowTypeHollowBackground];
    _backHollowedLabel.hollowText = @"Yosemite";
    _backHollowedLabel.hollowBackgroundColor = [UIColor whiteColor];
    _backHollowedLabel.hollowFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
    _backHollowedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_backHollowedLabel];
    
    self.lyricLabel = [[FHLyricLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textHollowedLabel.frame), 50 * 4 + kLabelHeight, kLabelWidth, kLabelHeight) andDuration:0.5];
    self.lyricLabel.hollowText = @"Yosemite";
    self.lyricLabel.hollowBackgroundColor = [UIColor whiteColor];
    self.lyricLabel.hollowFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
    self.lyricLabel.textAlignment = NSTextAlignmentCenter;
    self.lyricLabel.lyricColor = [UIColor redColor];
    [self.view addSubview:self.lyricLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    FHHollowType tempType = self.textHollowedLabel.hollowType;
    self.textHollowedLabel.hollowType = self.backHollowedLabel.hollowType;
    self.backHollowedLabel.hollowType = tempType;
    
    if (self.lyricLabel.lyricState == FHLyricStateAnimating)
    {
        [self.lyricLabel pause];
    }
    else if (self.lyricLabel.lyricState == FHLyricStateFinished)
    {
        [self.lyricLabel stop];
    }
    else{
        [self.lyricLabel start];
    }
}

@end
