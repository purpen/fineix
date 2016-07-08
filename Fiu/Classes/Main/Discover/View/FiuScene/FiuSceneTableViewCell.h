//
//  FiuSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FiuSceneTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController      *   nav;
@pro_strong UIViewController            *   vc;
@pro_assign BOOL                            choose;
@pro_strong NSString                    *   type;
@pro_strong UICollectionView            *   sceneListView;  //  滑动情景列表

- (void)setFiuSceneList:(NSMutableArray *)dataMarr idMarr:(NSMutableArray *)idMarr;

@end
