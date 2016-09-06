//
//  THNActiveRuleCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNActiveRuleModel;

@interface THNActiveRuleCollectionViewCell : UICollectionViewCell

/**  */
@property (nonatomic, strong) THNActiveRuleModel *model;
@property (weak, nonatomic) IBOutlet UIButton *attendBtn;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@end
