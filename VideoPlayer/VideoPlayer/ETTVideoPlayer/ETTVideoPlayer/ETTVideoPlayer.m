//
//  ETTVideoPlayer.m
//  ETTVideoPlayer
//
//  Created by WangJunZi on 2017/6/3.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ETTVideoPlayer.h"
#import "ETTVideoPlayerSlider.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

@interface ETTVideoPlayer ()<ETTVideoPlayerNavigationBarDelegate,ETTVideoPlayerSliderDelegate,ETTVideoPlayerTabBarDelegate>

@property (nonatomic, strong) AVPlayer      *avPlayer;
@property (nonatomic, strong) AVPlayerItem  *avPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;

@end

#pragma mark const常量
static int const kShowBarTime = 5;


#pragma mark 播放器
@implementation ETTVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviewWithUrlString:urlString];
        [self addGestureRecognizer];
        [self judgeCurrentDeviceOritation];
    }
    return self;
}

#pragma makr 初始化子控件
- (void)setupSubviewWithUrlString:(NSString *)urlString
{
    //上部navigationBar
    ETTVideoPlayerNavigationBar *playerNavigationBar = [[ETTVideoPlayerNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    playerNavigationBar.delegate = self;
    [self addSubview:playerNavigationBar];
    self.playerNavigationBar = playerNavigationBar;
    
    //下部tabBar
    ETTVideoPlayerTabBar *playerTabBar = [[ETTVideoPlayerTabBar alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
    playerTabBar.slider.delegate = self;
    playerTabBar.delegate = self;
    [self addSubview:playerTabBar];
    self.playerTabBar = playerTabBar;
    
    //初始化中间的播放视图
    [self setupAVPlayerWithUrlString:urlString];
    
    //将navigationBar和tabBar挪到最上层
    [self bringSubviewToFront:self.playerNavigationBar];
    [self bringSubviewToFront:self.playerTabBar];
}

#pragma mark navigationBar 和 tabBar显示时间
- (void)setupBarShowTime
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowBarTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.avPlayer.rate == 0.0 && self.avPlayer.error == nil) 
        {
            self.playerNavigationBar.hidden = NO;
            self.playerTabBar.hidden = NO;
            self.playerNavigationBar.alpha = 1.0;
            self.playerTabBar.alpha = 1.0;
        } else
        {
            if (self.playerTabBar.hidden == NO) 
            {
                [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.playerNavigationBar.alpha = 0.0;
                    self.playerTabBar.alpha = 0.0;
                } completion:^(BOOL finished) {
                    
                    self.playerNavigationBar.hidden = YES;
                    self.playerTabBar.hidden = YES;
                }];
            } 
        }
    });
}

#pragma mark 初始AVPlayer相关
- (void)setupAVPlayerWithUrlString:(NSString *)urlString
{   
    //1.创建视频url
    NSURL *url = [NSURL URLWithString:urlString];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //2.创建AVPlayerItem
    _avPlayerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    
    //3.创建AVPlayer
    _avPlayer = [AVPlayer playerWithPlayerItem:_avPlayerItem];
    
    //4.创建AVPlayerLayer
    _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _avPlayerLayer.frame = self.bounds;
    _avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _avPlayerLayer.repeatCount = 1;
    [self.layer addSublayer:_avPlayerLayer];
    
    //5.AVPlayer控制和调节视频播放
    
    //5.1监听播放状态
    [_avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //5.2监听播放进度
    [_avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //5.3监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avPlayerEndPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    
}

#pragma mark KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *avPlayerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) 
    {
        AVPlayerStatus status = [change[@"new"]intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {
                //播放总时长 
                CMTime duration = avPlayerItem.duration;
                CGFloat totalSeconds = duration.value / duration.timescale;
                CGFloat currentSeconds = avPlayerItem.currentTime.value / avPlayerItem.currentTime.timescale;
                self.playerTabBar.currentPlayTimeLabel.text =     [NSString stringWithFormat:@"%@", [self convertTime:currentSeconds]];
                self.playerTabBar.totalPlayTimeLabel.text =     [NSString stringWithFormat:@"%@", [self convertTime:totalSeconds]];
                [self monitorPlayProgressRate:avPlayerItem];
            }  
                break;
            case AVPlayerStatusFailed:
                
                break;
            case AVPlayerStatusUnknown:
                
                break;
                
            default:
                break;
        }
        
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSTimeInterval timeInterval = [self getAVPlayerLoadedEndTime:avPlayerItem];
        CMTime duration = avPlayerItem.duration;
        CGFloat totalSeconds = CMTimeGetSeconds(duration);
        CGFloat progress = timeInterval / totalSeconds;
        [self.playerTabBar.slider setTrackValue:progress];
    }
}

#pragma mark 时间戳转换
- (NSString *)convertTime:(CGFloat)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}

#pragma mark 监控当前播放进度
- (void)monitorPlayProgressRate:(AVPlayerItem *)avPlayerItem
{
    __weak typeof(self) weakSelf = self;
    
    CMTime duration = avPlayerItem.duration;
    if (CMTIME_IS_INVALID(duration))
    {
        weakSelf.playerTabBar.slider.minimumValue = 0.0;
        return;
    }
    
    [weakSelf.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = avPlayerItem.currentTime.value / avPlayerItem.currentTime.timescale;
        weakSelf.playerTabBar.currentPlayTimeLabel.text = [NSString stringWithFormat:@"%@",[weakSelf convertTime:currentSecond]];
        
        float totalSeconds = CMTimeGetSeconds(duration);
        [weakSelf.playerTabBar.slider setValue: currentSecond / totalSeconds];
    }];
}

#pragma mark 缓冲进度
- (NSTimeInterval)getAVPlayerLoadedEndTime:(AVPlayerItem *)avPlayerItem
{
    NSArray <NSValue *>* loadedTimeRanges = avPlayerItem.loadedTimeRanges;
    CMTimeRange timeRange = [loadedTimeRanges firstObject].CMTimeRangeValue;
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval endSeconds = startSeconds + durationSeconds;
    return endSeconds;
    
}

#pragma mark 播放完成的监听回调
- (void)avPlayerEndPlay:(NSNotification *)notification
{
    [self.avPlayerItem seekToTime:kCMTimeZero];
    [self.playerTabBar.playPauseButton setBackgroundColor:[UIColor redColor]];
    [self showNavigationBarAndTabBar];
}

#pragma mark 显示NavigationBar和TabBar
- (void)showNavigationBarAndTabBar
{
    self.playerTabBar.hidden = NO;
    self.playerNavigationBar.hidden = NO;
    self.playerNavigationBar.alpha = 1.0;
    self.playerTabBar.alpha = 1.0;
}

#pragma mark 添加手势
- (void)addGestureRecognizer
{
    //tap点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    //调节音量
    
    
    //调节亮度
    
    
}

#pragma mark 单击手势
- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{   
    //当前是隐藏状态
    if (self.playerTabBar.hidden)
    {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.playerNavigationBar.hidden = NO;
            self.playerTabBar.hidden = NO;
            self.playerNavigationBar.alpha = 1.0;
            self.playerTabBar.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
    } else
    { 
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.playerNavigationBar.alpha = 0.0;
            self.playerTabBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            self.playerNavigationBar.hidden = YES;
            self.playerTabBar.hidden = YES;
        }];
    }
}

#pragma mark NavigationBarDelegate
- (void)tappedInPlayerNavigationBar:(ETTVideoPlayerNavigationBar *)playerNavigationBar backButton:(UIButton *)button
{   
    /*
        点击返回按钮移除播放视图
    */
    //[self removeFromSuperview];
}

#pragma mark TabBarDelegate
- (void)tappedInPlayerTabBar:(ETTVideoPlayerTabBar *)playerTabBar playPauseButton:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) 
    {
        [button setBackgroundColor:[UIColor redColor]];
        [self.avPlayer pause];
    } else
    {
        [button setBackgroundColor:[UIColor purpleColor]];
        [self.avPlayer play];
    }
    
    [self setupBarShowTime];
}

- (void)tappedInPlayerTabBar:(ETTVideoPlayerTabBar *)playerTabBar largeSmallButton:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) 
    {
        [button setBackgroundColor:[UIColor redColor]];
        
        
    } else
    {
        [button setBackgroundColor:[UIColor purpleColor]];
    }
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

#pragma mark ETTVideoPlayerSliderDelegate
- (void)beginDragSliderButton:(UIButton *)button
{
    [self.avPlayer pause];
    [self.playerTabBar.playPauseButton setBackgroundColor:[UIColor redColor]];
}

- (void)draggingSliderButton:(UIButton *)button
{   
    [self.playerTabBar.playPauseButton setBackgroundColor:[UIColor redColor]];
    CGFloat value = [self.playerTabBar.slider value];
    float seekTime = CMTimeGetSeconds(self.avPlayer.currentItem.duration) * value;
    [self.avPlayer seekToTime:CMTimeMake(seekTime, 1)];
}

- (void)endDragSliderButton:(UIButton *)button
{
    [self.avPlayer play];
    [self.playerTabBar.playPauseButton setBackgroundColor:[UIColor purpleColor]];
    [self setupBarShowTime];
}

#pragma mark 移除监听
- (void)dealloc
{
    [self.avPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.avPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

@end

