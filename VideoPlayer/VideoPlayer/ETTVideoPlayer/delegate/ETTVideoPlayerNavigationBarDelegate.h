//
//  ETTVideoPlayerNavigationBarDelegate.h
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/5.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETTVideoPlayerNavigationBar;


@protocol ETTVideoPlayerNavigationBarDelegate <NSObject>


- (void)tappedInPlayerNavigationBar:(ETTVideoPlayerNavigationBar *)playerNavigationBar backButton:(UIButton *)button;

@end
