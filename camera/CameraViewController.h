//
//  CameraViewController.h
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@protocol SFCameraCaptureDelegate <NSObject>

-(void)cameraCapture:(CameraViewController *)controller didFinishCaptureImage:(UIImage *)image;

@end

@interface CameraViewController : UIViewController

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) CGFloat ratioOfWidthAndHeight; // 宽高比

@property (nonatomic, assign) id<SFCameraCaptureDelegate>delegate;
-(void)restartAction:(UIButton *)button;

@end
