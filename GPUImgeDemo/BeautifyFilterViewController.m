//
//  BeautifyFilterViewController.m
//  GPUImgeDemo
//
//  Created by reborn on 16/11/7.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "BeautifyFilterViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface BeautifyFilterViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *captureVideoPreview;
@end

@implementation BeautifyFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Beautify美颜";
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(140, 80, 70, 30)];
    [switcher addTarget:self action:@selector(changeBeautyFilter:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:switcher];
    
    
    //  1. 创建视频摄像头
    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    // cameraPosition:摄像头方向
    // 最好使用AVCaptureSessionPresetHigh，会自动识别，如果用太高分辨率，当前设备不支持会直接报错
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    
    //  2. 设置摄像头输出视频的方向
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera = videoCamera;
    
    
    //  3. 创建用于展示视频的GPUImageView
    GPUImageView *captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVideoPreview atIndex:0];
    _captureVideoPreview = captureVideoPreview;
    
    //  4.设置处理链
    [_videoCamera addTarget:_captureVideoPreview];
    
    //  5.调用startCameraCapture采集视频,底层会把采集到的视频源，渲染到GPUImageView上，接着界面显示
    [videoCamera startCameraCapture];

}

- (void)changeBeautyFilter:(UISwitch *)sender
{
    if (sender.on) {
        
        // 移除之前所有的处理链
        [_videoCamera removeAllTargets];
        
        // 创建美颜滤镜
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        
        // 设置GPUImage处理链，从数据->滤镜->界面展示
        [_videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:_captureVideoPreview];

    } else {
        
        // 移除之前所有的处理链
        [_videoCamera removeAllTargets];
        [_videoCamera addTarget:_captureVideoPreview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
