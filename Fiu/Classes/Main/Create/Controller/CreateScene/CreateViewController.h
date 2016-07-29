//
//  CreateViewController.h
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBFootView.h"
#import "CameraView.h"
#import "PictureView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMediaFormat.h>

@interface CreateViewController : FBPictureViewController

@pro_strong NSString            *   createType;         //  创建类型（场景/情景）
@pro_strong FBFootView          *   footView;           //  底部功能选择视图
@pro_strong PictureView         *   pictureView;        //  相册页面
@pro_strong CameraView          *   cameraView;         //  相机页面
@pro_strong NSString            *   fSceneId;
@pro_strong NSString            *   fSceneTitle;

@end
