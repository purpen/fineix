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

@interface THNDataInfoTableViewCell : UITableViewCell

@pro_strong UIViewController *vc;
@pro_strong UINavigationController *nav;
@pro_strong UIButton *look;
@pro_strong UIButton *like;
@pro_strong UIButton *comments;
@pro_strong UIButton *share;
@pro_strong UIButton *more;

/**
 * type
 * 1:首页情境 ／ 2:情境展开列表 / 3:个人中心
 */
- (void)thn_setSceneData:(HomeSceneListRow *)dataModel type:(NSInteger)type;

@end
