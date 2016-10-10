//
//  LightSettingView.h
//  CameraDemo
//
//  Created by DBC on 16/10/10.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LightSettingDelegate <NSObject>

-(void)lightView:(UIView *)view didSelectedAtIndex:(NSInteger)index;

@end

@interface LightSettingView : UIView

@property (nonatomic, assign) id<LightSettingDelegate>delegate;
+(BOOL)hideFromView:(UIView *)superView;
+(BOOL)isShowInView:(UIView *)superView;
-(void)hide;
-(void)showInView:(UIView *)superView frame:(CGRect)frame;
@end
