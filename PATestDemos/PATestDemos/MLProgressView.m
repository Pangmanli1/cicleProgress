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
@property (nonatomic, strong) CAGradientLayer * gradientLayer;
@property (nonatomic, strong) UIBezierPath * circlePath;
@property (nonatomic, strong) UILabel * label;
@end

static CGFloat defautCircleW;
static CGFloat percentFontSize;
static CGFloat numFontSize;

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
    defautCircleW = 8;
    percentFontSize = 5.0f;
    numFontSize = 10.0f;
    
    CGFloat xCenter = self.bounds.size.width/2.0;
    CGFloat yCenter = self.bounds.size.height/2.0;
    CGFloat viewWidth = self.bounds.size.width;
    int fontNum = viewWidth/6;
    int labelWidth = viewWidth - defautCircleW*2;
    CGFloat Radius = labelWidth / 2.0;
    
    self.circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xCenter , yCenter) radius:Radius startAngle:-M_PI_2 endAngle:-M_PI_2 +(M_PI *2) clockwise:YES];
    self.backgroundLayer.path = self.circlePath.CGPath;
    [self.layer addSublayer:self.backgroundLayer];
 
    self.arcLayer.path = self.circlePath.CGPath;
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
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = interval;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bas.fromValue=[NSNumber numberWithFloat:0.0];
    bas.toValue= [NSNumber numberWithFloat:rate];
    bas.delegate= self;
    bas.fillMode = kCAFillModeForwards;
    bas.removedOnCompletion = NO;
    if (_attrStr) {
        self.label.attributedText = [self createAttributeStringWithRate:rate];
    }else {
        
        self.label.text = [NSString stringWithFormat:@"%.2f%%",rate*100];
    }
    [self.arcLayer addAnimation:bas forKey:@"strokeEnd"];

}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark- 根据百分比率创建富文本, 主要用于动画时更新富文本内容
-(NSMutableAttributedString *)createAttributeStringWithRate:(CGFloat)rate {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *numberString =
    [[NSAttributedString alloc] initWithString:@(rate * 100).stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:numFontSize]}];
    
    NSAttributedString *percentString =
    [[NSAttributedString alloc] initWithString:@"%"
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:percentFontSize]}];
    
    [attributedString appendAttributedString:numberString];
    [attributedString appendAttributedString:percentString];
    
    return attributedString;
}

#pragma mark - setter方法更新相关视图
-(void)setRate:(CGFloat)rate {
    _rate = rate;
    self.arcLayer.strokeEnd = rate;
    if (_attrStr) {
        self.label.attributedText = [self createAttributeStringWithRate:rate];
    }else {
        
        self.label.text = [NSString stringWithFormat:@"%.2f%%",rate*100];
    }
}

-(void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    self.arcLayer.strokeColor = circleColor.CGColor;

}

-(void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
    CGFloat Radius = (self.bounds.size.width - circleWidth)/2.0;
    self.circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0 , self.bounds.size.height/ 2.0) radius:Radius startAngle:-M_PI_2 endAngle:-M_PI_2 +(M_PI *2) clockwise:YES];
    self.backgroundLayer.path = self.circlePath.CGPath;
    self.arcLayer.path = self.circlePath.CGPath;
    self.arcLayer.lineWidth = circleWidth;
    self.backgroundLayer.lineWidth = circleWidth;
}

-(void)setColors:(NSArray *)colors {
    _colors = colors;
    self.gradientLayer.colors = colors;
    [self.layer addSublayer:self.gradientLayer];
    [self.gradientLayer setMask:self.arcLayer];
}

-(void)setCircleBgColor:(UIColor *)circleBgColor {
    _circleBgColor = circleBgColor;
    self.backgroundLayer.strokeColor = circleBgColor.CGColor;
}


-(void)setAttrStr:(NSMutableAttributedString *)attrStr {
    _attrStr = attrStr;
    self.label.text = nil;
    self.label.attributedText = attrStr;
    
}
#pragma mark - 懒加载
-(CAShapeLayer *)arcLayer {
    if (_arcLayer == nil) {
        _arcLayer=[CAShapeLayer layer];
        _arcLayer.frame = self.bounds;
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor=[UIColor blueColor].CGColor;
        _arcLayer.lineWidth= defautCircleW;
        _arcLayer.lineCap = kCALineCapRound;
      
    }
    return _arcLayer;
}

-(CAShapeLayer *)backgroundLayer {
    
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.lineWidth = defautCircleW;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
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

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer){
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
    }
    
    return _gradientLayer;
}


@end
