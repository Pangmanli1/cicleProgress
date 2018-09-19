//
//  MLProgressView.m
//
//  Created by Maria_Pang on 17/6/13.
//
//

#import "MLProgressView.h"

@interface MLProgressView ()<CAAnimationDelegate>

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer * arcLayer;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * label;
@end
@implementation MLProgressView

-(instancetype)initWithFrame:(CGRect)frame {
   return [self initWithFrame:frame rate:0];
}

-(instancetype)initWithFrame:(CGRect)frame rate:(CGFloat)rate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    CGFloat xCenter = self.center.x;
    CGFloat yCenter = self.center.y;
    CGFloat viewWidth = self.bounds.size.width;
    int fontNum = viewWidth/6;
    int labelWidth = viewWidth - self.circleWidth*2;
    CGFloat Radius = labelWidth / 2.0;
    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//    bgView.backgroundColor = [UIColor clearColor];
//    [self addSubview:bgView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xCenter , yCenter) radius:Radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    self.backgroundLayer.path = path.CGPath;
    [self.layer addSublayer:self.backgroundLayer];
 
    UIBezierPath *arcPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(xCenter,yCenter) radius:Radius startAngle:-M_PI_2 endAngle:-M_PI_2 +(M_PI *2) clockwise:YES];
    self.arcLayer.path = arcPath.CGPath;
    [self.layer addSublayer:self.arcLayer];
    if (_rate > 0) {
        self.arcLayer.strokeEnd = _rate;
    }
    
    self.label.font = [UIFont boldSystemFontOfSize:fontNum];
    self.label.frame = CGRectMake(0, 0, labelWidth, viewWidth/6);
    self.label.center = CGPointMake(xCenter, yCenter);
    self.label.text = [NSString stringWithFormat:@"%.2f%%",_rate*100];
    [self addSubview:self.label];
}

-(void)drawLineAnimationWithRate:(CGFloat)rate duration:(NSTimeInterval)interval
{
//    NSString * rateStr = [NSString stringWithFormat:@"%.2f",rate];
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = interval;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bas.fromValue=[NSNumber numberWithFloat:0.0];
    bas.toValue= [NSNumber numberWithFloat:rate];
    bas.delegate= self;
    bas.fillMode = kCAFillModeForwards;
    bas.removedOnCompletion = NO;
    self.label.text = [NSString stringWithFormat:@"%.2f%%",rate*100];
    [self.arcLayer addAnimation:bas forKey:@"strokeEnd"];

}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setRate:(CGFloat)rate {
    _rate = rate;
    self.arcLayer.strokeEnd = rate;
    self.label.text = [NSString stringWithFormat:@"%.2f%%",rate*100];
}

-(void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    self.arcLayer.strokeColor = circleColor.CGColor;

}

-(void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
    self.arcLayer.lineWidth = circleWidth;
    self.backgroundLayer.lineWidth = circleWidth;
    
}


-(CAShapeLayer *)arcLayer {
    if (_arcLayer == nil) {
        _arcLayer=[CAShapeLayer layer];
        _arcLayer.frame = self.bounds;
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor=[UIColor blueColor].CGColor;
        _arcLayer.lineWidth= 8;
        _arcLayer.lineCap = kCALineCapRound;
      
    }
    return _arcLayer;
}

-(CAShapeLayer *)backgroundLayer {
    
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.lineWidth = 8;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor grayColor].CGColor;
        _backgroundLayer.lineCap = kCALineCapRound;
        _backgroundLayer.lineJoin = kCALineCapRound;
    }
    return _backgroundLayer;
}

-(UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
    }
    return _label;
}
@end
