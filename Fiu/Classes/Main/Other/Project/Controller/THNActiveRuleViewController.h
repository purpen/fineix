//
//  THNActiveRuleViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNArticleModel;

@interface THNActiveRuleViewController : UIViewController

/**  */
@property(nonatomic,copy) NSString *id;
/**  */
@property (nonatomic, strong) THNArticleModel *model;

@end
