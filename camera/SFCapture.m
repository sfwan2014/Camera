//
//  SFCapture.m
//  DaBaiCai
//
//  Created by DBC on 16/10/8.
//  Copyright © 2016年 大白菜. All rights reserved.
//

#import "SFCapture.h"

@interface SFCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *currentInput;
@property (nonatomic, strong) AVCaptureDeviceInput *originInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *output;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;

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
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请到设置中允许使用摄像头功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        
        [self configDevice:AVCaptureDevicePositionBack];
    }];
}

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
        CGRect layerRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
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
                return device;
            }
        }
    }
    return nil;
}

-(BOOL)configDevice:(AVCaptureDevicePosition)position{
    
    self.device = nil;
    self.device = [self cameraWithPosition:position];
    if (!self.device) {
        // 无摄像头
        NSLog(@"无摄像头");
        return NO;
    }
    [self configDeviceInput];
    return YES;
}

-(void)configDeviceInput
{
    NSError *error = nil;
    self.originInput = self.currentInput;
    self.currentInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        // 调用摄像头失败
        NSLog(@"调用摄像头失败");
        return;
    }
    
    [self configCaptureSession];
    
    [self configOutput];
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
    
    [self.session commitConfiguration];
}

-(void)configOutput{
    if (self.output == nil) {
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        self.output.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
//        self.output.minFrameDuration = CMTimeMake(1, 15);
//        dispatch_queue_t queue = dispatch_queue_create("MyCameraQueue", NULL);
        
        dispatch_queue_t queue = dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
        
        [self.output setSampleBufferDelegate:self queue:queue];
        
        
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
        } else {
            NSLog(@" 添加输出接口失败 ");
        }
        
        [self startRunning];
    }
    
}

-(void)startRunning{
    [self.session startRunning];
}

-(void)stopRunning{
    [self.session stopRunning];
}

-(void)captured{
    [[self.layer connection] setEnabled:NO];
}

-(void)continueCapture{
    [[self.layer connection] setEnabled:YES];
}

#pragma mark - -AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    if (self.block) {
        self.block(image);
    }
    
    if ([self.delegate respondsToSelector:@selector(capture:reslut:)]) {
        [self.delegate capture:self reslut:image];
    }
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

@end

