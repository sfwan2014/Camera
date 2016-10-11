//
//  SFCapture.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "SFCapture.h"
#import <ImageIO/ImageIO.h>

@interface SFCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *currentInput;
@property (nonatomic, strong) AVCaptureDeviceInput *originInput;

@property (nonatomic, strong) AVCaptureOutput *output;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, assign) AVCaptureTorchMode torchMode; // 闪光灯模式

@end

@implementation SFCapture

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commit];
    }
    return self;
}

-(void)commit{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请到设置中允许使用摄像头功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return ;
                }
                
                [self openDefaultDevice];
                
                [self startRunning];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请确定你的设备是否被进行家长控制" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case AVAuthorizationStatusDenied:
        {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请到设置中允许使用摄像头功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            [self openDefaultDevice];
        }
            break;
            
        default:
            break;
    }
}

// 打开默认的摄像头  后置摄像头
-(void)openDefaultDevice{
    BOOL res = [self configDevice:AVCaptureDevicePositionBack];
    if (res) {
        // 默认闪光灯自动模式
        [self settingTorchWithMode:AVCaptureTorchModeAuto];
        
        [self configDeviceInput];
        
        [self configDefaultOutput];
        
        [self configCaptureSession];
    }
}

-(BOOL)configDevice:(AVCaptureDevicePosition)position{
    
    self.device = nil;
    self.device = [self cameraWithPosition:position];
    if (!self.device) {
        // 无摄像头
        NSLog(@"无摄像头");
        return NO;
    }
    
    return YES;
}
// 打开摄像头
-(void)settingTorchWithMode:(AVCaptureTorchMode)torchMode{
    
    AVCaptureFlashMode flashMode = AVCaptureFlashModeOff;
    switch (torchMode) {
        case AVCaptureTorchModeOff:
        {
            flashMode = AVCaptureFlashModeOff;
        }
            break;
        case AVCaptureTorchModeOn:
        {
            flashMode = AVCaptureFlashModeOn;
        }
            break;
        case AVCaptureTorchModeAuto:
        {
            flashMode = AVCaptureFlashModeAuto;
        }
            break;
            
        default:
            break;
    }
    
    _torchMode = torchMode;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            [device setTorchMode:torchMode];
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
    }
}

-(BOOL)changeDevice:(AVCaptureDevicePosition)position{
    self.device = nil;
    self.device = [self cameraWithPosition:position];
    if (!self.device) {
        // 无摄像头
        NSLog(@"无摄像头");
        return NO;
    }
    
    [self configDeviceInput];
    
    [self configCaptureSession];
    return YES;
}

-(BOOL)configDeviceInput
{
    NSError *error = nil;
    self.originInput = self.currentInput;
    self.currentInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        // 调用摄像头失败
        NSLog(@"调用摄像头失败");
        return NO;
    }
    return YES;
}

-(void)configCaptureSession{
    
    [self.session beginConfiguration];
    if (self.originInput != nil) {
        [self.session removeInput:self.originInput];
    }
    
    if ([self.session canAddInput:self.currentInput]) {
        [self.session addInput:self.currentInput];
        
    } else {
        NSLog(@" 添加输入接口失败 ");
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    } else {
        NSLog(@" 添加输出接口失败 ");
    }
    
    [self.session commitConfiguration];
}

-(AVCaptureOutput *)outputWithFunctionType:(SFCaptureFunctionType)type{
    AVCaptureOutput * output = nil;
    if (type == SFCapturePhotoFunctionType) {
        AVCaptureStillImageOutput *newOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [newOutput setOutputSettings:myOutputSettings];
        
        output = newOutput;
    } else {
        AVCaptureVideoDataOutput *newOutput = [[AVCaptureVideoDataOutput alloc] init];
        newOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
        dispatch_queue_t queue = dispatch_queue_create("MyCameraQueue", NULL);
        [newOutput setSampleBufferDelegate:self queue:queue];
        output = newOutput;
    }
    return output;
}
// 配置默认输出  照相机
-(void)configDefaultOutput{
    self.output = [self outputWithFunctionType:SFCapturePhotoFunctionType];
}
// 重置输出  照相 或者 录视频
-(void)resetOutputWithFunctionType:(SFCaptureFunctionType)type{
    self.output = [self outputWithFunctionType:type];
}

-(void)startRunning{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

-(void)stopRunning{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}


#pragma mark - -AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    // 视频采样
    
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    if (self.block) {
//        self.block(image);
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(capture:reslut:)]) {
//        [self.delegate capture:self reslut:image];
//    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer

{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    
    
    // Get the number of bytes per row for the pixel buffer
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    
    // Create a device-dependent RGB color space
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (!colorSpace)
        
    {
        
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        
        return nil;
        
    }
    
    
    
    // Get the base address of the pixel buffer
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the data size for contiguous planes of the pixel buffer.
    
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    
    
    // Create a Quartz direct-access data provider that uses data we supply
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              
                                                              NULL);
    
    // Create a bitmap image from data supplied by our data provider
    
    CGImageRef cgImage =
    
    CGImageCreate(width,
                  
                  height,
                  
                  8,
                  
                  32,
                  
                  bytesPerRow,
                  
                  colorSpace,
                  
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  
                  provider,
                  
                  NULL,
                  
                  true,
                  
                  kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);
    
    CGColorSpaceRelease(colorSpace);
    
    
    
    // Create and return an image object representing the specified Quartz image
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    
    
    return image;
    
}

- (void)dealloc
{
    [self.session stopRunning];
    [self.session removeInput:self.currentInput];
    [self.session removeOutput:self.output];
    
    [self.layer removeFromSuperlayer];
    self.layer = nil;
    self.session = nil;
    self.originInput = nil;
    self.currentInput = nil;
    self.output = nil;
    
    NSLog(@"SFCapture dealloc");
}






#pragma mark - setter
-(void)setFunctionType:(SFCaptureFunctionType)functionType{
    _functionType = functionType;
}

-(void)setFocusMode:(AVCaptureFocusMode)focusMode{
    NSError *error = nil;
    [self.device lockForConfiguration:&error];
    if (error) {
        NSLog(@"lockForConfiguration error :%@", error);
        return;
    }
    
    [self.device setFocusMode:focusMode];
    _focusMode = focusMode;
    [self.device unlockForConfiguration];
}


#pragma mark - getter
-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)layer {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)_layer;
    if (!_layer) {
        if (![[NSThread currentThread] isMainThread]) {
            NSLog(@"不是主线程");
        }
        layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //        layer.affineTransform = self.transform;
        //        layer.delegate = self;
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        CGRect layerRect = CGRectMake(0, 0, screenWidth, screenHeight);
        [layer setBounds:layerRect];
        [layer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        _layer = layer;
    }
    return layer;
}

-(AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == position) {
                AVCaptureDeviceFormat *format = [device activeFormat];
                NSArray *ranges = [format videoSupportedFrameRateRanges];
                AVFrameRateRange *range = [ranges firstObject];
                
                NSError *error = nil;
                [device lockForConfiguration:&error];
                if (error) {
                    NSLog(@"lockForConfiguration error :%@", error);
                }
                
                [device setActiveVideoMinFrameDuration:range.minFrameDuration];
                [device setActiveVideoMaxFrameDuration:range.maxFrameDuration];
                [device unlockForConfiguration];
                return device;
            }
        }
    }
    return nil;
}

@end

