//
//  THNActiveDetalTwoViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class THNArticleModel;

@interface THNActiveDetalTwoViewController : FBViewController

/**  */
@property (nonatomic, strong) THNArticleModel *model;
@property(nonatomic,strong) NSNumber *type;
/**  */
@property(nonatomic,copy) NSString *activeDetalId;

@end
