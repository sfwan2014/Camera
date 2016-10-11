//
//  ViewController.m
//  CameraDemo
//
//  Created by DBC on 16/10/9.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "MLImageCrop.h"
#import "SFCaptureHeader.h"

@interface ViewController ()<SFCameraCaptureDelegate, MLImageCropDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    CameraViewController *camera = [[CameraViewController alloc] init];
    // 必须模态弹出
    [self presentViewController:camera animated:YES completion:nil];
    camera.canEdit = YES;
    camera.ratioOfWidthAndHeight = screenWidth/200.0;
    camera.delegate = self;
}

#pragma mark - SFCameraCaptureDelegate
-(void)cameraCapture:(CameraViewController *)controller didFinishCaptureImage:(UIImage *)image{
//    [controller dismissViewControllerAnimated:NO completion:nil];
//    [self cropImage:image withRequester:controller];
    self.imageView.image = image;
}

@end
