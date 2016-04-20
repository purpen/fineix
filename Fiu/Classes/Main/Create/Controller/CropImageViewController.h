//
//  CropImageViewController.h
//  fineix
//
//  Created by FLYang on 16/3/3.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "ClipImageViewController.h"
#import "CropImageView.h"

@interface CropImageViewController : FBPictureViewController

@pro_strong NSString                    *   createType;         //  创建类型（场景/情景）
@pro_strong NSArray                     *   locationArr;
@pro_strong ClipImageViewController     *   clipImageVC;
@pro_strong UIImage                     *   clipImage;

@end
