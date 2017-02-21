//
//  THNDomainInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainInfoHeaderImage.h"
#import "DominInfoData.h"
#import "THNDomainInfoFooter.h"

@interface THNDomainInfoViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    THNNavigationBarItemsDelegate
>

@property (nonatomic, strong) THNDomainInfoHeaderImage *headerImages;
@property (nonatomic, strong) FBRequest *infoRequest;
@property (nonatomic, strong) DominInfoData *infoModel;
@property (nonatomic, strong) NSString *infoId;
@property (nonatomic, strong) UITableView *domainInfoTable;
@property (nonatomic, strong) THNDomainInfoFooter *footerView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) FBRequest *favoriteRequest;

@end
