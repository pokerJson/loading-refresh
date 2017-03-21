//
//  UIScrollView+CYAX_Refresh.m
//  下拉刷新
//
//  Created by dzc on 17/3/10.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import "UIScrollView+CYAX_Refresh.h"
#import <objc/runtime.h>
#import "CYAX_LoadingView.h"


typedef enum{
    WillLoading = 0,
    PullIsLoading ,
    PushIsLoading ,
}RefreshState;

static RefreshState refreshState = WillLoading;

@interface UILabel (refresh)
+ (instancetype)share;
@end

@implementation UILabel (refresh)

+ (instancetype)share
{
    static UILabel * label;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        label = [[UILabel alloc] init];
    });
    return label;
}

@end

/*
    2222222222
 */
#define ContentOfSet @"contentOffset"
#define PullWillLoadingTitle @"下拉即可刷新..."
#define PullIsLoadingTitle @"正在刷新..."
#define PushDeadLine 20

static char CYAX_RefreshBlockKey;

@implementation UIScrollView (CYAX_Refresh)

- (void)addCYAX_RefreshBlock:(CYAX_RefreshBlock)completion
{
    //给scrollview添加关联一个属性
    objc_setAssociatedObject(self, &CYAX_RefreshBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addObserver:self forKeyPath:ContentOfSet options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    CGPoint old = [[change objectForKey:@"old"] CGPointValue];
    if (new.y == old.y) {
        return;
    }
    NSLog(@"new.yyyyy===%f",new.y);

    if (new.y <= 0) {
        //下拉刷新
        [self pull_CYAX_RefreshWithChange:change];
    }else{
        //上啦
        [self push_CYAX_RefreshWithChange:change];
        
    }
}
#pragma mark 下拉 pull
- (void)pull_CYAX_RefreshWithChange:(NSDictionary *)change
{
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    CYAX_RefreshBlock headBlcok = objc_getAssociatedObject(self, &CYAX_RefreshBlockKey);

    //文字
    UILabel *titleLabel = [UILabel share];
    titleLabel.frame = CGRectMake(self.center.x-15, -35, 120, 30);
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    //动画
    CYAX_PullLodingView *loading = [CYAX_PullLodingView share];
    loading.frame = CGRectMake(self.center.x-30-30, -35, 30, 30);
    
    //
    if (loading.hasPan) {
        NSLog(@"UIGestureRecognizerStatePossible");
        titleLabel.text = @"松开刷新";
    }else{
        titleLabel.text = loading.isPullLoading ? PullIsLoadingTitle:PullWillLoadingTitle;

    }

    if (new.y<0) {
        NSLog(@"enddddd=====%ld",(long)self.panGestureRecognizer.state);
        [loading startCYAX_PullLoadingWithView:self withPullDistance:new.y withPanState:self.panGestureRecognizer.state];
        if (!self.dragging && loading.isPullLoading && refreshState == WillLoading) {
            
            refreshState = PullIsLoading;
            [UIView animateWithDuration:0.25 animations:^{
                self.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
            headBlcok(Pulling);
        }
    }
    
    if (self.contentOffset.y == 0) {
        [loading stopCYAX_Loading];
    }


}
#pragma mark 上啦 push
- (void)push_CYAX_RefreshWithChange:(NSDictionary *)change
{
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    CGPoint old = [[change objectForKey:@"old"] CGPointValue];
    
    CYAX_RefreshBlock footerBlock = objc_getAssociatedObject(self, &CYAX_RefreshBlockKey);
    
    /**
     超过警戒线开始加载更多数据
     */
    if (new.y >= self.contentSize.height-self.frame.size.height-PushDeadLine && new.y>old.y && refreshState == WillLoading) {
        refreshState = PushIsLoading;
        footerBlock(Push);
    }

}


- (void)stopRefresh {
    refreshState = WillLoading;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    CYAX_PullLodingView * loading = [CYAX_PullLodingView share];
    [loading stopCYAX_Loading];
}




















@end
