//
//  CYAX_ShowLoadingView.h
//  下拉刷新
//
//  Created by dzc on 17/3/17.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,CYAX_ViewType){
    /**
     *  线性动画
     */
    CYAX_ViewTypeSingleLine = 0,
    
    /**
     *  方形点动画
     */
    CYAX_ViewTypeSquare = 1,
    
    /**
     *  三角形运动动画
     */
    CYAX_ViewTypeTriangleTranslate = 2,
    
};

@interface CYAX_ShowLoadingView : UIView



+ (void)showLoadingOnView:(UIView *)superView Type:(CYAX_ViewType)type;

+ (void)hideLoading;

@end
