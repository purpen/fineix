//
//  BonusCell.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/18.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "BonusCell.h"
#import "BonusModel.h"

@interface BonusCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UILabel *minimumLbl;
@property (weak, nonatomic) IBOutlet UILabel *overdueLbl;


@end

@implementation BonusCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBonus:(BonusModel *)bonus
{
    if (_bonus != bonus) {
        _bonus = bonus;
    }
    self.amountLbl.text = [NSString stringWithFormat:@"%.0f", [bonus.amount floatValue]];
    self.codeLbl.text = [NSString stringWithFormat:@"红包码:%@", bonus.code];
    if ([bonus.minAmount floatValue] == 0) {
        self.minimumLbl.text = [NSString stringWithFormat:@"无限制"];
    }else{
        self.minimumLbl.text = [NSString stringWithFormat:@"最低使用限额:%.0f", [bonus.minAmount floatValue]];
    }
    self.overdueLbl.text = bonus.expiredLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
