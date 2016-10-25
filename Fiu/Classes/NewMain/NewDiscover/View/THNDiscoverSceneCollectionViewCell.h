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
#import <SDWebImage/UIImageView+WebCache.h>

@class THNSenceModel;

typedef void(^BeginLikeTheSceneBlock)(NSString *idx);
typedef void(^CancelLikeTheSceneBlock)(NSString *idx);

@interface THNDiscoverSceneCollectionViewCell : UICollectionViewCell

@pro_strong UIViewController *vc;
@pro_strong UIImageView *sceneImageView;
@pro_strong UIView *userInfo;
@pro_strong UIImageView *userHeader;
@pro_strong UILabel *userName;
@pro_strong UIButton *likeBtn;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;

/**
 *  点赞
 */
@pro_copy BeginLikeTheSceneBlock beginLikeTheSceneBlock;

/**
 *  取消点赞
 */
@pro_copy CancelLikeTheSceneBlock cancelLikeTheSceneBlock;

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)model isLogin:(BOOL)login;

@end
