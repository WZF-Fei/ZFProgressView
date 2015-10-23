# ZFProgressView
A simple digit progress view.

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


###1. setProgressStrokeColor
```obj-c
[progress setProgressStrokeColor:[UIColor orangeColor]];
```

###2.setBackgroundStrokeColor
```obj-c
[progress setBackgroundStrokeColor:[UIColor yellowColor]];
```

###3.setDigitTintColor
```obj-c
[progress setDigitTintColor:[UIColor greenColor]];
```

###4. use an animation to show digit progress
```obj-c
[progress4 setProgress:0.8 Animated:YES];
or
[progress4 setProgress:0.8 Animated:NO];
```
