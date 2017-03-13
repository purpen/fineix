//
//  THNDiPanGuanLiCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDiPanGuanLiCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"

@interface THNDiPanGuanLiCollectionViewCell ()

@end

@implementation THNDiPanGuanLiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bgImage"]];
        [self.contentView addSubview:self.bgImageV];
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.text = @"地盘管理";
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
        }];
        
        self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_go"]];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
        }];
        
    }
    return self;
}


@end
