//
//  THNCuXiaoDetalViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNCuXiaoDetalViewController : THNViewController

/**  */
@property(nonatomic,copy) NSString *cuXiaoDetalId;
/**
 1,促销详情  
 2,好货详情
 */
@property (nonatomic, assign) NSInteger vcType;

@end
