//
//  ViewController.m
//  PATestDemos
//
//  Created by 庞曼丽 on 2018/9/18.
//  Copyright © 2018年 庞曼丽. All rights reserved.
//

#import "ViewController.h"
#import "MLProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) MLProgressView * progress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不带动画的圆环进度
    self.progress = [[MLProgressView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.progress.circleWidth = 6;

    //设置属性,可修改静态的 圆环颜色,宽度 及进度. 若要扩展属性,在对应属性中修改 _arcLayer对应属性即可
    self.progress.circleColor = [UIColor redColor];
    self.progress.circleWidth = 6.0;
    self.progress.rate = 0.2;
    
    self.progress.colors = [NSArray arrayWithObjects:[UIColor blueColor].CGColor,[UIColor yellowColor].CGColor,[UIColor greenColor].CGColor, nil];
 
    self.progress.attrStr = [self.progress createAttributeStringWithRate:self.progress.rate];

    //加动画只需加上下面这句代码
    [self.progress drawLineAnimationWithRate:0.8 duration:2.0];
    
    [self.view addSubview:self.progress];
    
}








@end
