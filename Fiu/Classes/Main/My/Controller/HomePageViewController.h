//
//  HomePageViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"

@interface HomePageViewController : FBViewController

@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,assign) BOOL isMySelf;
@property (nonatomic,copy) NSString *userId;

@end
