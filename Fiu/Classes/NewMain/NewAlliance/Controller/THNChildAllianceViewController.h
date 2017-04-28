//
//  THNChildAllianceViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNChildHeaderView.h"
#import "THNChildUserModel.h"

@interface THNChildAllianceViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FBRequest             *childUserRquest;
@property (nonatomic, strong) FBRequest             *deleteUserRquest;
@property (nonatomic, strong) NSMutableArray        *childDataArr;
@property (nonatomic, strong) NSMutableArray        *childIdArr;
@property (nonatomic, strong) NSMutableArray        *deleteIdArr;
@property (nonatomic, strong) UITableView           *childTable;
@property (nonatomic, strong) THNChildHeaderView    *childHeaderView;

@end
