//
//  ViewController.m
//  VideoPlayer
//
//  Created by LiuChuanan on 2017/6/8.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ViewController.h"
#import "ETTVideoPlayer.h"
#import "ETTVideoPlayerNavigationBarDelegate.h"
#import "ETTVideoPlayerSlider.h"
#import "ETTVideoPlayerTabBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETTVideoPlayer *player = [[ETTVideoPlayer alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    player.backgroundColor = [UIColor redColor];
    [self.view addSubview:player];
    
    //ETTVideoPlayerSlider *slider = [[ETTVideoPlayerSlider alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    //slider.backgroundColor = [UIColor greenColor];
    //    //[self.view addSubview:slider];
    //    ETTVideoPlayerTabBar *playTabBar = [[ETTVideoPlayerTabBar alloc]init];
    //    playTabBar.backgroundColor = [UIColor greenColor];
    //    playTabBar.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    //[self.view addSubview:playTabBar];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

