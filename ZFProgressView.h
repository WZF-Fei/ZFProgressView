//
//  ZFProgressView.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFProgressViewStyle) {
    ZFProgressViewStyleNone = 0,
    ZFProgressViewStyleSquareSegment,
    ZFProgressViewStyleRoundSegment,
    ZFProgressViewStyleImageSegment,

};

IB_DESIGNABLE
@interface ZFProgressView : UIView

//进度线条宽度
@property (nonatomic,assign) IBInspectable CGFloat progressLineWidth;
//背景线条宽度
@property (nonatomic,assign) IBInspectable CGFloat backgourndLineWidth;
//进度百分比
@property (nonatomic,assign) IBInspectable CGFloat Percentage;
//背景填充颜色
@property (nonatomic,strong) IBInspectable UIColor *backgroundStrokeColor;
//进度条填充颜色
@property (nonatomic,strong) IBInspectable UIColor *progressStrokeColor;
//内部背景颜色
@property (nonatomic,strong) IBInspectable UIColor *innerBackgroundColor;
//距离边框边距偏移量
@property (nonatomic,assign) IBInspectable CGFloat offset;
//步长
@property (nonatomic,assign) IBInspectable CGFloat step;

//数字字体颜色
@property (nonatomic,strong) IBInspectable UIColor *digitTintColor;

//设置图片
@property (nonatomic,strong) IBInspectable UIImage *image;

//动画持续时间。 单位：秒
@property (nonatomic) CGFloat timeDuration;

//进度条起始角度
@property (nonatomic) CGFloat startAngle;
//进度条终点角度
@property (nonatomic) CGFloat endAngle;

/*
 设置每个格子的宽度与线条宽度要注意
 由于使用原点画圆弧的原因，距离原点越近，弧长越短
 
 要求：
 设置的线条宽度lineWidth < GapWidth
 */


//格子之间的宽度
@property (nonatomic,assign) IBInspectable CGFloat GapWidth;
//设置线条宽度 （进度条宽度 = 背景线条宽度）
@property (nonatomic,assign) IBInspectable CGFloat lineWidth;

//style
- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style;

- (instancetype) initWithFrame:(CGRect)frame style:(ZFProgressViewStyle)style withImage:(UIImage *)image;

-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated;

@end
