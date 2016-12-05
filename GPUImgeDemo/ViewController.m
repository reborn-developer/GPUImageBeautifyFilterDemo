//
//  ViewController.m
//  GPUImgeDemo
//
//  Created by reborn on 16/11/7.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "ViewController.h"
#import "GPUImageFilterViewController.h"
#import "BeautifyFilterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *GPUImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    GPUImageButton.frame = CGRectMake(10, 100, 300, 30);
    GPUImageButton.backgroundColor = [UIColor blueColor];
    [GPUImageButton setTitle:@"GPUImage美颜" forState:UIControlStateNormal];
    [GPUImageButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GPUImageButton];
    
    
    UIButton *BeautifyFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BeautifyFilterButton.frame = CGRectMake(10, 150, 300, 30);
    BeautifyFilterButton.backgroundColor = [UIColor blueColor];
    [BeautifyFilterButton setTitle:@"BeautifyFilter美颜" forState:UIControlStateNormal];
    [BeautifyFilterButton addTarget:self action:@selector(broadCastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BeautifyFilterButton];
}

-(void)collectAction:(id)sender
{
     GPUImageFilterViewController *GPUImageVC = [[GPUImageFilterViewController alloc] init];
    [self.navigationController pushViewController:GPUImageVC animated:YES];
}

-(void)broadCastAction:(id)sender
{
    BeautifyFilterViewController *BeautifyFilterVC = [[BeautifyFilterViewController alloc] init];
    [self.navigationController pushViewController:BeautifyFilterVC animated:YES];
}



@end
