//
//  FiltersView.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FiltersView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@pro_strong UICollectionView    *   filtersCollectionView;      //  滤镜菜单
@pro_strong NSArray             *   filtersTitle;               //  滤镜标题
@pro_strong NSArray             *   filters;                    //  滤镜

@end
