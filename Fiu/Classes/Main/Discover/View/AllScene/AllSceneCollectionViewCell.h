//
//  AllSceneCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FiuSceneInfoData.h"
#import "UIImageView+SDWedImage.h"

@interface AllSceneCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView         *   sceneImage;     //  情景图
@pro_strong UIImageView         *   locationIcon;   //  地理位置图标
@pro_strong UILabel             *   locationLab;    //  地理位置
@pro_strong UILabel             *   titleLab;       //  标题

- (void)setAllFiuSceneListData:(FiuSceneInfoData *)model;

@end
