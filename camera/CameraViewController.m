//
//  CameraViewController.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraView.h"
#import "LightSettingView.h"

@interface CameraViewController ()<LightSettingDelegate>
@property (nonatomic, strong) CameraView *camera;

@property (nonatomic, strong) UIButton *changeDeviceButton; // 切换摄像头
@property (nonatomic, strong) UIButton *lightButton; // 返回
@property (nonatomic, strong) UIButton *restartButton; // 重拍
@property (nonatomic, strong) UIButton *captureButton; // 拍照
@property (nonatomic, strong) UIButton *confirmButton; // 确认按钮
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.camera = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.camera];
    
    CGFloat left = 12;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(left, 20, 70, 50);
    [button setTitle:@"闪光灯" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openLightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.lightButton = button;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 80 - 10, 20, 80, 50);
    [button setTitle:@"前置镜头" forState:UIControlStateNormal];
    [button setTitle:@"后置镜头" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.changeDeviceButton = button;
    [self.view addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth - 50)/2.0, kScreenHeight - 50 - 10, 50, 50);
    [button setTitle:@"拍摄" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(captureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.captureButton = button;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(left, kScreenHeight - 50 - 10, 50, 50);
    [button setTitle:@"重拍" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateSelected];
    button.selected = YES;
    [button addTarget:self action:@selector(restartAction:) forControlEvents:UIControlEventTouchUpInside];
    self.restartButton = button;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth - 50-24), kScreenHeight - 50 - 10, 50, 50);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton = button;
    button.hidden = YES;
    [self.view addSubview:button];
}

-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)openLightAction:(UIButton *)button{
    
    BOOL isShow = [LightSettingView isShowInView:self.view];
    if (isShow) {
        [LightSettingView hideFromView:self.view];
        return;
    }
    
    LightSettingView *lightSetting = [[LightSettingView alloc] initWithFrame:CGRectZero];
    
    CGRect frame = CGRectMake(button.frame.origin.x+button.frame.size.width+5, button.frame.origin.y, 124, button.frame.size.height);
    [lightSetting showInView:self.view frame:frame];
    lightSetting.delegate = self;
}

-(void)changeAction:(UIButton *)button{
    
    BOOL changeSuccess = YES;
    if (!button.selected) {
        changeSuccess = [self.camera changeDevice:AVCaptureDevicePositionFront];
    } else {
        changeSuccess = [self.camera changeDevice:AVCaptureDevicePositionBack];
    }
    
    if (changeSuccess) {
        button.selected = !button.selected;
    }
}

-(void)captureAction:(UIButton *)button{
    [self.camera captured];
    self.changeDeviceButton.hidden = YES;
    self.confirmButton.hidden = NO;
    self.lightButton.hidden = YES;
    button.hidden = YES;
    self.restartButton.selected = NO;
}

-(void)restartAction:(UIButton *)button{
    [self.camera continueCapture];
    self.changeDeviceButton.hidden = NO;
    self.confirmButton.hidden = YES;
    self.captureButton.hidden = NO;
    self.lightButton.hidden = NO;
    if (button.selected) {
        [self backAction];
    }
    
    button.selected = YES;
}

-(void)confirmAction:(UIButton *)button{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.camera start];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.camera startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.camera stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LightSettingDelegate
-(void)lightView:(UIView *)view didSelectedAtIndex:(NSInteger)index{
    
    [view removeFromSuperview];
    AVCaptureTorchMode torchMode = AVCaptureTorchModeOff;
    
    switch (index) {
        case 0: // 自动
        {
            torchMode = AVCaptureTorchModeAuto;
        }
            break;
        case 1: // 打开
        {
            torchMode = AVCaptureTorchModeOn;
        }
            break;
        case 2: // 关闭
        {
            torchMode = AVCaptureTorchModeOff;
        }
            break;
            
        default:
            break;
    }
    
    [self.camera settingTorchWithMode:torchMode];
}


- (void)dealloc
{
    NSLog(@"CameraViewController dealloc");
}

@end
