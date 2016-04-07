//
//  OrderInfoCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OrderInfoCell.h"


@implementation OrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)getOrderInfoCell{
    OrderInfoCell *orderInfoCell = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoCell" owner:nil options:nil][0];
    
    return orderInfoCell;
}



+(NSString *)getIdentifer{
    return @"OrderInfoCell";
}

@end
