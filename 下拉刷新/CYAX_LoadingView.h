//
//  CYAX_PullLoadingView.h
//  下拉刷新
//
//  Created by dzc on 17/3/12.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    三角形图
 */
@interface Triangle : UIView

@end
//-----************************************--------


/*
    正常的动画view
 */
@interface CYAX_LoadingView : UIView
{
    Triangle *triangle;
}
@property (nonatomic,assign)BOOL isLoading;


+ (instancetype)share;

//开启加载
- (void)startCYAX_Loading;

//开启加载view
- (void)startCYAX_LoadingWithView:(UIView *)view withType:(NSInteger)type;

//关闭加载
- (void)stopCYAX_Loading;

@end

////////和谁谁谁水水水水水水水水
// <><><><><><><><><><><>分割线<><><><><><><<><><><><>分割线<><<><<><><><><><><><><><><><><>
/*
    下拉动画view
 */
@interface CYAX_PullLodingView : UIView

@property (nonatomic,assign) BOOL isPullLoading;
@property (nonatomic,assign) BOOL hasPan;

+ (instancetype)share;

/**
 *
 *  开启加载
 *  view
 *  progress
 *
 */
- (void)startCYAX_PullLoadingWithView:(UIView *)view withPullDistance:(CGFloat)distance withPanState:(NSInteger)state;

/**
 *
 *  关闭加载
 *
 */
- (void)stopCYAX_Loading;







@end
