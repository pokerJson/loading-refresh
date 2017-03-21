//
//  UIScrollView+CYAX_Refresh.h 超有爱心
//  下拉刷新
//
//  Created by dzc on 17/3/10.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    Pulling = 0,
    Push,
}PanState;

typedef void(^CYAX_RefreshBlock)(PanState PanState);

@interface UIScrollView (CYAX_Refresh)


/*
 添加下拉刷新
 */
- (void)addCYAX_RefreshBlock:(CYAX_RefreshBlock)completion;

/*
 stop刷新
 */
- (void)stopRefresh;

@end
