//
//  SFCapture.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCaptureHeader.h"
typedef enum : NSUInteger {
    SFCapturePhotoFunctionType = 0, // 相机
    SFCaptureVideoFunctionType, // 摄像头
} SFCaptureFunctionType;



@interface SFCapture : NSObject

@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, assign) SFCaptureFunctionType functionType;
@property (nonatomic, assign,readonly) AVCaptureTorchMode torchMode; // 闪光灯模式
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
@property (nonatomic, strong,readonly) AVCaptureDevice *device; // 设备
@property (nonatomic, strong, readonly) AVCaptureOutput *output;
// 设置闪光灯模式
-(void)settingTorchWithMode:(AVCaptureTorchMode)torchMode;



//-(BOOL)configDevice:(AVCaptureDevicePosition)position;
-(BOOL)changeDevice:(AVCaptureDevicePosition)position;

// 开始运行
-(void)stopRunning;
// 停止运行
-(void)startRunning;

// 重拍
//-(void)continueCapture;
//// 拍照
//-(void)captured;

@end
