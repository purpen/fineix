//
//  THNDomainInfoSetViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"

typedef NS_ENUM(NSInteger , SaveEditType) {
    SaveEditTypeHeaderImage = 1,    // 头像
    SaveEditTypeLocation,           // 地理位置
};

@interface THNDomainInfoSetViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, strong) THNDomainManageInfoData *infoData;
@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) FBRequest *infoRequest;
@property (nonatomic, strong) FBRequest *domainEditRequest;

@end
