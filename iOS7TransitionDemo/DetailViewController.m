//
//  DetailViewController.m
//  iOS7TransitionDemo
//
//  Created by 陈爱彬 on 15/4/3.
//  Copyright (c) 2015年 陈爱彬. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 120, 40);
    button.center = self.view.center;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Dismiss Me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onDismissButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onDismissButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
