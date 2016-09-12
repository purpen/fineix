//
//  MyOderInfoViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class CounterModel;

@interface MyOderInfoViewController : FBViewController

@property(nonatomic,strong) NSNumber *type;
@property(nonatomic,strong) CounterModel *counterModel;

@end
