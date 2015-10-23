//
//  ZFProgressView.m
//  ZFProgressView
//
//  Created by macOne on 15/9/23.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import "ZFProgressView.h"

#define Duration 5.0
#define DefaultLineWidth 8

@interface ZFProgressView ()

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;


@end

@implementation ZFProgressView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor brownColor].CGColor;
        [self.layer addSublayer:_backgroundLayer];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.lineCap = kCALineCapSquare;
        _progressLayer.lineJoin = kCALineCapSquare;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_progressLayer];
        
        
        [self.progressLabel setTextColor:[UIColor whiteColor]];
        self.progressLabel.text = @"0%";
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.font = [UIFont systemFontOfSize:25 weight:0.4];
        [self addSubview:self.progressLabel];
        
        //init default variable
        self.backgourndLineWidth = DefaultLineWidth;
        self.progressLineWidth = DefaultLineWidth;
        self.Percentage = 0;
        self.offset = 0;
        self.sumSteps = 0;
        self.step = 0.1;


    }
    return self;
}

#pragma mark - draw circleLine
-(void) setBackgroundCircleLine
{

    UIBezierPath *backgroundCirlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                          self.center.y - self.frame.origin.y)
                                                                       radius:(self.bounds.size.width - _backgourndLineWidth)/ 2 - _offset
                                                                   startAngle:0
                                                                     endAngle:M_PI*2
                                                                    clockwise:YES];
    _backgroundLayer.path = backgroundCirlePath.CGPath;
}

-(void)setProgressCircleLine
{
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                   self.center.y - self.frame.origin.y)
                                                                radius:(self.bounds.size.width - _progressLineWidth)/ 2 - _offset
                                                            startAngle:-M_PI_2
                                                              endAngle:-M_PI_2 + M_PI*2
                                                             clockwise:YES];
    _progressLayer.path = progressPath.CGPath;
}


#pragma mark - setter and getter methond

-(UILabel *)progressLabel
{
    if(!_progressLabel)
    {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)/2, (self.bounds.size.height - 100)/2, 100, 100)];
    }
    return _progressLabel;
}
-(void)setBackgourndLineWidth:(CGFloat)backgourndLineWidth
{
    _backgourndLineWidth = backgourndLineWidth;
    _backgroundLayer.lineWidth = backgourndLineWidth;
}

-(void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    _progressLayer.lineWidth = progressLineWidth;
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
}

-(void)setPercentage:(CGFloat)Percentage
{
    _Percentage = Percentage;
    [self setProgressCircleLine];
;
}

-(void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor
{
    _backgroundStrokeColor = backgroundStrokeColor;
    _backgroundLayer.strokeColor = backgroundStrokeColor.CGColor;
}

-(void)setProgressStrokeColor:(UIColor *)progressStrokeColor
{
    _progressStrokeColor = progressStrokeColor;
    _progressLayer.strokeColor = progressStrokeColor.CGColor;

}

-(void)setDigitTintColor:(UIColor *)digitTintColor
{
    _digitTintColor = digitTintColor;
    _progressLabel.textColor = digitTintColor;
}

#pragma mark - progress animated YES or NO
-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated
{
    _Percentage = Percentage;
    if (animated) {
  
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithInt:0];
        animation.toValue = [NSNumber numberWithFloat:_Percentage];
        animation.duration = Duration;
        _progressLayer.strokeEnd = _Percentage;
        //start timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:_step
                                                  target:self
                                                selector:@selector(numberAnimation)
                                                userInfo:nil
                                                 repeats:YES];
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];

    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _progressLayer.strokeEnd = _Percentage;
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_Percentage*100];
        [CATransaction commit];
    }
}


-(void)numberAnimation
{
    //Duration 动画持续时长
    _sumSteps += _step;
    float sumSteps =  _Percentage /Duration *_sumSteps;
    if (_sumSteps >= Duration) {
        //close timer
        [_timer invalidate];
        _timer = nil;
        return;
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",sumSteps *100];
}
@end
