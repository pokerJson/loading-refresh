//
//  ViewController.m
//  下拉刷新
//
//  Created by dzc on 17/3/10.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController (){
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *bt = [UIButton buttonWithType:UIButtonTypeContactAdd];
    bt.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:bt];
    [bt addTarget:self action:@selector(cockkkk) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cockkkk
{
    SecondViewController *sec = [SecondViewController new];
    [self.navigationController pushViewController:sec animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
