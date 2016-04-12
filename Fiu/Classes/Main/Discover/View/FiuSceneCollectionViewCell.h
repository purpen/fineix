//
//  FiuSceneCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FiuSceneCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView                 *   sceneImage;     //  情景图片
@pro_strong UILabel                     *   titleLab;       //  情景标题
@pro_strong UIImageView                 *   locationIcon;   //  地理位置图标
@pro_strong UILabel                     *   locationLab;    //  地理位置

- (void)setUI;

@end
