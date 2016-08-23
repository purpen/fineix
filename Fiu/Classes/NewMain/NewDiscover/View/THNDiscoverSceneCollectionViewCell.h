//
//  THNDiscoverSceneCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

@class THNSenceModel;

@interface THNDiscoverSceneCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *image;
@pro_strong UIView *userInfo;
@pro_strong UIImageView *userHeader;
@pro_strong UILabel *userName;
@pro_strong UIButton *likeBtn;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
/** 活动详情 参与情景 */
@property (nonatomic, strong) THNSenceModel *model;

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)model;

@end
