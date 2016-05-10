//
//  ViewController.m
//  FHHollowLabel
//
//  Created by MADAO on 16/5/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"
#import "FHHollowLabel.h"


@interface ViewController ()

@property (nonatomic, strong) FHHollowLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height/2.0)];
    backView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backView];
    
    self.label = [[FHHollowLabel alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    self.label.text = @"fsdfsfs这";
    self.label.backgroundColor = [UIColor blackColor];
//    self.label.text = @"这是一行镂空文字";
//    self.label.backgroundColor = [UIColor blackColor];
    
    NSLog(@"%@",self.label.text);
    
    //    _hollowOutLabel.alpha = 0.7;
    self.label.font = [UIFont boldSystemFontOfSize:20];
   self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
//    label.hollow = NO;
//    label.hollow = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.label.hollow = !self.label.hollow;
//    NSLog(@"%@",self.label.hollow?@"YES":@"NO");
//    
//    NSLog(@"%@",self.label.text);
    
    self.label.transform = CGAffineTransformTranslate(self.label.transform, 0, 10);
}

@end
