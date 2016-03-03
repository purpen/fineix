//
//  ClipImageViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@class CropImageView;

@interface ClipImageViewController : UIViewController

@pro_strong CropImageView           *   clipImageView;      //  裁剪图片视图
@pro_assign CGRect                      clipImgRect;        //  裁剪的位置和大小
@pro_strong UIImage                 *   clipImage;          //  需要裁剪的图片

- (UIImage *)clippingImage;

@end
