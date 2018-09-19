//
//  MLProgressView.h
//
//  Created by Maria_Pang on 17/6/13.
//
// 动画进度设置视图

#import <UIKit/UIKit.h>

@interface MLProgressView : UIView

@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat circleWidth;
@property (nonatomic, strong) UIColor * circleColor;


/**
 给定进度 rate 带进度label的初始化方法

 @param frame frame值
 @param rate 进度值  0 ~ 1 之间取值,1为100%
 @return 返回带进度的环形进度条
 */
-(instancetype)initWithFrame:(CGRect)frame rate:(CGFloat)rate;


/**
 添加动画(指定最终进度,及动画持续的时间)

 @param rate 进度
 @param interval 动画持续的时间大小
 */
-(void)drawLineAnimationWithRate:(CGFloat)rate duration:(NSTimeInterval)interval;





@end
