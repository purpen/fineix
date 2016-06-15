//
//  FBSceneInfoScrollView.h
//  Fiu
//
//  Created by FLYang on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UserGoodsTag.h"
#import "SceneInfoData.h"

@interface FBSceneInfoScrollView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@pro_strong UINavigationController  *   nav;
@pro_strong NSMutableArray          *   tagDataMarr;
@pro_strong NSMutableArray          *   userTagMarr;
@pro_strong NSMutableArray          *   showUserTagMarr;
@pro_strong NSMutableArray          *   goodsIds;
@pro_strong UIButton                *   showGoodsTagsView;

@pro_strong UIImage                 *   backgroundImage;
@pro_strong UIImage                 *   blurredBackgroundImage;
@pro_assign CGFloat                     viewDistanceFromBottom;
@pro_strong UITableView             *   foregroundView;
@pro_strong_readonly UIScrollView   *   foregroundScrollView;
@pro_strong UIButton                *   leftBtn;
@pro_strong UIButton                *   rightBtn;
@pro_strong UIImageView             *   logoImg;

- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UITableView *)foregroundView;

- (void)setSceneInfoData:(SceneInfoData *)model;

@end
