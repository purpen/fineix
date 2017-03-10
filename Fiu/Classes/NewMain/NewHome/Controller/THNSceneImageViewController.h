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

@property (nonatomic, strong) FBRequest *userRequest;     //  检查权限
@property (nonatomic, strong) FBRequest *stickRequest;    //  推荐
@property (nonatomic, strong) FBRequest *fineRequest;     //  精选
@property (nonatomic, strong) FBRequest *checkRequest;    //  屏蔽

@property (nonatomic, strong) NSString *sceneId;
@property (nonatomic, strong) THNSceneImageScrollView *imageView;

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
