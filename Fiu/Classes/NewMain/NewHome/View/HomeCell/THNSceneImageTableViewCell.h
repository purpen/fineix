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

typedef NS_ENUM(NSInteger, ClickOpenType) {
    ClickOpenTypeSceneList = 1,
    ClickOpenTypeSceneInfo,
};

@interface THNSceneImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIImageView *sceneImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *suTitle;
@property (nonatomic, strong) NSMutableArray *tagDataMarr;
@property (nonatomic, strong) NSMutableArray *userTagMarr;
@property (nonatomic, strong) NSMutableArray *goodsIds;
@property (nonatomic, strong) NSMutableArray *goodsType;

- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel;


/**
 图片加载显示动画

 @param show 是否加载动画
 */
- (void)thn_showLoadImageAnimate:(BOOL)show;


/**
 点击图片打开的位置

 @param type 类型0:列表／1:详情
 */
- (void)thn_touchUpOpenControllerType:(ClickOpenType)type;

@end
