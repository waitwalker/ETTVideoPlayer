//
//  ETTVideoPlayerNavigationBar.h
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/5.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTVideoPlayerNavigationBarDelegate.h"

@interface ETTVideoPlayerNavigationBar : UIView

@property (nonatomic, weak) id <ETTVideoPlayerNavigationBarDelegate>delegate;

@end
