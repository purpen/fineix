//
//  MyHomePageScenarioViewController.h
//  Fiu
//
//  Created by dys on 16/4/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"

@interface MyHomePageScenarioViewController : FBViewController

@property (nonatomic,strong) NSNumber *type;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isMySelf;

@end
