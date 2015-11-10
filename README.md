# ZFProgressView
A simple digit progress view.

## Version 1.1  加入不同进度样式

    ZFProgressViewStyleNone, //默认样式
    ZFProgressViewStyleSquareSegment, //方形格子进度条
    ZFProgressViewStyleRoundSegment, //圆形格子进度条
    ZFProgressViewStyleImageSegment, //带有图片的进度条

##Version 1.2 

1. 实现音乐播放器进度，设置音乐播放时间进行播放
2. 可定时更换音乐封面

## Example:

<p align="center" >
<img src="https://github.com/WZF-Fei/ZFProgressView/blob/master/ZFProgressViewExampleTests/ZFProgressView.gif" width="266" height="500"/>
</p>

##How to use ZFProgressView?

Add "ZFProgressView.h" and "ZFProgressView.m" in your project.
Then



```obj-c
ZFProgressView *progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
```
With Style

```obj-c
ZFProgressView *progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(50, 150, 100, 100) 
                                                            style:ZFProgressViewStyleRoundSegment];
```

###1. setProgressStrokeColor
```obj-c
[progress setProgressStrokeColor:[UIColor orangeColor]];
```

###2. setBackgroundStrokeColor
```obj-c
[progress setBackgroundStrokeColor:[UIColor yellowColor]];
```

###3. setDigitTintColor
```obj-c
[progress setDigitTintColor:[UIColor greenColor]];
```

###4. use an animation to show digit progress
```obj-c
[progress setProgress:0.8 Animated:YES];
or
[progress setProgress:0.8 Animated:NO];
```

###5. add an image
progress.image = [UIImage imageNamed:@"1.jpg"];

###6. 加入进度播放时间 (秒)

progress.timeDuration = 60;
