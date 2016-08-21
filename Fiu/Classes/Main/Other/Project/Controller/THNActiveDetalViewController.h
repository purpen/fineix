//
//  THNActiveDetalViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class THNArticleModel;

@interface THNActiveDetalViewController : FBViewController

/**  */
@property(nonatomic,copy) NSString *id;
/**  */
@property (nonatomic, strong) THNArticleModel *model;

@end
