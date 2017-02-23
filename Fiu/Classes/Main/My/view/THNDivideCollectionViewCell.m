//
//  THNDivideCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/15.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDivideCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"

@interface THNDivideCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

static NSString *const URLAliance = @"/alliance/view";

@implementation THNDivideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bgImage"]];
        [self.contentView addSubview:self.bgImageV];
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_go"]];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-12);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.text = @"我的钱包";
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        }];
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:10];
        self.tipLabel.text = @"可提现金额";
        self.tipLabel.textColor = [UIColor colorWithHexString:@"#717171"];
        [self.contentView addSubview:self.tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_left).mas_offset(0);
            make.top.mas_equalTo(self.textLabel.mas_bottom).mas_offset(3);
        }];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.font = [UIFont systemFontOfSize:11];
        self.numberLabel.textColor = [UIColor colorWithHexString:fineixColor];
        [self.contentView addSubview:self.numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.imageV.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(self.imageV.mas_centerY).mas_offset(0);
        }];
        
        [self thn_networkAllinaceListData];
        
    }
    return self;
}

#pragma mark - 请求账户数据
- (void)thn_networkAllinaceListData {
    FBRequest *request = [FBAPI postWithUrlString:URLAliance requestDictionary:@{} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        self.numberLabel.text = [NSString stringWithFormat:@"%0.2f元",[dict[@"total_balance_amount"] floatValue]];
    } failure:^(FBRequest *request, NSError *error) {
    }];
}

@end
