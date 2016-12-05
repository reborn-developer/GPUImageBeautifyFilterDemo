//
//  GPUImageFilterViewController.m
//  GPUImgeDemo
//
//  Created by reborn on 16/11/7.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "GPUImageFilterViewController.h"
#import <GPUImage/GPUImage.h>


@interface GPUImageFilterViewController ()
@property (nonatomic, weak)GPUImageBilateralFilter  *bilateralFilter;
@property (nonatomic, weak)GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong)GPUImageVideoCamera      *videoCamera;
@end

@implementation GPUImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"GPUImage美颜";
    
    [self initBottomView];
    
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

    
    //  4.创建磨皮、美白组合滤镜
    GPUImageFilterGroup *groupFliter = [[GPUImageFilterGroup alloc] init];
    
    //  5.磨皮滤镜
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [groupFliter addFilter:bilateralFilter];
    _bilateralFilter = bilateralFilter;
    
    //  6.美白滤镜
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [groupFliter addFilter:brightnessFilter];
    _brightnessFilter = brightnessFilter;
    
    
    //  7.设置滤镜组链
    [bilateralFilter addTarget:brightnessFilter];
    [groupFliter setInitialFilters:@[bilateralFilter]];
    groupFliter.terminalFilter = brightnessFilter;
    
    //  8.设置GPUImage处理链 从数据源->滤镜->界面展示
    [videoCamera addTarget:groupFliter];
    [groupFliter addTarget:captureVideoPreview];
    
    //  9.调用startCameraCapture采集视频,底层会把采集到的视频源，渲染到GPUImageView上，接着界面显示
    [videoCamera startCameraCapture];
}

- (void)initBottomView
{
    UIView *bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 450, 320, 118)];
    [self.view addSubview:bottomControlView];
    

    //磨皮
    UILabel *bilateralL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 25)];
    bilateralL.text = @"磨皮";
    bilateralL.font = [UIFont systemFontOfSize:12];
    [bottomControlView addSubview:bilateralL];
    
    UISlider *bilateralSld  = [[UISlider alloc] initWithFrame:CGRectMake(50, 10, 250, 30)
                                ];
//    bilateralSld.minimumValue = -1;
    bilateralSld.maximumValue = 10;
//    bilateralSld.value = 0;
    [bilateralSld addTarget:self action:@selector(bilateralFilter:) forControlEvents:UIControlEventValueChanged];
    [bottomControlView addSubview:bilateralSld];
    
    
    //美白
    UILabel *brightnessL = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 40, 25)];
    brightnessL.text = @"美白";
    brightnessL.font = [UIFont systemFontOfSize:12];
    [bottomControlView addSubview:brightnessL];
    
    UISlider *brightnessSld  = [[UISlider alloc] initWithFrame:CGRectMake(50, 40, 250, 30)
                                ];
    brightnessSld.minimumValue = -1;
    brightnessSld.maximumValue = 1;
//    brightnessSld.value = 0;
    [brightnessSld addTarget:self action:@selector(brightnessFilter:) forControlEvents:UIControlEventValueChanged];
    [bottomControlView addSubview:brightnessSld];
}
#pragma mark - 调整亮度
- (void)brightnessFilter:(UISlider *)slider
{
    _brightnessFilter.brightness = slider.value;
}

#pragma mark - 调整磨皮
- (void)bilateralFilter:(UISlider *)slider
{
    //值越小，磨皮效果越好
    CGFloat maxValue = 10;
    [_bilateralFilter setDistanceNormalizationFactor:(maxValue - slider.value)];
}

@end
