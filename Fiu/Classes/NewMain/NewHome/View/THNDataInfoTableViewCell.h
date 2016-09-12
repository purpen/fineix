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

@interface THNDataInfoTableViewCell : UITableViewCell

@pro_strong UIViewController *vc;
@pro_strong UINavigationController *nav;
@pro_strong UIButton *look;
@pro_strong UIButton *like;
@pro_strong UIButton *comments;
@pro_strong UIButton *share;
@pro_strong UIButton *more;

- (void)thn_setSceneData:(HomeSceneListRow *)dataModel isLogin:(BOOL)login;

/**
 *  点赞
 */
@pro_copy BeginLikeTheSceneBlock beginLikeTheSceneBlock;

/**
 *  取消点赞
 */
@pro_copy CancelLikeTheSceneBlock cancelLikeTheSceneBlock;

/**
 *  收藏
 */
@pro_copy BeginFavoriteTheSceneBlock beginFavoriteTheSceneBlock;

/**
 *  取消收藏
 */
@pro_copy CancelFavoriteTheSceneBlock cancelFavoriteTheSceneBlock;


@end
