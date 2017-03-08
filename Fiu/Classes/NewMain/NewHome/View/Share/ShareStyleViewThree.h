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

@property (nonatomic, strong) UIImageView *styleImage;    //  背景样式图
@property (nonatomic, strong) UIImageView *sceneImg;      //  场景图
@property (nonatomic, strong) UIView *userView;           //  用户视图
@property (nonatomic, strong) UIButton *userName;         //  用户昵称
@property (nonatomic, strong) UILabel *describe;          //  描述
@property (nonatomic, strong) UIButton *describeIcon;     //  描述尾部
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *suTitle;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *time;
@property (nonatomic, strong) UIButton *address;
@property (nonatomic, strong) UILabel *sendText;
@property (nonatomic, strong) NSMutableArray *tagDataMarr;

- (void)setShareSceneData:(HomeSceneListRow *)sceneModel;

@end
