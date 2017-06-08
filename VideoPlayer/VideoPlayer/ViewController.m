//
//  ViewController.m
//  VideoPlayer
//
//  Created by LiuChuanan on 2017/6/8.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ViewController.h"
#import "ETTVideoPlayerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETTVideoPlayerManager *videoPlayerManager = [[ETTVideoPlayerManager alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 300) superView:self.view];
    
    videoPlayerManager.videoURLString = @"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

