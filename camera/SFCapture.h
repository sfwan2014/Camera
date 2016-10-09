//
//  SFCapture.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFCapture;
typedef void (^CaptureBlock)(id result);

@protocol CaptureDelegate <NSObject>

-(void)capture:(SFCapture *)capture reslut:(id)data;

@end

@interface SFCapture : NSObject

@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, assign) id<CaptureDelegate> delegate;

@property (nonatomic, copy) CaptureBlock block;

-(BOOL)configDevice:(AVCaptureDevicePosition)position;
// 开始运行
-(void)stopRunning;
// 停止运行
-(void)startRunning;

// 重拍
-(void)continueCapture;
// 拍照
-(void)captured;

@end
