//
//  CameraView.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "CameraView.h"
#import "SFCapture.h"
#import <ImageIO/ImageIO.h>
@interface CameraView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *readImageView;
@property (nonatomic, strong) UIImageView *readLineView;
@property (nonatomic, strong) SFCapture *capture;
@property (nonatomic, strong) UIView *focusView;

@property (nonatomic, assign) CGFloat effectiveScale;
@property (nonatomic, assign) CGFloat beginGestureScale;

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
    self.beginGestureScale = 1.0;
    self.effectiveScale = 1.0;
    [self.layer addSublayer:self.capture.layer];
    // 聚焦
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
    pinch.delegate = self;
}

-(void)startRunning{
    [self.capture startRunning];
}

-(void)stopRunning{
    [self.capture stopRunning];
}

// 拍照
-(void)captured{
    [[self.capture.layer connection] setEnabled:NO];
    
    AVCaptureConnection *myVideoConnection = nil;
    
    //从 AVCaptureStillImageOutput 中取得正确类型的 AVCaptureConnection
    AVCaptureStillImageOutput *myStillImageOutput = (AVCaptureStillImageOutput *)self.capture.output;
    
    for (AVCaptureConnection *connection in myStillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                
                myVideoConnection = connection;
                break;
            }
        }
    }
    [myVideoConnection setVideoScaleAndCropFactor:self.effectiveScale];
    //撷取影像（包含拍照音效）
    [myStillImageOutput captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            //取得的静态影像
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            if (self.block) {
                self.block(image);
            }
            if ([self.delegate respondsToSelector:@selector(camera:reslut:)]) {
                [self.delegate camera:self reslut:image];
            }
            
            //取得影像数据（需要ImageIO.framework 与 CoreMedia.framework）
            CFDictionaryRef myAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            
            NSLog(@"影像属性: %@", myAttachments);
            
        }
    }];
}

// 重拍
-(void)continueCapture{
    [[self.capture.layer connection] setEnabled:YES];
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



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
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

-(void)pinchAction:(UIPinchGestureRecognizer *)recognizer{
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self];
        CGPoint convertedLocation = [self.capture.layer convertPoint:location fromLayer:self.capture.layer.superlayer];
        if ( ! [self.capture.layer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.capture.output connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.capture.layer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
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
