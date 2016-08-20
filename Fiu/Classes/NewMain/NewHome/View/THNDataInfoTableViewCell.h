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

typedef void(^LikeTheSceneBlock)(NSString *idx);
typedef void(^CancelLikeTheSceneBlock)(NSString *idx);

@interface THNDataInfoTableViewCell : UITableViewCell

@pro_strong UINavigationController *nav;
@pro_strong UIButton *look;
@pro_strong UIButton *like;
@pro_strong UIButton *comments;
@pro_strong UIButton *share;
@pro_strong UIButton *more;
@pro_copy LikeTheSceneBlock likeTheSceneBlock;
@pro_copy CancelLikeTheSceneBlock cancelLikeTheSceneBlock;

- (void)thn_setSceneData:(HomeSceneListRow *)dataModel;

@end
