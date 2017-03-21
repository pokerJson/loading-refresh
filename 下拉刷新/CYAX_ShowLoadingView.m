//
//  CYAX_ShowLoadingView.m
//  下拉刷新
//
//  Created by dzc on 17/3/17.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import "CYAX_ShowLoadingView.h"

@implementation CYAX_ShowLoadingView

/**
 *  对象单例化
 *
 *  @return 单例对象
 */
+ (CYAX_ShowLoadingView *)share{
    
    static CYAX_ShowLoadingView * instance = nil;
    if (!instance) {
        
        instance = [[CYAX_ShowLoadingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    
    return instance;
}
+ (void)showLoadingOnView:(UIView *)superView Type:(CYAX_ViewType)type{
    /*        在显示前  先从父视图移除当前动画视图         */
    
    CYAX_ShowLoadingView *instance = [[self class] share];
    [[self class] hideLoading];

    /*        按照type初始化动画         */
    switch (type) {
        case CYAX_ViewTypeSingleLine:
        {
            CALayer *layer = [instance lineAnimation];
            layer.position = instance.center;
            [instance.layer addSublayer:layer];
        }break;
            
        case CYAX_ViewTypeSquare:
        {
            CALayer *layer = [[self class] qurareAnimation];
            [instance.layer addSublayer:layer];
        }break;
        case CYAX_ViewTypeTriangleTranslate:
        {
            CALayer *layer = [[self class] triangleAnimation];
            [instance.layer addSublayer:layer];
        }break;
        
        default:
            break;
    }

    if (type == CYAX_ViewTypeSquare) {
        instance.center = CGPointMake(superView.bounds.size.width/2-5, superView.bounds.size.height/2-5);
    }else if (type == CYAX_ViewTypeTriangleTranslate){
        instance.center = CGPointMake(superView.bounds.size.width/2, superView.bounds.size.height/2);
    }else if(type == CYAX_ViewTypeSingleLine){
        instance.center = CGPointMake(superView.bounds.size.width/2-25, superView.bounds.size.height/2);
    }

    [superView addSubview:instance];

}
/**
 *  线性点动画
 *
 *  @return 动画实例对象
 */
- (CALayer *)lineAnimation{
    /*        创建模板层         */
    CAShapeLayer *shape           = [CAShapeLayer layer];
    shape.frame                   = CGRectMake(0, 0, 20, 20);
    shape.path                    = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
    shape.fillColor               = [UIColor redColor].CGColor;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform"];
    basic.fromValue         = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1, 1, 0)];
    basic.toValue           = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)];
    basic.duration          = 1.05;
    basic.repeatCount       = HUGE;
    
    [shape addAnimation:basic forKey:@"lineAnimation"];
    
    
    /*        创建克隆层的持有对象         */
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame              = CGRectMake(0, 0, 20, 20);
    replicator.instanceDelay      = 0.35;
    replicator.instanceCount      = 3;
    replicator.instanceTransform  = CATransform3DMakeTranslation(25, 0, 0);
    [replicator addSublayer:shape];
    
    return replicator;
    
}
/**
 *  正方形点动加载动画
 *
 *  @return <#return value description#>
 */
+ (CALayer *)qurareAnimation{
    /*        基本间距及模板层的创建         */
    NSInteger column                    = 3;
    CGFloat between                     = 5.0;
    CGFloat radius                      = (50 - between * (column - 1))/column;
    CAShapeLayer *shape                 = [CAShapeLayer layer];
    shape.frame                         = CGRectMake(0, 0, radius, radius);
    shape.path                          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.fillColor                     = [UIColor redColor].CGColor;
    
    
    /*        创建动画组         */
    //1
    /**
     *  缩小并自动恢复动画
     *
     */
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform"];
    basic.fromValue         = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1, 1, 0)];
    basic.toValue           = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)];
    basic.duration          = 0.8;
    basic.repeatCount       = HUGE;
    basic.autoreverses      = YES;

    //2
    /**
     *  透明度动画
     *
     */
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue         = @(1.0);
    alpha.toValue           = @(0.0);

    CAAnimationGroup *animationGroup    = [CAAnimationGroup animation];
    animationGroup.animations           = @[basic, alpha];
    animationGroup.duration             = 0.8;
    animationGroup.autoreverses         = YES;
    animationGroup.repeatCount          = HUGE;
    [shape addAnimation:animationGroup forKey:@"groupAnimation"];
    
    
    /*        创建第一行的动画克隆层对象         */
    CAReplicatorLayer *replicatorLayerX = [CAReplicatorLayer layer];
    replicatorLayerX.frame              = CGRectMake(0, 0, 100, 100);
    replicatorLayerX.instanceDelay      = 0.3;
    replicatorLayerX.instanceCount      = column;
    replicatorLayerX.instanceTransform  = CATransform3DTranslate(CATransform3DIdentity, radius+between, 0, 0);
    [replicatorLayerX addSublayer:shape];
    
    
    /*        创建3行的动画克隆层对象         */
    CAReplicatorLayer *replicatorLayerY = [CAReplicatorLayer layer];
    replicatorLayerY.frame              = CGRectMake(0, 0, 50, 50);
    replicatorLayerY.instanceDelay      = 0.3;
    replicatorLayerY.instanceCount      = column;
    
    
    /*        给CAReplicatorLayer对象的子层添加转换规则 这里决定了子层的布局         */
    replicatorLayerY.instanceTransform  = CATransform3DTranslate(CATransform3DIdentity, 0, radius+between, 0);
    [replicatorLayerY addSublayer:replicatorLayerX];
    return replicatorLayerY;
    
}

/**
 *  三角形运动动画
 *
 *  @return 动画实例对象
 */
+ (CALayer *)triangleAnimation{
    /*        基本间距确定及模板层的创建         */
    CGFloat radius                     = 50/4.0;
    CGFloat transX                     = 50 - radius;
    CAShapeLayer *shape                = [CAShapeLayer layer];
    shape.frame                        = CGRectMake(0, 0, radius, radius);
    shape.path                         = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor                  = [UIColor redColor].CGColor;
    shape.fillColor                    = [UIColor redColor].CGColor;
    shape.lineWidth                    = 1;
    
    /*
     旋转动画
     */
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
    scale.fromValue         = [NSValue valueWithCATransform3D:fromValue];
    CATransform3D toValue   = CATransform3DTranslate(CATransform3DIdentity, 50 - 50 / 4.0, 0.0, 0.0);
    toValue                 = CATransform3DRotate(toValue,2*M_PI/3.0, 0.0, 0.0, 1.0);
    scale.toValue           = [NSValue valueWithCATransform3D:toValue];
    scale.autoreverses      = NO;
    scale.repeatCount       = HUGE;
    scale.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.duration          = 0.8;

    [shape addAnimation:scale forKey:@"rotateAnimation"];
    
    /*        创建克隆层         */
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame              = CGRectMake(0, 0, radius, radius);
    replicatorLayer.instanceDelay      = 0.0;
    replicatorLayer.instanceCount      = 3;
    CATransform3D trans3D              = CATransform3DIdentity;
    trans3D                            = CATransform3DTranslate(trans3D, transX, 0, 0);
    trans3D                            = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicatorLayer.instanceTransform  = trans3D;
    [replicatorLayer addSublayer:shape];
    return replicatorLayer;
    
}

/**
 *  停止动画
 */
+ (void)hideLoading{
    [[[self class] share] removeFromSuperview];
}

@end
