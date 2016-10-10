//
//  CameraView.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "CameraView.h"
#import "SFCapture.h"
@interface CameraView ()<CaptureDelegate>
@property (nonatomic, strong) UIImageView *readImageView;
@property (nonatomic, strong) UIImageView *readLineView;
@property (nonatomic, strong) SFCapture *capture;
@property (nonatomic, strong) UIView *focusView;

@end

@implementation CameraView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self commit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commit];
    }
    return self;
}

- (void)commit
{ 
    self.capture = [[SFCapture alloc] init];
//    self.capture.delegate = self;
//    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
//    self.capture.rotation = 90.0f;
    self.capture.delegate = self;
    [self.layer addSublayer:self.capture.layer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

-(void)startRunning{
    [self.capture startRunning];
}

-(void)stopRunning{
    [self.capture stopRunning];
}
// 拍照
-(void)captured{
    [self.capture captured];
}
// 重拍
-(void)continueCapture{
    [self.capture continueCapture];
}

// 设置闪光灯模式
-(void)settingTorchWithMode:(AVCaptureTorchMode)torchMode{
    [self.capture settingTorchWithMode:torchMode];
}
// 切换前后摄像头
-(BOOL)changeDevice:(AVCaptureDevicePosition)position{
    return [self.capture changeDevice:position];
}

// 手动聚焦
-(void)focusAtPoint:(CGPoint)point{
    //实例化
    AVCaptureDevice  *captureDevice = self.capture.device;
    //先进行判断是否支持控制对焦
    if (captureDevice.isFocusPointOfInterestSupported && [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error = nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [self.capture.device lockForConfiguration:&error];
        [self.capture.device setFocusMode:AVCaptureFocusModeAutoFocus];
        [self.capture.device setFocusPointOfInterest:CGPointMake(point.x,point.y)];
        //操作完成后，记得进行unlock。
        [self.capture.device unlockForConfiguration];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    self.readImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanBox"]];
//    [self addSubview:self.readImageView];
//    
//    self.readLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
//    [self addSubview:self.readLineView];
//    
//    self.readImageView.frame =
//    CGRectMake((rect.size.width - MIN(rect.size.width * 3 / 4, rect.size.height * 3 / 4)) / 2,
//               (rect.size.height - MIN(rect.size.width * 3 / 4, rect.size.height * 3 / 4)) / 2,
//               MIN(rect.size.width * 3 / 4, rect.size.height * 3 / 4),
//               MIN(rect.size.width * 3 / 4, rect.size.height * 3 / 4));
//    self.readLineView.frame =
//    CGRectMake(self.readImageView.frame.origin.x, self.readImageView.frame.origin.y,
//               self.readImageView.frame.size.width, 10);
    
//    self.capture.layer.frame = self.bounds;
//    //    self.capture.scanRect = self.readImageView.frame;
//    
//    CGAffineTransform captureSizeTransform =
//    CGAffineTransformMakeScale(320 / self.frame.size.width, 480 / self.frame.size.height);
//    self.capture.scanRect =
//    CGRectApplyAffineTransform(self.readImageView.frame, captureSizeTransform);
    
//    CALayer *imageLayer = [CALayer layer];
//    imageLayer.frame = self.layer.bounds;
//    // 0.012 0 0
//    imageLayer.backgroundColor =
//    [[UIColor colorWithRed:0.012 green:0.000 blue:0.000 alpha:0.400] CGColor];
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.fillRule = kCAFillRuleEvenOdd;
//    maskLayer.frame = self.bounds;
//    
//    CGRect inset = CGRectInset(self.bounds, 0, 0);
//    CGMutablePathRef p1 = CGPathCreateMutable();
//    CGPathAddPath(p1, nil,
//                  CGPathCreateWithRect(CGRectInset(self.bounds, self.readImageView.frame.origin.x,
//                                                   self.readImageView.frame.origin.y),
//                                       nil));
//    CGPathAddPath(p1, nil, CGPathCreateWithRect(inset, nil));
//    maskLayer.path = p1;
//    imageLayer.mask = maskLayer;
//    [self.layer addSublayer:imageLayer];
}


#pragma mark - CaptureDelegate
-(void)capture:(SFCapture *)capture reslut:(id)data{
    
}

#pragma mark - action
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self];
    
    CGPoint p = CGPointMake(point.x/self.frame.size.width, point.y/self.frame.size.height);
    
    [self focusAtPoint:p];
    
    
    self.focusView.frame = CGRectMake(0,0, 100, 100);
    self.focusView.center = point;
    [UIView animateWithDuration:0.35 animations:^{
        self.focusView.frame = CGRectMake(0,0, 50, 50);
        self.focusView.center = point;
    }];
}

- (void)dealloc
{
    self.capture = nil;
    NSLog(@"CameraView dealloc");
}


#pragma mark -- getter
-(UIView *)focusView{
    if (_focusView == nil) {
        UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        focusView.layer.masksToBounds = YES;
        focusView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.9 blue:0.5 alpha:1].CGColor;
        focusView.layer.borderWidth = 0.5;
        focusView.backgroundColor = [UIColor clearColor];
        [self addSubview:focusView];
        _focusView = focusView;
    }
    return _focusView;
}

@end
