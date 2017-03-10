//
//  THNDomainSetViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"

@interface THNDomainSetViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>


/**
 编辑地盘时传递个人信息拥有地盘id
 */
@property (nonatomic, strong) NSString *domainId;
@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) FBRequest *infoRequest;
@property (nonatomic, strong) THNDomainManageInfoData *infoData;

@end
