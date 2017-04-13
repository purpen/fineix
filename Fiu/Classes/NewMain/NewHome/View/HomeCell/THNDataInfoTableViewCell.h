//
//  THNDataInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

typedef void(^BeginLikeTheSceneBlock)(NSString *idx);
typedef void(^CancelLikeTheSceneBlock)(NSString *idx);
typedef void(^BeginFavoriteTheSceneBlock)(NSString *idx);
typedef void(^CancelFavoriteTheSceneBlock)(NSString *idx);
typedef void(^DeleteTheSceneBlock)(NSString *idx);
typedef void(^RefreshData)();

@interface THNDataInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIButton *look;
@property (nonatomic, strong) UIButton *like;
@property (nonatomic, strong) UIButton *comments;
@property (nonatomic, strong) UIButton *share;
@property (nonatomic, strong) UIButton *more;

- (void)thn_setSceneData:(HomeSceneListRow *)dataModel isLogin:(BOOL)login isUserSelf:(BOOL)userSelf;

/**
 点赞
 */
@property (nonatomic, copy) BeginLikeTheSceneBlock beginLikeTheSceneBlock;

/**
 取消点赞
 */
@property (nonatomic, copy) CancelLikeTheSceneBlock cancelLikeTheSceneBlock;

/**
 收藏
 */
@property (nonatomic, copy) BeginFavoriteTheSceneBlock beginFavoriteTheSceneBlock;

/**
 取消收藏
 */
@property (nonatomic, copy) CancelFavoriteTheSceneBlock cancelFavoriteTheSceneBlock;

/**
 删除情境
 */
@property (nonatomic, copy) CancelFavoriteTheSceneBlock deleteTheSceneBlock;

/**
 刷新数据
 */
@property (nonatomic, copy) RefreshData refreshData;


@end
