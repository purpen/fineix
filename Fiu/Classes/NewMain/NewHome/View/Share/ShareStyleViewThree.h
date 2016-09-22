//
//  ShareStyleViewThree.h
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "HomeSceneListRow.h"
#import "UserGoodsTag.h"

@interface ShareStyleViewThree : UIView

@pro_strong UIImageView *styleImage;    //  背景样式图
@pro_strong UIImageView *sceneImg;      //  场景图
@pro_strong UIView *userView;           //  用户视图
@pro_strong UIButton *userName;         //  用户昵称
@pro_strong UILabel *describe;          //  描述
@pro_strong UIButton *describeIcon;     //  描述尾部
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UIView *timeView;
@pro_strong UIButton *time;
@pro_strong UIButton *address;
@pro_strong UILabel *sendText;
@pro_strong NSMutableArray *tagDataMarr;

- (void)setShareSceneData:(HomeSceneListRow *)sceneModel;

@end
