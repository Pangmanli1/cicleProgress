//
//  MLProgressView.h
//
//  Created by Maria_Pang on 17/6/13.
//
// 动画进度设置视图

#import <UIKit/UIKit.h>

@interface MLProgressView : UIView

@property (nonatomic, assign) CGFloat rate; //百分比,0~1之间取值
@property (nonatomic, assign) CGFloat circleWidth;
@property (nonatomic, strong) UIColor * circleColor; //单色圆环颜色
@property (nonatomic, strong) UIColor * circleBgColor; //圆环背景色

//设置颜色和中心label的富文本 可改为渐变类型的环形进度
@property (nonatomic, strong) NSArray * colors; //渐变色圆环颜色
@property (nonatomic, strong) NSMutableAttributedString *attrStr;

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


/**
 根据百分比创建中心label的富文本, 可使用此方法创建富文本,再赋给 attrStr属性,即可成功设置富文本

 @param rate 进度值  0 ~ 1 之间取值,1为100%
 @return 返回富文本, 文字大小是 .m中静态变量 numFontSize,percentFontSize
 */
-(NSMutableAttributedString *)createAttributeStringWithRate:(CGFloat)rate ;



@end
