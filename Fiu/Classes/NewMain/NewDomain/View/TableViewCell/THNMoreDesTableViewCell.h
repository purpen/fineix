//
//  THNMoreDesTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "DominInfoData.h"

@interface THNMoreDesTableViewCell : UITableViewCell

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) DominInfoData *infoModel;

@end
