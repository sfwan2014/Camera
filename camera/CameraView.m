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
//    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
//    self.capture.rotation = 90.0f;
    self.capture.delegate = self;
    [self.layer addSublayer:self.capture.layer];
    self.capture.layer.backgroundColor = [UIColor greenColor].CGColor;
//    self.backgroundColor = [UIColor redColor];
}

-(void)startRunning{
    [self.capture startRunning];
}
-(void)stopRunning{
    [self.capture stopRunning];
}

-(void)captured{
    [self.capture captured];
}

-(void)continueCapture{
    [self.capture continueCapture];
}

-(BOOL)changeDevice:(AVCaptureDevicePosition)position{
    return [self.capture configDevice:position];
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



- (void)dealloc
{
    self.capture = nil;
    NSLog(@"CameraView dealloc");
}

@end
