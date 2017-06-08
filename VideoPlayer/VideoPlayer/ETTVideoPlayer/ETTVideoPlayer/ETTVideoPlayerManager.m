//
//  ETTVideoPlayerManager.m
//  VideoPlayer
//
//  Created by WangJunZi on 2017/6/8.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ETTVideoPlayerManager.h"
#import "ETTVideoPlayer.h"


@interface ETTVideoPlayerManager ()

@property (nonatomic, strong) ETTVideoPlayer *videoPlayer;

@end

@implementation ETTVideoPlayerManager

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super init])
    {
        _videoPlayer = [[ETTVideoPlayer alloc]initWithFrame:frame];
        [superView addSubview:_videoPlayer];
        [self judgeCurrentDeviceOritation];
    }
    return self;
}

- (void)setVideoURLString:(NSString *)videoURLString
{
    if (!_videoURLString)
    {
        _videoURLString = videoURLString;
        _videoPlayer.urlString = videoURLString;
    }
}

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
}
#pragma mark 判断当前设备方向
- (void)judgeCurrentDeviceOritation
{
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation deviceOirentation = device.orientation;
    NSLog(@"%ld",(long)deviceOirentation);
    
    //生成设备旋转通知
    [device beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOritationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark 设备屏幕发生旋转的回调
- (void)deviceOritationDidChange:(NSNotification *)notify
{
    UIDevice *device = (UIDevice *)notify.object;
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置,充电口向右");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右横置,充电口向左");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕竖直,充电口向下");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕竖直,充电口向上,上下颠倒");
            
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

@end
