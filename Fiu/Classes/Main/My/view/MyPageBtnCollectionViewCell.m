//
//  MyPageBtnCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyPageBtnCollectionViewCell.h"
#import "Fiu.h"
#import "UIColor+Extension.h"
#import "AboutViewController.h"
#import "THNZhaoMuViewController.h"

@interface MyPageBtnCollectionViewCell()

@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation MyPageBtnCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        if (SCREEN_HEIGHT == 812) {
            self.screenHeight = 667;
        } else {
            self.screenHeight = SCREEN_HEIGHT;
        }
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        
        
        [self.contentView addSubview:self.btn1];
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.mas_left).with.offset(0/667.0*self.screenHeight);
            make.top.mas_equalTo(self.mas_top).with.offset(15/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn1.mas_centerX);
            make.top.mas_equalTo(self.btn1.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        [self.contentView addSubview:self.btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn1.mas_right).with.offset(0/667.0*self.screenHeight);
            make.top.mas_equalTo(self.mas_top).with.offset(15/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn2.mas_centerX);
            make.top.mas_equalTo(self.btn2.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        [self.contentView addSubview:self.btn3];
        [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn2.mas_right).with.offset(0/667.0*self.screenHeight);
            make.top.mas_equalTo(self.mas_top).with.offset(15/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn3.mas_centerX);
            make.top.mas_equalTo(self.btn3.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        
        [self.contentView addSubview:self.btn4];
        [_btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn3.mas_right).with.offset(0/667.0*self.screenHeight);
            make.top.mas_equalTo(self.mas_top).with.offset(15/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label4];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn4.mas_centerX);
            make.top.mas_equalTo(self.btn4.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        
        [self.contentView addSubview:self.btn6];
        [_btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.top.mas_equalTo(self.btn1.mas_bottom).with.offset(42/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label6];
        [_label6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn6.mas_centerX);
            make.top.mas_equalTo(self.btn6.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        [self.contentView addSubview:self.btn7];
        [_btn7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn6.mas_right).with.offset(0);
            make.top.mas_equalTo(self.btn2.mas_bottom).with.offset(42/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label7];
        [_label7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn7.mas_centerX);
            make.top.mas_equalTo(self.btn7.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        [self.contentView addSubview:self.btn8];
        [_btn8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn7.mas_right).with.offset(0);
            make.top.mas_equalTo(self.btn3.mas_bottom).with.offset(42/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label8];
        [_label8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn8.mas_centerX);
            make.top.mas_equalTo(self.btn8.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        [self.contentView addSubview:self.btn9];
        [_btn9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 40));
            make.left.mas_equalTo(self.btn8.mas_right).with.offset(0);
            make.top.mas_equalTo(self.btn4.mas_bottom).with.offset(42/667.0*self.screenHeight);
        }];
        [self.contentView addSubview:self.label9];
        [_label9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerX.mas_equalTo(self.btn9.mas_centerX);
            make.top.mas_equalTo(self.btn9.mas_bottom).with.offset(8/667.*self.screenHeight);
        }];
        
        self.zhaoMuTu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhaoMu"]];
        [self.contentView addSubview:self.zhaoMuTu];
        [_zhaoMuTu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.btn9.mas_bottom).with.offset(50/667.0*self.screenHeight);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(5/667.0*self.screenHeight);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5/667.0*self.screenHeight);
            make.height.mas_equalTo((SCREEN_WIDTH-10/667.0*self.screenHeight)*120/345);
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
                make.top.mas_equalTo(self.btn9.mas_bottom).with.offset(30);
            }
        }];
        self.zhaoMuTu.userInteractionEnabled = YES;
        [self.zhaoMuTu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZhaoMu)]];
    }
    return self;
}

-(void)tapZhaoMu{
    THNZhaoMuViewController *vc = [[THNZhaoMuViewController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}

-(UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setImage:[UIImage imageNamed:@"my_message"] forState:UIControlStateNormal];
    }
    return _btn1;
}
-(UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"消息";
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
        [_btn2 setImage:[UIImage imageNamed:@"my_dingYue"] forState:UIControlStateNormal];
    }
    return _btn2;
}
-(UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"订阅";
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
        [_btn3 setImage:[UIImage imageNamed:@"my_shouCang"] forState:UIControlStateNormal];
        
    }
    return _btn3;
}
-(UILabel *)label3{
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"收藏";
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
        [_btn4 setImage:[UIImage imageNamed:@"my_zan"] forState:UIControlStateNormal];
    }
    return _btn4;
}
-(UILabel *)label4{
    if (!_label4) {
        _label4 = [[UILabel alloc] init];
        _label4.text = @"赞过";
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


-(UIButton *)btn6{
    if (!_btn6) {
        _btn6 = [[UIButton alloc] init];
        [_btn6 setImage:[UIImage imageNamed:@"my_jiFen"] forState:UIControlStateNormal];
    }
    return _btn6;
}
-(UILabel *)label6{
    if (!_label6) {
        _label6 = [[UILabel alloc] init];
        _label6.text = @"积分";
        _label6.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label6.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label6.font = [UIFont systemFontOfSize:13];
        }
        _label6.textColor = [UIColor darkGrayColor];
    }
    return _label6;
}

-(UIButton *)btn7{
    if (!_btn7) {
        _btn7 = [[UIButton alloc] init];
        [_btn7 setImage:[UIImage imageNamed:@"my_liQuan"] forState:UIControlStateNormal];
    }
    return _btn7;
}
-(UILabel *)label7{
    if (!_label7) {
        _label7 = [[UILabel alloc] init];
        _label7.text = @"红包";
        _label7.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label7.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label7.font = [UIFont systemFontOfSize:13];
        }
        _label7.textColor = [UIColor darkGrayColor];
    }
    return _label7;
}

-(UIButton *)btn8{
    if (!_btn8) {
        _btn8 = [[UIButton alloc] init];
        [_btn8 setImage:[UIImage imageNamed:@"my_addrees"] forState:UIControlStateNormal];
    }
    return _btn8;
}
-(UILabel *)label8{
    if (!_label8) {
        _label8 = [[UILabel alloc] init];
        _label8.text = @"收货地址";
        _label8.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label8.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label8.font = [UIFont systemFontOfSize:13];
        }
        _label8.textColor = [UIColor darkGrayColor];
    }
    return _label8;
}

-(UIButton *)btn9{
    if (!_btn9) {
        _btn9 = [[UIButton alloc] init];
        [_btn9 setImage:[UIImage imageNamed:@"creat"] forState:UIControlStateNormal];
    }
    return _btn9;
}
-(UILabel *)label9{
    if (!_label9) {
        _label9 = [[UILabel alloc] init];
        _label9.text = @"创建情境";
        _label9.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _label9.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _label9.font = [UIFont systemFontOfSize:13];
        }
        _label9.textColor = [UIColor darkGrayColor];
    }
    return _label9;
}


@end
