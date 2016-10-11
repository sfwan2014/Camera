//
//  MLImageCrop.h
//  DaBaiCai
//
//  Created by 王烨谱 on 16/5/18.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLImageCrop;
@protocol MLImageCropDelegate <NSObject>

@optional
/**
 *  截图
 *
 */
-(void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;

/**
 *  截图完成
 *
 */
-(void)cropImageController:(MLImageCrop *)controller requester:(UIViewController *)requester didFinishCropImage:(UIImage *)cropImage originalImage:(UIImage *)originalImage;
/**
 *  取消截图
 *
 */
-(void)cropImageController:(MLImageCrop *)controller didCancelCropImageWithRequester:(UIViewController *)requester;
@end

@interface MLImageCrop : UIViewController

//下面俩哪个后面设置，即是哪个有效
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSURL *imageURL;
@property(nonatomic, strong)UIActivityIndicatorView *testActivityIndicator;//菊花

@property(nonatomic,weak) id<MLImageCropDelegate> delegate;
@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比
/**
 * 初始化 必须实现代理
 * cropImageController: requester: didFinishCropImage: originalImage:
 * cropImageController: didCancelCropImageWithRequester:
 */
-(instancetype)initWithRequester:(UIViewController *)requester;
// 显示
- (void)showWithAnimation:(BOOL)animation;
// 弹出截图控制器
-(void)presentCropImageViewControllerWithAnimation:(BOOL)flag;
// 隐藏截图控制器
-(void)dismissCropImageViewControllerAnimated:(BOOL)flag;

@end
