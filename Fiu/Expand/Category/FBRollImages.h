//
//  FBRollImages.h
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "Fiu.h"
#import "GoodsInfoData.h"
#import "FBGoodsInfoModelData.h"
#import "RollImageRow.h"

typedef void(^GetProjectTypeBlock)(NSString *idx);

@interface FBRollImages : UIView <SDCycleScrollViewDelegate>

@pro_strong UIViewController               *       vc;
@pro_strong UINavigationController         *       navVC;
@pro_strong NSArray                        *       imgArr;
@pro_strong SDCycleScrollView              *       rollImageView;
@pro_strong NSMutableArray                 *       rollImgDataList;
@pro_strong NSMutableArray                 *       imgMarr;
@pro_strong NSMutableArray                 *       targetIdMarr;
@pro_strong NSMutableArray                 *       typeMarr;
@pro_strong NSMutableArray                 *       goodsImageMarr;

@pro_copy GetProjectTypeBlock getProjectType;

- (void)setRollimageView:(NSMutableArray *)model;

- (void)setGoodsRollimageView:(GoodsInfoData *)model;

- (void)setThnGoodsRollImgData:(FBGoodsInfoModelData *)model;

@end
