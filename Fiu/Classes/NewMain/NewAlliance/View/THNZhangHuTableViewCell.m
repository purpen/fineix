//
//  THNZhangHuTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhangHuTableViewCell.h"
#import "Fiu.h"

@interface THNZhangHuTableViewCell ()

/**  */
@property (nonatomic, strong) UILabel *nameLabel;
/**  */
@property (nonatomic, strong) UIImageView *tuBiao;
/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) UILabel *zhangHuLabel;

@end

@implementation THNZhangHuTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _tuBiao = [[UIImageView alloc] init];
        [self.contentView addSubview:_tuBiao];
        [_tuBiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.width.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#232323"];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(-10);
            make.left.mas_equalTo(self.tuBiao.mas_right).mas_offset(15);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.circleBtn.userInteractionEnabled = NO;
        [self.circleBtn setImage:[UIImage imageNamed:@"nonSelectedCircle"] forState:UIControlStateNormal];
        [self.circleBtn setImage:[UIImage imageNamed:@"selectedRight"] forState:UIControlStateSelected];
        [self.circleBtn addTarget:self action:@selector(circleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.circleBtn];
        [_circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        }];
        
        _zhangHuLabel = [[UILabel alloc] init];
        _zhangHuLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.contentView addSubview:_zhangHuLabel];
        _zhangHuLabel.font = [UIFont systemFontOfSize:13];
        [_zhangHuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(10);
            make.left.mas_equalTo(self.tuBiao.mas_right).mas_offset(15);
            make.width.mas_equalTo(SCREEN_WIDTH-110);
        }];
        
        self.label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor colorWithHexString:@"#a5a5a5"];
        _label.text = @"默认提现账户";
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(-5);
            make.right.mas_equalTo(self.circleBtn.mas_left).mas_offset(-10);
        }];
    }
    return self;
}

-(void)circleTap:(UIButton*)sender{
//    sender.selected = !sender.selected;
}

-(void)setModel:(THNZhangHuModel *)model{
    _model = model;
    if ([model.is_default isEqualToString:@"1"]) {
        self.label.hidden = NO;
        self.circleBtn.selected = YES;
    } else {
        self.label.hidden = YES;
        self.circleBtn.selected = NO;
    }
    if ([model.kind isEqualToString:@"2"]) {
        //支付宝
        self.nameLabel.text = @"支付宝";
        self.tuBiao.image = [UIImage imageNamed:@"alipayBig"];
        _zhangHuLabel.text = [NSString stringWithFormat:@"支付宝帐号（%@）",self.model.account];
    } else if ([model.kind isEqualToString:@"1"]) {
        //银行卡
        self.nameLabel.text = model.pay_type_label;
        self.tuBiao.image = [UIImage imageNamed:@"yinHangKaBig"];
        _zhangHuLabel.text = [NSString stringWithFormat:@"储蓄卡（尾号%@）",[self.model.account substringFromIndex:self.model.account.length-4]];
    } else{
        
    }
}

@end
