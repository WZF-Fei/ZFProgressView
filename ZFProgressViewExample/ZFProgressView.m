//
//  ZFProgressView.m
//
//  Created by WZF on 15/9/23.
//  Copyright © 2015年 WZF. <wzhf366@163.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ZFProgressView.h"

#define DefaultLineWidth 5
static NSString *timerName = @"AnimationTimer";


@interface ZFProgressView ()

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) CALayer *imageLayer;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *timerContainer;
@property (nonatomic,assign) ZFProgressViewStyle style;


@end

@implementation ZFProgressView
//默认样式 none
-(instancetype) initWithFrame:(CGRect)frame
{
   return [self initWithFrame:frame style:ZFProgressViewStyleNone];
    
}
- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.innerBackgroundColor = [UIColor clearColor];
        self.style = style;
        
        self.startAngle = -90 *(M_PI / 180.0);
        self.endAngle = (-90 + 360) *(M_PI / 180.0);
        
        [self layoutViews:style];
        
        //init default variable
        self.GapWidth = 10.0;
        if (ZFProgressViewStyleImageSegment == style) {
            self.backgourndLineWidth = 3;
            self.progressLineWidth = 3;
        }
        else{
            self.backgourndLineWidth = DefaultLineWidth;
            self.progressLineWidth = DefaultLineWidth;
        }

        _Percentage = 0;
        _offset = 0;
        _sumSteps = 0;
        _step = 0.1;
        _timeDuration = 5.0;

        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style withImage:(UIImage *)image
{
    self.image = (style == ZFProgressViewStyleImageSegment) ? image :nil;
    return [self initWithFrame:frame style:style];
}

-(void) layoutViews:(ZFProgressViewStyle)style
{
    [self.progressLabel setTextColor:[UIColor whiteColor]];
    self.progressLabel.backgroundColor = _innerBackgroundColor;
    self.progressLabel.layer.cornerRadius = self.bounds.size.width /2;
    self.progressLabel.layer.masksToBounds = YES;
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:25 weight:0.4];
    [self addSubview:self.progressLabel];
    
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor brownColor].CGColor;
    }

    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    }

    
    switch (style) {
        case ZFProgressViewStyleNone:
        case ZFProgressViewStyleSquareSegment:
            _backgroundLayer.lineCap = kCALineCapSquare;
            _backgroundLayer.lineJoin = kCALineCapSquare;
            
            _progressLayer.lineCap = kCALineCapSquare;
            _progressLayer.lineJoin = kCALineCapSquare;
            
            [_imageLayer removeFromSuperlayer];
            _imageLayer = nil;
            break;
            
        case ZFProgressViewStyleRoundSegment:
            _backgroundLayer.lineCap = kCALineCapRound;
            _backgroundLayer.lineJoin = kCALineCapRound;
            
            _progressLayer.lineCap = kCALineCapRound;
            _progressLayer.lineJoin = kCALineCapRound;
            [_imageLayer removeFromSuperlayer];
            _imageLayer = nil;
            break;
         case ZFProgressViewStyleImageSegment:
            
            [_progressLabel removeFromSuperview];
            _progressLabel = nil;
            
            _imageLayer = [CALayer layer];
            _imageLayer.contents = (__bridge id)self.image.CGImage;
            _imageLayer.frame = self.bounds;
            _imageLayer.cornerRadius = self.bounds.size.height/2;
            _imageLayer.masksToBounds = YES;
            [self.layer addSublayer:_imageLayer];
            
            _backgroundLayer.lineCap = kCALineCapSquare;
            _backgroundLayer.lineJoin = kCALineCapSquare;
            
            _progressLayer.lineCap = kCALineCapSquare;
            _progressLayer.lineJoin = kCALineCapSquare;
            
            break;
        default:
            break;
    }
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
    

}
#pragma mark - draw circleLine
-(void) setBackgroundCircleLine:(ZFProgressViewStyle)style
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (style == ZFProgressViewStyleNone ||  style == ZFProgressViewStyleImageSegment) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                               self.center.y - self.frame.origin.y)
                                                            radius:(self.bounds.size.width - _backgourndLineWidth)/ 2 - _offset
                                                        startAngle:self.startAngle
                                                          endAngle:self.endAngle
                                                         clockwise:YES];
    }
    else
    {
        //最小0.5个弧度
        static float minAngle = 0.5 *(2 * M_PI)/360;
   
        CGFloat totalAngle = self.endAngle - self.startAngle;
        if (totalAngle < 0) {
            totalAngle += M_PI *2;
        }
  
        for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2))/ _GapWidth)+1; i++) {
            CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
            
            if (i == 0  && ((totalAngle - M_PI_2) == 0
                            || (totalAngle - M_PI*2/2) == 0
                            || (totalAngle - M_PI*3/2) == 0
                            || (totalAngle - M_PI*4/2) == 0)
                        && (fabs(self.startAngle) == 0
                            || (fabs(self.startAngle) - M_PI_2) == 0
                            || (fabs(self.startAngle) - M_PI*2/2) == 0
                            || (fabs(self.startAngle) - M_PI*3/2) == 0
                            || (fabs(self.startAngle) - M_PI*4/2) == 0)) {
                angle = minAngle * M_PI/180.0;
            }
            

            
            if (angle >= totalAngle) {
                angle = totalAngle;
            }
            UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                    self.center.y - self.frame.origin.y)
                                                                 radius:(self.bounds.size.width - _backgourndLineWidth)/ 2 - _offset
                                                             startAngle:self.startAngle +(i *_GapWidth * M_PI / 180.0)
                                                               endAngle:self.startAngle + angle
                                                              clockwise:YES];
            
            [path appendPath:path1];
            
        }

    }
  
    _backgroundLayer.path = path.CGPath;

}

-(void)setProgressCircleLine:(ZFProgressViewStyle)style
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (style == ZFProgressViewStyleNone || style == ZFProgressViewStyleImageSegment) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                            self.center.y - self.frame.origin.y)
                                                         radius:(self.bounds.size.width - _progressLineWidth)/ 2 - _offset
                                                     startAngle:self.startAngle
                                                       endAngle:self.endAngle
                                                      clockwise:YES];
    }
    else
    {
        //0.5个弧度
        static float minAngle = 0.5 * (2 * M_PI)/360;

        CGFloat totalAngle = self.endAngle - self.startAngle;
        
        if (totalAngle < 0) {
            totalAngle += M_PI *2;
        }
        for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2)) / _GapWidth *_Percentage)+1; i++) {
            CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
            
            if (i == 0  && ((totalAngle - M_PI_2) == 0
                            || (totalAngle - M_PI*2/2) == 0
                            || (totalAngle - M_PI*3/2) == 0
                            || (totalAngle - M_PI*4/2) == 0)
                        && (fabs(self.startAngle) == 0
                            || (fabs(self.startAngle) - M_PI_2) == 0
                            || (fabs(self.startAngle) - M_PI*2/2) == 0
                            || (fabs(self.startAngle) - M_PI*3/2) == 0
                            || (fabs(self.startAngle) - M_PI*4/2) == 0)){
                angle = minAngle * M_PI/180.0;
            }
            
            //总圆弧长度

//            NSLog(@"totalAngle:%f,angle:%f",totalAngle,angle);
            
            if (angle >= totalAngle) {
                angle = totalAngle;
            }
            UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                    self.center.y - self.frame.origin.y)
                                                                 radius:(self.bounds.size.width - _progressLineWidth)/ 2 - _offset
                                                             startAngle:self.startAngle +(i *_GapWidth * M_PI / 180.0)
                                                               endAngle:self.startAngle + angle
                                                              clockwise:YES];

            [path appendPath:path1];
            
        }

    }
//    NSLog(@"path:%@",path);
    _progressLayer.path = path.CGPath;
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

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
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
    [self setBackgroundCircleLine:self.style];
    [self setProgressCircleLine:self.style];
}

-(void)setPercentage:(CGFloat)Percentage
{
    _Percentage = Percentage;
    [self setProgressCircleLine:self.style];
    [self setBackgroundCircleLine:self.style];
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

-(void)setGapWidth:(CGFloat)GapWidth
{
    _GapWidth = GapWidth;
    [self setBackgroundCircleLine:self.style];
    [self setProgressCircleLine:self.style];
    
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    _progressLineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
    
    _backgourndLineWidth = lineWidth;
    _backgroundLayer.lineWidth = lineWidth;
}


-(void)setImage:(UIImage *)image
{
    _image = image;
    [self layoutViews:ZFProgressViewStyleImageSegment];
}

-(void)setTimeDuration:(CGFloat)timeDuration
{
    _timeDuration = timeDuration;
    [self setProgress:1.0 Animated:YES];
}

-(void)setInnerBackgroundColor:(UIColor *)innerBackgroundColor
{
    _innerBackgroundColor = innerBackgroundColor;
    [self layoutViews:ZFProgressViewStyleNone];
}

-(void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self layoutViews:self.style];
}
-(void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self layoutViews:self.style];
}

#pragma mark - progress animated YES or NO
-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated
{
    self.Percentage = Percentage;
    if (animated) {
  
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        if (self.style ==  ZFProgressViewStyleNone ) {
            animation.toValue = [NSNumber numberWithFloat:_Percentage];
            _progressLayer.strokeEnd = _Percentage;
        }
        else
        {
            animation.toValue = [NSNumber numberWithFloat:1.0];
            
        }
        
        animation.duration = self.timeDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        //start timer 会产生强引用，造成无法释放的问题
//        if (!_timer) {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:_step
//                                                      target:self
//                                                    selector:@selector(numberAnimation)
//                                                    userInfo:nil
//                                                     repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        }

        [self cancelTimerWithName:timerName];
        __weak typeof(self) weakSelf = self;

        [self scheduledDispatchTimerWithName:timerName timeInterval:_step queue:nil repeats:YES action:^{
            [weakSelf numberAnimation];
        }];

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
    float sumSteps =  _Percentage /_timeDuration *_sumSteps;
    if (_sumSteps >= _timeDuration) {
        //close timer
//        [_timer invalidate];
//        _timer = nil;
        [self cancelTimerWithName:timerName];
        return;
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",sumSteps *100];
}

//Use GCD-timer
// @param timerName       timer的名称，作为唯一标识
// @param interval        执行的时间间隔
// @param queue           timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个子线程队列中
// @param repeats         timer是否循环调用
// @param action          时间间隔到点时执行的block
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
{
    if (nil == timerName)
        return;
    
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新主界面
            action();
        });
        
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
    
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    
}

@end
