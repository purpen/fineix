//
//  THNCuXiaoDetalContentTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THNProductModel;

@interface THNCuXiaoDetalContentTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) THNProductModel *model;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**  */
@property (nonatomic, strong) UINavigationController *navi;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;

@end
