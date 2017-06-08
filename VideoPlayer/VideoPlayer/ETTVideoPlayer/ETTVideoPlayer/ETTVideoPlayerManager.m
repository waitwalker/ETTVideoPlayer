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

@end
