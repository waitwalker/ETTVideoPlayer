//
//  ETTVideoPlayerTabBar.h
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/5.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTVideoPlayerSlider.h"
#import "ETTVideoPlayerTabBarDelegate.h"

@interface ETTVideoPlayerTabBar : UIView

@property (nonatomic, strong) UIButton *playPauseButton;

/* 进度条 */
@property (nonatomic, strong) ETTVideoPlayerSlider *slider;

/* 当前播放时间label */
@property (nonatomic, strong) UILabel *currentPlayTimeLabel;

/* 总播放时间label */
@property (nonatomic, strong) UILabel *totalPlayTimeLabel;

/* 播放暂停按钮的代理回调 */
@property (nonatomic, weak)   id<ETTVideoPlayerTabBarDelegate>delegate;


@end
