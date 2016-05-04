//
//  CropImageView.h
//  fineix
//
//  Created by FLYang on 16/3/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@class CropLayer;

@protocol CropImageViewDelegate <NSObject>

@required

- (void)show;

/**
 * 更换图片或者更换设定clippingRect的时候需要被调用
 * 确保clippingRect始终在图片内部.
 */
- (void)initializeImageViewSize;

/**
 * 处理图片移出裁剪框的情况
 */
- (CGPoint)handleBorderOverflow;

/**
 * 处理图片缩放小于裁剪框的尺寸
 */
- (CGRect)handleScaleOverflowWithPoint:(CGPoint)point;

@end

#pragma mark - 裁剪图片的视图

@interface CropImageView : UIView <CropImageViewDelegate>

@pro_strong UIImageView         *   cropImage;  //  需要裁剪的图片视图
@pro_strong CropLayer           *   cropGrid;   //  裁剪是的遮罩

@end


#pragma mark - 裁剪视图的遮罩

@interface CropLayer : CALayer

@pro_assign CGRect                  clipRect;   //  裁剪的范围
@pro_strong UIColor             *   bgColor;    //  背景颜色
@pro_strong UIColor             *   gridColor;  //  裁掉的范围格子

@end
