//
//  THNWriteLightViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"

@interface THNWriteLightViewController : THNViewController

@property (nonatomic, strong) THNDomainManageInfoData *infoData;

/**
 设置默认亮点内容
 */
- (void)thn_setBrightSpotData:(NSArray *)model;
@property (nonatomic, strong) NSMutableArray *textMarr;
@property (nonatomic, strong) NSMutableArray *imageMarr;
@property (nonatomic, strong) NSMutableArray *imageIndexMarr;

@end
