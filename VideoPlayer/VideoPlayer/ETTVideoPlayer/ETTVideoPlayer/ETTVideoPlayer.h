//
//  ETTVideoPlayer.h
//  ETTVideoPlayer
//
//  Created by WangJunZi on 2017/6/3.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTVideoPlayerNavigationBar.h"
#import "ETTVideoPlayerTabBar.h"

@interface ETTVideoPlayer : UIView

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) ETTVideoPlayerNavigationBar *playerNavigationBar;
@property (nonatomic, strong) ETTVideoPlayerTabBar        *playerTabBar;

@end




