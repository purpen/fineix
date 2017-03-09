//
//  THNDomainInfoSetViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"

@interface THNDomainInfoSetViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) THNDomainManageInfoData *infoData;
@property (nonatomic, strong) UITableView *infoTableView;

@end
