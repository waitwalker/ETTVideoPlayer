//
//  ETTVideoPlayerNavigationBar.m
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/5.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ETTVideoPlayerNavigationBar.h"


@interface ETTVideoPlayerNavigationBar ()

@property (nonatomic, strong) UIButton *backButton;


@end

@implementation ETTVideoPlayerNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
    {   
        self.backgroundColor = [UIColor brownColor];
        [self setupSubviewsNavigationBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSubviewsNavigationBar];
}

#pragma mark 初始化子控件
- (void)setupSubviewsNavigationBar
{
    //返回按钮
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(tappedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.backButton = backButton;
    
}

#pragma mark 布局子控件
- (void)layoutSubviewsNavigationBar
{
    self.backButton.frame = CGRectMake(20, 0, 100, self.bounds.size.height);
}

#pragma mark 返回按钮的点击事件回调
- (void)tappedBackButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tappedInPlayerNavigationBar:backButton:)]) 
    {
        [self.delegate tappedInPlayerNavigationBar:self backButton:button];
    }
    
}

@end
