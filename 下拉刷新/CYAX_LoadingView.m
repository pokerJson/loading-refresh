//
//  CYAX_PullLoadingView.m
//  下拉刷新
//
//  Created by dzc on 17/3/12.
//  Copyright © 2017年 dzc. All rights reserved.
//

#import "CYAX_LoadingView.h"
#import "AppDelegate.h"

//角度
#define ANGLE(angle) ((M_PI*angle)/180)
#define RotationAnimation @"rotationAnimation"
#define  NSTimeInterval 0.7;

static CAShapeLayer *subLayer;



/*
    三角图triangle
 */
@implementation Triangle

- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.frame.size.width*0.65;
    CGFloat width2=width/(sqrt(3));
    
    CGFloat centerX =self.frame.size.width/2;
    CGFloat centerY =self.frame.size.width/2;
    
    CGPoint PointA=CGPointMake(centerX+(width*(2/3.0)), centerY);
    CGPoint PointB=CGPointMake(PointA.x-width, PointA.y-width2);
    CGPoint PointC=CGPointMake(PointB.x, PointB.y+2*width2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:PointA];
    [path addLineToPoint:PointB];
    [path addLineToPoint:PointC];
    
    [path closePath];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f];
    [fillColor set];
    [path fill];
    
    
    // 根据我们设置的各个点连线
    [path stroke];

}

@end
//------*****************____________+++++++++++++++

@implementation CYAX_LoadingView

+ (instancetype)share
{
    static CYAX_LoadingView *loadingView;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        loadingView = [[CYAX_LoadingView alloc]init];
        loadingView.frame = CGRectMake(0, 0, 40, 40);
    });
    return loadingView;
}

#pragma mark 开启加载
- (void)startCYAX_Loading
{

}
- (void)startCYAX_LoadingWithView:(UIView *)view withType:(int)type
{
    if (!_isLoading) {
        if (type == 0) {
            /*
             第一个
             */
            
            //半径
            CGFloat raduis = self.bounds.size.width/2;
            //画个圆 clockwise=yes 顺时针
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(raduis*2, raduis)];
            [path addArcWithCenter:CGPointMake(raduis, raduis) radius:raduis startAngle:0 endAngle:ANGLE(330) clockwise:YES];
            path.lineWidth = 2;
            path.lineCapStyle = kCGLineCapRound;
            [path stroke];//闭合
            
            //shapelayer 渲染
            subLayer = [CAShapeLayer layer];
            subLayer.path = path.CGPath;
            subLayer.strokeColor = [UIColor grayColor].CGColor;//圆线条的颜色
            subLayer.fillColor = [UIColor clearColor].CGColor;//圆内部颜色
            subLayer.strokeStart = 0;
            subLayer.strokeEnd = 0;
            subLayer.lineWidth = 4;//宽度线条
            subLayer.frame = self.bounds;

            
            // 画线动画
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 2.0;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0];
            pathAnimation.toValue = [NSNumber numberWithFloat:1];
            pathAnimation.removedOnCompletion = NO;
            pathAnimation.fillMode = kCAFillModeForwards;
            [subLayer addAnimation:pathAnimation forKey:nil];
            
            //动起来
            CABasicAnimation *basciAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            basciAnimation.duration = 1;
            basciAnimation.removedOnCompletion = NO;//配合下面这一条使用
            basciAnimation.fillMode = kCAFillModeForwards;
            basciAnimation.repeatCount = HUGE_VALF;//无穷大
            basciAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
            [self.layer addAnimation:basciAnimation forKey:RotationAnimation];
            
            [self.layer addSublayer:subLayer];
            self.frame = CGRectMake((view.frame.size.width-40)/2, (view.frame.size.height-40)/2, 40, 40);
            [view addSubview:self];//传进来的view 添加这个圆
            
        
            _isLoading = YES;


        }else if (type == 1){
            /*
                第二
             */
            
            //半径
            CGFloat raduis = self.bounds.size.width/2;
            //画个圆 clockwise=yes 顺时针
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(raduis*2, raduis)];
            [path addArcWithCenter:CGPointMake(raduis, raduis) radius:raduis startAngle:0 endAngle:ANGLE(360) clockwise:YES];
            path.lineWidth = 2;
            path.lineCapStyle = kCGLineCapRound;
            [path stroke];//闭合
            
            //shapelayer 渲染
            subLayer = [CAShapeLayer layer];
            subLayer.path = path.CGPath;
            subLayer.strokeColor = [UIColor grayColor].CGColor;//圆线条的颜色
            subLayer.fillColor = [UIColor clearColor].CGColor;//圆内部颜色
            subLayer.strokeStart = 0;
            subLayer.strokeEnd = 0;
            subLayer.lineWidth = 4;//宽度线条
            subLayer.frame = self.bounds;

            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"transform.rotation";
            animation.duration = 1.5 / 0.375f;
            animation.fromValue = @(0.f);
            animation.toValue = @(2 * M_PI);
            animation.repeatCount = MAXFLOAT;
            animation.removedOnCompletion = NO;
            [subLayer addAnimation:animation forKey:@"aaaa"];
            
            
            CABasicAnimation *headAnimation = [CABasicAnimation animation];
            headAnimation.keyPath = @"strokeStart";
            headAnimation.duration = 1.5 / 1.5f;
            headAnimation.fromValue = @(0.f);
            headAnimation.toValue = @(0.25f);
            headAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            CABasicAnimation *tailAnimation = [CABasicAnimation animation];
            tailAnimation.keyPath = @"strokeEnd";
            tailAnimation.duration = 1.5 / 1.5f;
            tailAnimation.fromValue = @(0.f);
            tailAnimation.toValue = @(1.f);
            tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
            endHeadAnimation.keyPath = @"strokeStart";
            endHeadAnimation.beginTime = 1.5 / 1.5f;
            endHeadAnimation.duration = 1.5 / 3.0f;
            endHeadAnimation.fromValue = @(0.25f);
            endHeadAnimation.toValue = @(1.f);
            endHeadAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
            endTailAnimation.keyPath = @"strokeEnd";
            endTailAnimation.beginTime = 1.5 / 1.5f;
            endTailAnimation.duration = 1.5 / 3.0f;
            endTailAnimation.fromValue = @(1.f);
            endTailAnimation.toValue = @(1.f);
            endTailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            CAAnimationGroup *animations = [CAAnimationGroup animation];
            [animations setDuration:1.5];
            [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
            animations.repeatCount = MAXFLOAT;
            animations.removedOnCompletion = NO;
            [subLayer addAnimation:animations forKey:@"cccc"];

            [self.layer addSublayer:subLayer];

            self.frame = CGRectMake((view.frame.size.width-40)/2, (view.frame.size.height-40)/2, 40, 40);
            [view addSubview:self];//传进来的view 添加这个圆
            
            _isLoading = YES;

        }else if (type == 2){
            //
            

            Triangle *centerImage=[Triangle new];
            centerImage.backgroundColor = [UIColor clearColor];
            triangle=centerImage;
            centerImage.frame=CGRectMake(0,0, self.bounds.size.width*0.5, self.bounds.size.width*0.5);
            centerImage.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
            
            [self addSubview:triangle];
            
            //画一个圆
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.fillColor=[UIColor clearColor].CGColor;
            //将路径赋值给CAShapeLayer
            maskLayer.path = path.CGPath;
            
            //设置路径的颜色
            maskLayer.strokeColor=[UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
            //设置路径的宽度
            maskLayer.lineWidth=1;
            maskLayer.lineCap=kCALineCapRound;
            
            [self.layer addSublayer:maskLayer];
            subLayer = maskLayer;
            
            
            subLayer.transform=CATransform3DRotate(subLayer.transform, -M_PI_2, 0, 0, 1);
            subLayer.transform=CATransform3DTranslate(subLayer.transform, -self.bounds.size.width,0,0);
            [self animationOne];
            
            self.frame = CGRectMake((view.frame.size.width-40)/2, (view.frame.size.height-40)/2, 40, 40);
            [view addSubview:self];//传进来的view 添加这个圆


        }
        
    }
    

}
-(void)animationOne
{
    
    /*注意
     我们知道，使用 CAAnimation 如果不做额外的操作，动画会在结束之后返回到初始状态。或许你会这么设置：
     
     radiusAnimation.fillMode = kCAFillModeForwards;
     radiusAnimation.removedOnCompletion = NO;
     
     但这不是正确的方式。正确的做法可以参考 WWDC 2011 中的 session 421 - Core Animation Essentials。
     Session 中推荐的做法是先显式地改变 Model Layer 的对应属性，再应用动画。这样一来，我们甚至省去了 toValue。
     首先显式地设定属性的终止状态，strokeEnd的值为:self.maskLayer.strokeEnd=0.98;
     */
    
    subLayer.strokeStart=0;
    //设置strokeEnd的最终值，动画的fromValue为0，strokeEnd的最终值为0.98
    subLayer.strokeEnd=0.98;
    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    BasicAnimation.fromValue=@(0);
    
    BasicAnimation.duration=NSTimeInterval;
    
    BasicAnimation.delegate=self;
    [BasicAnimation setValue:@"BasicAnimationEnd" forKey:@"animationName"];
    
    
    
    [subLayer addAnimation:BasicAnimation forKey:@"BasicAnimationEnd"];
}
-(void)animationTwo
{
    subLayer.strokeStart=0.98;
    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
    BasicAnimation.fromValue=@(0);
    //BasicAnimation.toValue=@(1);
    BasicAnimation.duration=NSTimeInterval;
    //BasicAnimation.repeatCount=MAXFLOAT;
    
    BasicAnimation.delegate=self;
    [BasicAnimation setValue:@"BasicAnimationStart" forKey:@"animationName"];
    [subLayer addAnimation:BasicAnimation forKey:@"BasicAnimationStart"];
}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    
    if([[anim valueForKey:@"animationName"] isEqualToString:@"BasicAnimationEnd"])
    {
        
        //当画圆的动画完成后同时开始三角形旋转和开始圆消失的动画
        
        //开始三角形旋转
        CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        BasicAnimation.toValue=@(M_PI*2);
        BasicAnimation.duration=NSTimeInterval;
        
        BasicAnimation.delegate=self;
        [BasicAnimation setValue:@"BasicAnimationRotation" forKey:@"animationName"];
        [triangle.layer addAnimation:BasicAnimation forKey:@"BasicAnimationRotation"];
        
        //开始圆消失的动画
        [self animationTwo];
    }
    else if([[anim valueForKey:@"animationName"] isEqualToString:@"BasicAnimationStart"])
    {
        
        //当圆消失动画完成后，清除所有动画从新开始画圆动画
        [subLayer removeAllAnimations];
        [triangle.layer removeAllAnimations];
        [self animationOne];
    }
    
    
}

#pragma mark 关闭
- (void)stopCYAX_Loading
{
    [self.layer removeAnimationForKey:RotationAnimation];
    [subLayer removeFromSuperlayer];
    [triangle removeFromSuperview];
    _isLoading = NO;
}

@end

//*********分割线************++++++++++++++++**********************
/*
    CYAX_PullLodingView
 */

static CAShapeLayer * pullLayer;
static CAShapeLayer * lineLayer;
//下拉最大距离
#define MaxPullingDistance -100.0

@implementation CYAX_PullLodingView

+ (instancetype)share
{
    static CYAX_PullLodingView *view;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        view = [[CYAX_PullLodingView alloc]init];
    });
    return view;
}

- (void)startCYAX_PullLoadingWithView:(UIView *)view withPullDistance:(CGFloat)distance withPanState:(NSInteger)state
{
    if (!_isPullLoading) {
        //半径
        CGFloat radius = self.frame.size.width/2;
        pullLayer.path = nil;
        lineLayer.path = nil;
        
        //圆
        UIBezierPath *roundPath = [UIBezierPath bezierPath];
        [roundPath moveToPoint:CGPointMake(radius*2, radius)];
        CGFloat angle = distance<MaxPullingDistance ? 330:(distance *330)/MaxPullingDistance;
        CGFloat angle1 = angle>0?angle:0;
        [roundPath addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:ANGLE(angle1) clockwise:YES];
        [roundPath stroke];
        
        // 画箭头
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(radius, radius/2)];
        [linePath addLineToPoint:CGPointMake(radius, radius*2-radius/2)];
        [linePath addLineToPoint:CGPointMake(radius*2/3, radius+radius/4)];
        [linePath moveToPoint:CGPointMake(radius, radius*2-radius/2)];
        [linePath addLineToPoint:CGPointMake(radius/3+radius, radius+radius/4)];
        linePath.lineCapStyle = kCGLineCapRound;
        linePath.lineJoinStyle = kCGLineJoinRound;
        [linePath stroke];

        // 渲染
        pullLayer = [CAShapeLayer layer];
        pullLayer.path = roundPath.CGPath;
        pullLayer.strokeColor = [UIColor grayColor].CGColor;
        pullLayer.fillColor = [UIColor clearColor].CGColor;
        pullLayer.lineJoin = kCALineJoinRound;
        pullLayer.lineCap = kCALineCapRound;
        pullLayer.strokeStart = 0;
        pullLayer.strokeEnd = 1;
        pullLayer.lineWidth = 1.5;

        lineLayer = [CAShapeLayer layer];
        lineLayer.path = linePath.CGPath;
        lineLayer.frame = self.frame;
        lineLayer.strokeColor = [UIColor grayColor].CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.lineJoin = kCALineJoinRound;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.strokeStart = 0;
        lineLayer.strokeEnd = 1;
        lineLayer.lineWidth = 1.5;

        if (![lineLayer.superlayer isEqual:self.superview.layer]) {
            [self.superview.layer addSublayer:lineLayer];
        }

        // 超过下拉警戒线后，开启旋转
        if (distance < MaxPullingDistance && state != 0) {
            _hasPan = YES;
        }else if(distance > MaxPullingDistance){
            _hasPan = NO;
        }
        if (distance < MaxPullingDistance && state == 0) {
            _hasPan = NO;
            // 旋转动画
            CABasicAnimation * rotaion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotaion.duration = 1;
            rotaion.removedOnCompletion = NO;
            rotaion.fillMode = kCAFillModeForwards;
            rotaion.repeatCount = HUGE_VALF;
            rotaion.toValue = [NSNumber numberWithFloat:M_PI*2];
            [self.layer addAnimation:rotaion forKey:RotationAnimation];
            
            [lineLayer removeFromSuperlayer];
            _isPullLoading = YES;
        }
        
        if (![pullLayer.superlayer isEqual:self.layer]) {
            [self.layer addSublayer:pullLayer];
            
        }
        
        [view addSubview:self];

    }
}
#pragma mark - 关闭
- (void)stopCYAX_Loading {
    // 移除旋转动画
    [self.layer removeAnimationForKey:RotationAnimation];
    _isPullLoading = NO;
    
}


@end
