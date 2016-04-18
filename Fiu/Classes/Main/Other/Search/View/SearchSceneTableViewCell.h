//
//  SearchSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllSceneView.h"
#import "Fiu.h"

@interface SearchSceneTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController  *   nav;
@pro_strong UICollectionView        *   allSceneView;   //  全部的情景

@end
