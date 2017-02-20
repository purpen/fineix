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
#import <SDWebImage/UIImageView+WebCache.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"
#import "UserGoodsTag.h"

@interface THNSceneImageTableViewCell : UITableViewCell

@pro_strong UIViewController *vc;
@pro_strong UINavigationController *nav;
@pro_strong UIImageView *sceneImage;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong NSMutableArray *tagDataMarr;
@pro_strong NSMutableArray *userTagMarr;
@pro_strong NSMutableArray *goodsIds;
@pro_strong NSMutableArray *goodsType;

- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel;


/**
 图片加载显示动画

 @param show 是否加载动画
 */
- (void)thn_showLoadImageAnimate:(BOOL)show;

@end
