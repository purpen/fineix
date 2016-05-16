//
//  InfoUseSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "GoodsInfoData.h"

@interface InfoUseSceneTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@pro_strong UINavigationController  *   nav;
@pro_strong UILabel             *   headerTitle;        //  标题
@pro_strong UILabel             *   line;               //  分割线
//@pro_strong UIScrollView        *   useSceneRollView;   //  应用的场景
@pro_strong UICollectionView    *   useSceneRollView;
@pro_strong NSMutableArray      *   sceneIds;
@pro_strong NSMutableArray      *   sceneList;

- (void)setGoodsScene:(NSMutableArray *)scene;

@end
