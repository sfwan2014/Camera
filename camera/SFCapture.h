//
//  SFCapture.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SFCapturePhotoFunctionType = 0, // 相机
    SFCaptureVideoFunctionType, // 摄像头
} SFCaptureFunctionType;

@class SFCapture;
typedef void (^CaptureBlock)(id result);

@protocol CaptureDelegate <NSObject>

-(void)capture:(SFCapture *)capture reslut:(id)data;

@end

@interface SFCapture : NSObject

@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, assign) id<CaptureDelegate> delegate;
@property (nonatomic, assign) SFCaptureFunctionType functionType;
@property (nonatomic, assign,readonly) AVCaptureTorchMode torchMode; // 闪光灯模式
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
@property (nonatomic, strong,readonly) AVCaptureDevice *device; // 设备
// 设置闪光灯模式
-(void)settingTorchWithMode:(AVCaptureTorchMode)torchMode;

@property (nonatomic, copy) CaptureBlock block;

//-(BOOL)configDevice:(AVCaptureDevicePosition)position;
-(BOOL)changeDevice:(AVCaptureDevicePosition)position;

// 开始运行
-(void)stopRunning;
// 停止运行
-(void)startRunning;

// 重拍
-(void)continueCapture;
// 拍照
-(void)captured;

@end
