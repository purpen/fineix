//
//  THNSceneImageViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNSceneImageScrollView.h"
#import "UIView+TYAlertView.h"
#import <SDWebImage/UIImage+MultiFormat.h>

@interface THNSceneImageViewController : THNViewController

@pro_strong FBRequest *userRequest;     //  检查权限
@pro_strong FBRequest *stickRequest;    //  推荐
@pro_strong FBRequest *fineRequest;     //  精选
@pro_strong FBRequest *checkRequest;    //  屏蔽

@pro_strong NSString *sceneId;
@pro_strong NSString *imageUrl;
@pro_strong THNSceneImageScrollView *imageView;


/**
 加载情境原图

 @param image 图片地址
 */
- (void)thn_setLookSceneImage:(NSString *)image;

/**
 情境的状态

 @param fine  是否精选
 @param stick 是否推荐
 @param check 是否屏蔽
 */
- (void)thn_getSceneState:(NSInteger)fine stick:(NSInteger)stick check:(NSInteger)check;
@end
