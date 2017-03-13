//
//  THNOrderCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/15.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNOrderCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "YLButton.h"

@interface THNOrderCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *bgImageV;
@property (nonatomic, strong) UIView *bootomLineV;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *lineImageV;
@property (nonatomic, strong) UIView *btnContentView;

@end

@implementation THNOrderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgImageV = [[UIView alloc] init];
        [self.contentView addSubview:self.bgImageV];
        self.bgImageV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.bootomLineV = [[UIView alloc] init];
        [self.contentView addSubview:self.bootomLineV];
        self.bootomLineV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_bootomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_go"]];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(18);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.text = @"我的订单";
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
            make.centerY.mas_equalTo(self.imageV.mas_centerY).mas_offset(0);
        }];
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:13];
        self.tipLabel.text = @"查看全部订单";
        [self.contentView addSubview:self.tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.imageV.mas_left).mas_offset(-8);
            make.centerY.mas_equalTo(self.imageV.mas_centerY).mas_offset(0);
        }];
        
        self.lineImageV = [[UIView alloc] init];
        [self.contentView addSubview:self.lineImageV];
        self.lineImageV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(44);
            make.height.mas_equalTo(0.5);
        }];
        
        self.btnContentView = [[UIView alloc] init];
        [self.contentView addSubview:self.btnContentView];
        [_btnContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(44);
        }];
        [self.btnContentView addSubview:self.btn1];
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.mas_left).with.offset(20/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.btnContentView.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
        }];
        [self.contentView addSubview:self.label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn1.mas_centerX);
            make.top.mas_equalTo(self.btn1.mas_bottom).with.offset(2/667.*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.btn1.mas_right).with.offset(20/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.btnContentView.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
        }];
        [self.contentView addSubview:self.label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn2.mas_centerX);
            make.top.mas_equalTo(self.btn2.mas_bottom).with.offset(2/667.*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.btn3];
        [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.btn2.mas_right).with.offset(20/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.btnContentView.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
        }];
        [self.contentView addSubview:self.label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn3.mas_centerX);
            make.top.mas_equalTo(self.btn3.mas_bottom).with.offset(2/667.*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.btn4];
        [_btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.btn3.mas_right).with.offset(20/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.btnContentView.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
        }];
        [self.contentView addSubview:self.label4];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn4.mas_centerX);
            make.top.mas_equalTo(self.btn4.mas_bottom).with.offset(2/667.*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.btn5];
        [_btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.btnContentView.mas_right).with.offset(-20/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.btnContentView.mas_top).with.offset(8/667.0*SCREEN_HEIGHT);
        }];
        [self.contentView addSubview:self.label5];
        [_label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn5.mas_centerX);
            make.top.mas_equalTo(self.btn5.mas_bottom).with.offset(2/667.*SCREEN_HEIGHT);
        }];
        
    }
    return self;
}

-(UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [[UIButton alloc] init];
        _btn1.tag = 1;
        [_btn1 setImage:[UIImage imageNamed:@"weifukuan"] forState:UIControlStateNormal];
    }
    return _btn1;
}
-(UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"未付款";
        _label1.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label1.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label1.font = [UIFont systemFontOfSize:13];
        }
        _label1.textColor = [UIColor darkGrayColor];
    }
    return _label1;
}

-(UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [[UIButton alloc] init];
        _btn2.tag = 2;
        [_btn2 setImage:[UIImage imageNamed:@"daifahuo"] forState:UIControlStateNormal];
    }
    return _btn2;
}
-(UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"待发货";
        _label2.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label2.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label2.font = [UIFont systemFontOfSize:13];
        }
        _label2.textColor = [UIColor darkGrayColor];
    }
    return _label2;
}

-(UIButton *)btn3{
    if (!_btn3) {
        _btn3 = [[UIButton alloc] init];
        _btn3.tag = 3;
        [_btn3 setImage:[UIImage imageNamed:@"daishouhuo"] forState:UIControlStateNormal];
        
    }
    return _btn3;
}
-(UILabel *)label3{
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"待收货";
        _label3.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label3.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label3.font = [UIFont systemFontOfSize:13];
        }
        _label3.textColor = [UIColor darkGrayColor];
    }
    return _label3;
}

-(UIButton *)btn4{
    if (!_btn4) {
        _btn4 = [[UIButton alloc] init];
        _btn4.tag = 4;
        [_btn4 setImage:[UIImage imageNamed:@"daipingjia"] forState:UIControlStateNormal];
    }
    return _btn4;
}
-(UILabel *)label4{
    if (!_label4) {
        _label4 = [[UILabel alloc] init];
        _label4.text = @"待评价";
        _label4.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label4.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label4.font = [UIFont systemFontOfSize:13];
        }
        _label4.textColor = [UIColor darkGrayColor];
    }
    return _label4;
}


-(UIButton *)btn5{
    if (!_btn5) {
        _btn5 = [[UIButton alloc] init];
        _btn5.tag = 5;
        [_btn5 setImage:[UIImage imageNamed:@"tuikuanshouhou"] forState:UIControlStateNormal];
    }
    return _btn5;
}
-(UILabel *)label5{
    if (!_label5) {
        _label5 = [[UILabel alloc] init];
        _label5.text = @"退款售后";
        _label5.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label5.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label5.font = [UIFont systemFontOfSize:13];
        }
        _label5.textColor = [UIColor darkGrayColor];
    }
    return _label5;
}


@end
