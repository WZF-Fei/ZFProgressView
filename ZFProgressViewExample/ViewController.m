//
//  ViewController.m
//  ZFProgressViewExample
//
//  Created by macOne on 15/10/22.
//  Copyright © 2015年 WZF. All rights reserved.
//

#import "ViewController.h"
#import "ZFProgressView.h"

@interface ViewController ()


@property (nonatomic,strong) ZFProgressView *progress;

@property NSUInteger count;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    ZFProgressView *progress1 = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
    [self.view addSubview:progress1];
    [progress1 setProgress:0.8 Animated:YES];
//
//    
    ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(200, 150, 100, 100) style:ZFProgressViewStyleRoundSegment];
    [self.view addSubview:progress2];
    [progress2 setProgressStrokeColor:[UIColor orangeColor]];
    [progress2 setProgress:0.8 Animated:YES];
    
    ZFProgressView *progress3 = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 300, 100, 100) style:ZFProgressViewStyleSquareSegment];
    [self.view addSubview:progress3];
    [progress3 setProgressStrokeColor:[UIColor orangeColor]];
    [progress3 setProgress:0.3 Animated:YES];
    
    ZFProgressView *progress4 = [[ZFProgressView alloc] initWithFrame:CGRectMake(200, 300, 100, 100) style:ZFProgressViewStyleRoundSegment];
    [self.view addSubview:progress4];
    [progress4 setProgressStrokeColor:[UIColor redColor]];
    [progress4 setBackgroundStrokeColor:[UIColor yellowColor]];
    [progress4 setDigitTintColor:[UIColor greenColor]];
    [progress4 setProgress:0.6 Animated:YES];
    
    _progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 450, 100, 100) style:ZFProgressViewStyleImageSegment withImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:_progress];
    [_progress setProgressStrokeColor:[UIColor redColor]];
    [_progress setBackgroundStrokeColor:[UIColor lightGrayColor]];
    _progress.timeDuration = 10;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];

}

//定时更换图片
-(void)changeImage
{
    if (_count >= _progress.timeDuration) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    _progress.image = (_count % 2) ? [UIImage imageNamed:@"1.jpg"] : [UIImage imageNamed:@"2.jpg"];
    _count ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
