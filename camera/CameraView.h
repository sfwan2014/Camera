//
//  CameraView.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCaptureHeader.h"

typedef void (^CameraBlock)(id result);

@class CameraView;
@protocol CameraDelegate <NSObject>

-(void)camera:(CameraView *)camera reslut:(id)data;

@end

@interface CameraView : UIView
@property (nonatomic, copy) CameraBlock block;
@property (nonatomic, assign) id<CameraDelegate> delegate;

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
