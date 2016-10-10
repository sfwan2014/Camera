//
//  CameraView.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView
// 开始运行
-(void)stopRunning;
// 停止运行
-(void)startRunning;

// 重拍
-(void)continueCapture;
// 拍照
-(void)captured;

-(BOOL)changeDevice:(AVCaptureDevicePosition)position;
// 设置闪光灯模式
-(void)settingTorchWithMode:(AVCaptureTorchMode)torchMode;
@end
