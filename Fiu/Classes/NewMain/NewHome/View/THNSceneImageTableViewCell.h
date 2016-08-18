//
//  THNSceneImageTableViewCell.h
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
#import "UserGoodsTag.h"

@interface THNSceneImageTableViewCell : UITableViewCell

@pro_strong UINavigationController *nav;
@pro_strong UIButton *sceneImage;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong NSMutableArray *tagDataMarr;
@pro_strong NSMutableArray *userTagMarr;
@pro_strong NSMutableArray *goodsIds;

- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel;

@end
