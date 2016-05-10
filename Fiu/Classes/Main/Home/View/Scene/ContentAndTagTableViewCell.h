//
//  ContentAndTagTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"
#import "UIImage+Helper.h"
#import "SceneInfoData.h"
#import "FiuSceneInfoData.h"

@interface ContentAndTagTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@pro_strong UINavigationController      *   nav;
@pro_strong UILabel                     *   contentLab;     //  场景内容文字
@pro_assign CGFloat                         cellHeight;
@pro_strong UICollectionView            *   chooseTagView;  //  选择的标签列表
@pro_strong NSMutableArray              *   chooseTagMarr;

- (void)setFiuSceneDescription:(FiuSceneInfoData *)model;

- (void)setSceneDescription:(SceneInfoData *)model;

- (void)getContentCellHeight:(NSString *)content;

@end
