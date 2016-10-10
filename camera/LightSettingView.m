//
//  LightSettingView.m
//  CameraDemo
//
//  Created by DBC on 16/10/10.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "LightSettingView.h"

#define kDefaultLightViewHeight   44
@implementation LightSettingView
{
    NSMutableArray *_buttonArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

-(void)_initViews{
    NSArray *titles = @[@"自动", @"打开", @"关闭"];
    NSInteger count = titles.count;
    _buttonArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *title = titles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger count = _buttonArray.count;
    CGFloat width = self.frame.size.width/count;
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = _buttonArray[i];
        button.frame = CGRectMake(i*width, 0, width, height);
    }
}

#pragma mark - buttonAction
-(void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(lightView:didSelectedAtIndex:)]) {
        [self.delegate lightView:self didSelectedAtIndex:button.tag];
    }
}

-(void)showInView:(UIView *)superView frame:(CGRect)frame{
    
    UIView *view = [superView viewWithTag:10100];
    if (view != nil) {
        return;
    }
    
    //    CGRect frame = CGRectMake(0, 64+44, kScreenWidth, kScreenHeight-64-44);
    self.frame = frame;
    self.tag = 10100;
    self.backgroundColor = [UIColor clearColor];
    [superView addSubview:self];
    
    [self hideAfterDuration:3];
}

- (void) hideAfterDuration:(double)duration {
    
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:duration
                                              target:self selector:@selector(removeToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
}

-(void)hide{
    
    UIView *superView = self.superview;
    if (superView == nil) {
        return;
    }
    
    UIView *view = [superView viewWithTag:10100];
    [UIView animateWithDuration:0.35 animations:^{
        //        view.top = view.top + view.datePicker.height + view.toolBar.height;
    } completion:^(BOOL finished) {
        if (view.superview != nil) {
            [view removeFromSuperview];
        }
    }];
}

+(BOOL)isShowInView:(UIView *)superView{
    if (superView == nil) {
        return NO;
    }
    
    UIView *view = [superView viewWithTag:10100];
    if (view == nil) {
        return NO;
    }
    return YES;
}

+(BOOL)hideFromView:(UIView *)superView{
    if (superView == nil) {
        return NO;
    }
    
    UIView *view = [superView viewWithTag:10100];
    if (view == nil) {
        return NO;
    }
    [UIView animateWithDuration:0.35 animations:^{
        //        view.top = view.top + view.datePicker.height + view.toolBar.height;
    } completion:^(BOOL finished) {
        if (view.superview != nil) {
            [view removeFromSuperview];
        }
    }];
    return YES;
}


@end
