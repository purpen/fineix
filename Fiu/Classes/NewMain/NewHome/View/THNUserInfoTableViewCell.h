//
//  THNUserInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

@interface THNUserInfoTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UIView *bottomView;
@pro_strong UIButton *head;
@pro_strong UIImageView *certificate;
@pro_strong UILabel *name;
@pro_strong UIButton *time;
@pro_strong UIButton *address;
@pro_strong UIButton *follow;
@pro_strong UICollectionView *hotUserList;

- (void)thn_setHomeSceneUserInfoData:(HomeSceneListRow *)userModel;

/*
 *  是否显示推荐的热门用户
 */
- (void)thn_isShowHotUserList:(BOOL)show;

@end
