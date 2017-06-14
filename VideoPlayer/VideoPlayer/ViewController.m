//
//  ViewController.m
//  VideoPlayer
//
//  Created by LiuChuanan on 2017/6/8.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import "ViewController.h"
#import "ETTVideoPlayerManager.h"
#import <ReplayKit/ReplayKit.h>

@interface ViewController ()<RPScreenRecorderDelegate,RPPreviewViewControllerDelegate>

@property (nonatomic, strong) RPScreenRecorder *screenRecorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ETTVideoPlayerManager *videoPlayerManager = [[ETTVideoPlayerManager alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 300) superView:self.view];
//    
//    videoPlayerManager.videoURLString = @"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
    //[self setupButton];
}

- (void)setupButton
{
    UIButton *button = [UIButton new];
    [button setTitle:@"record" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor redColor]];
    [button setFrame:CGRectMake(200, 200, 200, 200)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    [self.view addSubview:button];
}

#pragma mark 按钮事件回调
- (void)buttonAction:(UIButton *)button
{
    
    button.selected = !button.selected;
    [RPScreenRecorder sharedRecorder].delegate = self;
    [RPScreenRecorder sharedRecorder].cameraEnabled = YES;
    if (button.selected) 
    {
        [button setTitle:@"record" forState:UIControlStateNormal];
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            
            if (error) 
            {
                NSLog(@"%@",error.description);
            } else
            {
                if (previewViewController) 
                {
                    previewViewController.navigationItem.title = @"开始";
                    previewViewController.navigationItem.rightBarButtonItem = [self setupNavigationBarItem];
                    previewViewController.previewControllerDelegate = self;
                    [self presentViewController:previewViewController animated:YES completion:^{
                        
                    }];
                } 
            }
        }];
    } else
    {
        [button setTitle:@"stop" forState:UIControlStateNormal];
        
        BOOL isScreen = [RPScreenRecorder sharedRecorder].available;
        if (isScreen) 
        {
            [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                
            }];
        }
    }
    
    
    
}

- (UIBarButtonItem *)setupNavigationBarItem
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button setFrame:CGRectMake(20, 10, 100, 44)];
    [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return rigthItem;
}

- (void)rightButtonAction:(UIButton *)button
{
    NSLog(@"右边被点击了");
}

#pragma mark screenRecorderDelegate
- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(RPPreviewViewController *)previewViewController
{
    
}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder
{
    
}

#pragma mark previewControllerDelegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
    [previewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

