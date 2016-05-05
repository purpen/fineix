//
//  BonusCell.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/18.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BonusModel;
@interface BonusCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (nonatomic, strong) BonusModel * bonus;

@end
