//
//  ETTVideoPlayerTabBar.m
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/5.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ETTVideoPlayerTabBar.h"

#define kWidthScale (frame.size.width / 414.0)
#define kHeightScale (frame.size.height / 736.0)


@implementation ETTVideoPlayerTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
    {   self.backgroundColor = [UIColor greenColor];
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

#pragma mark 初始化tabBar上子控件
- (void)setupSubviewsWithFrame:(CGRect)frame
{   
    //播放暂停按钮
    CGFloat playPauseButtonX = 15 * kWidthScale;
    CGFloat playPauseButtonWidthHeight = 30 * kWidthScale;
    CGFloat playPauseButtonY = (frame.size.height - playPauseButtonWidthHeight) / 2.0;
    
    UIButton *playPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(playPauseButtonX, playPauseButtonY, playPauseButtonWidthHeight, playPauseButtonWidthHeight)];
    [playPauseButton setBackgroundColor:[UIColor redColor]];
    [playPauseButton addTarget:self action:@selector(tappedPlayPauseButtons:) forControlEvents:UIControlEventTouchUpInside];
    playPauseButton.selected = YES;
    [self addSubview:playPauseButton];
    self.playPauseButton = playPauseButton;
    
    //当前播放时间
    CGFloat currentPlayTimeLabelX = CGRectGetMaxX(playPauseButton.frame) + 10;
    CGFloat currentPlayTimeLabelWidth = 50 * kWidthScale;
    CGFloat currentPlayTimeLabelHeight = frame.size.height;
    CGFloat currentPlayTimeLabelY = 0;
    
    _currentPlayTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentPlayTimeLabelX, currentPlayTimeLabelY, currentPlayTimeLabelWidth, currentPlayTimeLabelHeight)];
    _currentPlayTimeLabel.backgroundColor = [UIColor redColor];
    _currentPlayTimeLabel.text = @"00:23:18";
    _currentPlayTimeLabel.textColor = [UIColor whiteColor];
    _currentPlayTimeLabel.font = [UIFont systemFontOfSize:10.0];
    _currentPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_currentPlayTimeLabel];
    
    //进度条
    CGFloat sliderX = CGRectGetMaxX(_currentPlayTimeLabel.frame) + 10;
    
    CGFloat sliderHeight = 30;
    
    CGFloat sliderWidth = frame.size.width - sliderX - 10 * 3 - 50 * kWidthScale - 30 * kWidthScale;
    CGFloat sliderY = (frame.size.height - sliderHeight) / 2.0;
    
    _slider = [[ETTVideoPlayerSlider alloc]initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    [self addSubview:_slider];
    
    //总播放时间
    CGFloat totalPlayTimeLabelX = CGRectGetMaxX(_slider.frame) + 10;
    CGFloat totalPlayTimeLabelWidth = 50 * kWidthScale;
    CGFloat totalPlayTimeLabelHeight = frame.size.height;
    CGFloat totalPlayTimeLabelY = 0;
    
    _totalPlayTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalPlayTimeLabelX, totalPlayTimeLabelY, totalPlayTimeLabelWidth, totalPlayTimeLabelHeight)];
    _totalPlayTimeLabel.backgroundColor = [UIColor redColor];
    _totalPlayTimeLabel.text = @"01:23:18";
    _totalPlayTimeLabel.textColor = [UIColor whiteColor];
    _totalPlayTimeLabel.font = [UIFont systemFontOfSize:10.0];
    _totalPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalPlayTimeLabel];
    
    //放大缩小按钮
    CGFloat largeSmallButtonX = CGRectGetMaxX(_totalPlayTimeLabel.frame) + 10;
    CGFloat largeSmallButtonWidthHeight = 30 * kWidthScale;
    CGFloat largeSmallButtonY = (frame.size.height - largeSmallButtonWidthHeight) / 2.0;
    
    UIButton *largeSmallButton = [[UIButton alloc]initWithFrame:CGRectMake(largeSmallButtonX, largeSmallButtonY, largeSmallButtonWidthHeight, largeSmallButtonWidthHeight)];
    [largeSmallButton setBackgroundColor:[UIColor redColor]];
    [largeSmallButton addTarget:self action:@selector(tappedlargeSmallButtons:) forControlEvents:UIControlEventTouchUpInside];
    largeSmallButton.selected = YES;
    [self addSubview:largeSmallButton];
}

#pragma mark 播放暂停按钮的回调
- (void)tappedPlayPauseButtons:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tappedInPlayerTabBar:playPauseButton:)]) 
    {
        [_delegate tappedInPlayerTabBar:self playPauseButton:button];
    }
}

#pragma mark 放大缩小按钮的回调
- (void)tappedlargeSmallButtons:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tappedInPlayerTabBar:largeSmallButton:)]) 
    {
        [_delegate tappedInPlayerTabBar:self largeSmallButton:button];
    }
}

@end
