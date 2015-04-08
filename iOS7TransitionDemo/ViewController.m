//
//  ViewController.m
//  iOS7TransitionDemo
//
//  Created by 陈爱彬 on 15/4/3.
//  Copyright (c) 2015年 陈爱彬. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CustomTransitionAnimation.h"

@interface ViewController ()

@property (nonatomic,strong) CustomTransitionAnimation *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 120, 40);
    button.center = self.view.center;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)onButtonTapped
{
    if (!_animator) {
        self.animator = [[CustomTransitionAnimation alloc] init];
    }
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.transitioningDelegate = self.animator;
    //设置可交互的ViewController，将为该ViewController添加手势交互
    [self.animator setPresentingVC:vc];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
