//
//  CameraViewController.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraView.h"

@interface CameraViewController ()
@property (nonatomic, strong) CameraView *camera;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.camera = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.camera];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 50);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 80 - 10, 20, 80, 50);
    [button setTitle:@"前置镜头" forState:UIControlStateNormal];
    [button setTitle:@"后置镜头" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth - 50)/2.0, kScreenHeight - 50 - 10, 50, 50);
    [button setTitle:@"拍摄" forState:UIControlStateNormal];
    [button setTitle:@"重拍" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(captureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (!button.selected) {
        [self.camera captured];
    } else {
        [self.camera continueCapture];
    }
    button.selected = !button.selected;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.camera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.camera stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)dealloc
{
    NSLog(@"CameraViewController dealloc");
}

@end
