//
//  InvalidBonusCell.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/21.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "InvalidBonusCell.h"

#import "BonusModel.h"

@interface InvalidBonusCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UILabel *minimumLbl;
@property (weak, nonatomic) IBOutlet UILabel *overdueLbl;

@end

@implementation InvalidBonusCell

- (void)setBonus:(BonusModel *)bonus
{
    if (_bonus != bonus) {
        _bonus = bonus;
    }
    self.amountLbl.text = [NSString stringWithFormat:@"%.2f", [bonus.amount floatValue]];
    self.codeLbl.text = [NSString stringWithFormat:@"红包码:%@", bonus.code];;
    self.minimumLbl.text = [NSString stringWithFormat:@"最低使用限额:%.2f", [bonus.minAmount floatValue]];
    self.overdueLbl.text = bonus.expiredLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
