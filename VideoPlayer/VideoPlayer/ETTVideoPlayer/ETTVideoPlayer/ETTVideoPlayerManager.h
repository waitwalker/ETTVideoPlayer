//
//  ETTVideoPlayerManager.h
//  VideoPlayer
//
//  Created by WangJunZi on 2017/6/8.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ETTVideoPlayerManager : NSObject

@property (nonatomic, copy) NSString *videoURLString;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

@end
