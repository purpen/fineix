//
//  THNHotUserCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "THNMacro.h"
#import "HotUserListUser.h"

typedef void(^ColseTheHotUserBlock)(NSString *userId);
typedef void(^FollowHotUserBlock)(NSString *userId);
typedef void(^CancelFollowHotUserBlock)(NSString *userId);

@interface THNHotUserCollectionViewCell : UICollectionViewCell

@pro_strong UIButton *close;
@pro_strong UIImageView *header;
@pro_strong UILabel *name;
@pro_strong UIImageView *certificate;
@pro_strong UILabel *info;
@pro_strong UIButton *follow;

- (void)setHotUserListData:(HotUserListUser *)model;

/**
 *  关闭热门用户
 */
@pro_copy ColseTheHotUserBlock colseTheHotUserBlock;

/**
 *  关注热门用户
 */
@pro_copy FollowHotUserBlock followHotUserBlock;

/**
 *  取消关注热门用户
 */
@pro_copy CancelFollowHotUserBlock cancelFollowHotUserBlock;

@end
