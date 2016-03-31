//
//  ShareView.h
//  fineix
//
//  Created by THN-Dong on 16/3/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface ShareView : UIView

@property (strong, nonatomic) UIView                *       bgView;
@property (strong, nonatomic) UIView                *       shareView;
@property (strong, nonatomic) UIButton              *       wechat;
@property (strong, nonatomic) UIButton              *       wechatTimeline;
@property (strong, nonatomic) UIButton              *       sina;
@property (strong, nonatomic) UIButton              *       qq;

@property (strong, nonatomic) UILabel               *       wechatLab;
@property (strong, nonatomic) UILabel               *       wechatTimelineLab;
@property (strong, nonatomic) UILabel               *       sinaLab;
@property (strong, nonatomic) UILabel               *       qqLab;

@property (strong, nonatomic) UIButton              *       cancel;

@end
