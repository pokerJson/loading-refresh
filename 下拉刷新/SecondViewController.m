//
//  SecondViewController.m
//  下拉刷新
//
//  Created by dzc on 17/3/10.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import "SecondViewController.h"
#import "CYAX_LoadingView.h"
#import "CYAX_ShowLoadingView.h"
#import "UIScrollView+CYAX_Refresh.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableview;
    
    
    UIView *testView;
    UIView *testView2;
    UIView *testView3;
    UIView *testView4;
    UIView *testView5;
    
    UIView *testView6;


}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(slideCLick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(rightCLick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];

    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-100) style:UITableViewStylePlain];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview reloadData];
    [_tableview addCYAX_RefreshBlock:^(PanState PanState) {
        if (PanState == Pulling) {
            NSLog(@"1111");
        }else if (PanState == Push) {
            NSLog(@"2222");
        }
    }];
    [self.view addSubview:_tableview];


    //
    testView = [[UIView alloc]initWithFrame:CGRectMake(60, 80, 60, 60)];
    testView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testView];
    
    
    //放在self.view上ok
    
//    //2 单利只能存一个
    testView2 = [[UIView alloc]initWithFrame:CGRectMake(60, 150, 100, 60)];
    testView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:testView2];
    [CYAX_ShowLoadingView showLoadingOnView:testView2 Type:CYAX_ViewTypeSingleLine];
//
//    //3
//    testView3 = [[UIView alloc]initWithFrame:CGRectMake(60, 270, 100, 60)];
//    testView3.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:testView3];
//    [CYAX_ShowLoadingView showLoadingOnView:testView3 Type:CYAX_ViewTypeTriangleTranslate];
    
    //4
//    testView4 = [[UIView alloc]initWithFrame:CGRectMake(60, 340, 100, 100)];
//    testView4.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:testView4];
//    [CYAX_ShowLoadingView showLoadingOnView:testView4 Type:CYAX_ViewTypeSquare];


    //5
    testView5 = [[UIView alloc]initWithFrame:CGRectMake(200, 100, 100, 60)];
    testView5.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:testView5];


}
- (void)slideCLick
{
    CYAX_LoadingView *cyax_laodingView = [CYAX_LoadingView share];
    [cyax_laodingView startCYAX_LoadingWithView:self.view withType:0];
}
- (void)rightCLick
{
    CYAX_LoadingView * cyax_laodingView = [CYAX_LoadingView share];
    [cyax_laodingView stopCYAX_Loading];
    
    [_tableview stopRefresh];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row %2 == 0) {
        CYAX_LoadingView *cyax_laodingView = [CYAX_LoadingView share];
        [cyax_laodingView startCYAX_LoadingWithView:testView withType:1];

    }else{
        CYAX_LoadingView *cyax_laodingView = [CYAX_LoadingView share];
        [cyax_laodingView startCYAX_LoadingWithView:testView5 withType:2];

    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
