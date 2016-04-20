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

@interface FBRollImages : UIView <SDCycleScrollViewDelegate>

@property (strong, nonatomic) UINavigationController         *       navVC;
@property (strong, nonatomic) NSArray                        *       imgArr;
@property (strong, nonatomic) SDCycleScrollView              *       rollImageView;
@property (strong, nonatomic) NSMutableArray                 *       rollImgDataList;
@property (strong, nonatomic) NSMutableArray                 *       imgMarr;
@property (strong, nonatomic) NSMutableArray                 *       targetIdMarr;
@property (strong, nonatomic) NSMutableArray                 *       typeMarr;

- (void)setRollimageView;

@end
