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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    ZFProgressView *progress1 = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
    [self.view addSubview:progress1];
    [progress1 setProgress:0.8 Animated:YES];
    
    
    ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(200, 150, 100, 100)];
    [self.view addSubview:progress2];
    [progress2 setProgressStrokeColor:[UIColor orangeColor]];
    [progress2 setProgress:0.8 Animated:NO];
    
    ZFProgressView *progress3 = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 300, 100, 100)];
    [self.view addSubview:progress3];
    [progress3 setProgressStrokeColor:[UIColor orangeColor]];
    [progress3 setProgress:0.8 Animated:YES];
    
    ZFProgressView *progress4 = [[ZFProgressView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    [self.view addSubview:progress4];
    [progress4 setProgressStrokeColor:[UIColor redColor]];
    [progress4 setBackgroundStrokeColor:[UIColor yellowColor]];
    [progress4 setDigitTintColor:[UIColor greenColor]];
    [progress4 setProgress:0.8 Animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
