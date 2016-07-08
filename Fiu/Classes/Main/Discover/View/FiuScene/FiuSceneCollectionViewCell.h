//
//  FiuSceneCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FiuSceneRow.h"
#import "UIImageView+SDWedImage.h"

@interface FiuSceneCollectionViewCell : UICollectionViewCell

@pro_assign BOOL                            choose;
@pro_strong UIImageView                 *   sceneImage;     //  情景图片
@pro_strong UILabel                     *   titleLab;       //  情景标题
@pro_strong UIImageView                 *   locationIcon;   //  地理位置图标
@pro_strong UILabel                     *   locationLab;    //  地理位置
@pro_strong UIImageView                 *   bgImg;          //  遮罩

- (void)setFiuSceneList:(FiuSceneRow *)model;

@end
