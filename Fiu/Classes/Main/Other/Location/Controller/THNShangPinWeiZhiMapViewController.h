//
//  THNShangPinWeiZhiMapViewController.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@class DominInfoData;

@interface THNShangPinWeiZhiMapViewController : THNViewController

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
/**  */
@property (nonatomic, strong) DominInfoData *model;

@end
