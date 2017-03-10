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

@property (nonatomic, strong) UIViewController               *       vc;
@property (nonatomic, strong) UINavigationController         *       navVC;
@property (nonatomic, strong) NSArray                        *       imgArr;
@property (nonatomic, strong) SDCycleScrollView              *       rollImageView;
@property (nonatomic, strong) NSMutableArray                 *       rollImgDataList;
@property (nonatomic, strong) NSMutableArray                 *       imgMarr;
@property (nonatomic, strong) NSMutableArray                 *       targetIdMarr;
@property (nonatomic, strong) NSMutableArray                 *       typeMarr;
@property (nonatomic, strong) NSMutableArray                 *       goodsImageMarr;

@property (nonatomic, copy) GetProjectTypeBlock getProjectType;

- (void)setRollimageView:(NSMutableArray *)model;

- (void)setGoodsRollimageView:(GoodsInfoData *)model;

- (void)setThnGoodsRollImgData:(FBGoodsInfoModelData *)model;

@end
