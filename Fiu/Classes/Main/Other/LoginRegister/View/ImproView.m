//
//  ImproView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImproView.h"
#import "Fiu.h"

@implementation ImproView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(210*0.5/667.0*SCREEN_HEIGHT, 210*0.5/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(self.mas_top).with.offset(271*0.5/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.cameraImageView];
        [_cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(52*0.5/667.0*SCREEN_HEIGHT, 52*0.5/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.mas_right).with.offset(142/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(429*0.5/667.0*SCREEN_HEIGHT);
        }];
        
        [self addSubview:self.chanelImageView];
        [_chanelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(222/667.0*SCREEN_HEIGHT, 93*0.5/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(67*0.5/667.0*SCREEN_HEIGHT);
        }];
        
        [self addSubview:self.nickNameTF];
        [_nickNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(546*0.5/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_chanelImageView.mas_bottom).with.offset(35*0.5/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.sumTF];
        [_sumTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(546*0.5/667.0*SCREEN_HEIGHT, 44/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_nickNameTF.mas_bottom).with.offset(35*0.5/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return self;
}

-(UITextField *)sumTF{
    if (!_sumTF) {
        _sumTF = [[UITextField alloc] init];
        _sumTF.placeholder = @"昵称";
        _sumTF.textAlignment = NSTextAlignmentCenter;
        _sumTF.borderStyle = UITextBorderStyleRoundedRect;
        _sumTF.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    return _sumTF;
}

-(UITextField *)nickNameTF{
    if (!_nickNameTF) {
        _nickNameTF = [[UITextField alloc] init];
        _nickNameTF.placeholder = @"昵称";
        _nickNameTF.textAlignment = NSTextAlignmentCenter;
        _nickNameTF.borderStyle = UITextBorderStyleRoundedRect;
        _nickNameTF.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    return _nickNameTF;
}

-(UIImageView *)chanelImageView{
    if (!_chanelImageView) {
        _chanelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
        
        [_chanelImageView addSubview:self.manBtn];
        [_manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_chanelImageView.frame.size.width/3.0, _chanelImageView.frame.size.height));
            make.left.mas_equalTo(_chanelImageView.mas_left).with.offset(0);
            make.top.mas_equalTo(_chanelImageView.mas_top).with.offset(0);
        }];
        
        [_chanelImageView addSubview:self.womanBtn];
        [_womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_chanelImageView.frame.size.width/3.0, _chanelImageView.frame.size.height));
            make.left.mas_equalTo(_manBtn.mas_left).with.offset(0);
            make.top.mas_equalTo(_chanelImageView.mas_top).with.offset(0);
        }];
        
        [_chanelImageView addSubview:self.secretBtn];
        [_secretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_chanelImageView.frame.size.width/3.0, _chanelImageView.frame.size.height));
            make.left.mas_equalTo(_womanBtn.mas_left).with.offset(0);
            make.top.mas_equalTo(_chanelImageView.mas_top).with.offset(0);
        }];
    }
    return _chanelImageView;
}

-(UIButton *)secretBtn{
    if (!_secretBtn) {
        _secretBtn = [[UIButton alloc] init];
        if (_secretBtn.selected) {
            [_secretBtn setBackgroundColor:[UIColor colorWithHexString:fineixColor]];
        }else{
            [_secretBtn setBackgroundColor:[UIColor whiteColor]];
        }
        [_secretBtn setTitle:@"保密" forState:UIControlStateNormal];
        [_secretBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_secretBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _womanBtn;
}

-(UIButton *)womanBtn{
    if (!_womanBtn) {
        _womanBtn = [[UIButton alloc] init];
        if (_womanBtn.selected) {
            [_womanBtn setBackgroundColor:[UIColor colorWithHexString:fineixColor]];
        }else{
            [_womanBtn setBackgroundColor:[UIColor whiteColor]];
        }
        [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
        [_womanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_womanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _womanBtn;
}

-(UIButton *)manBtn{
    if (!_manBtn) {
        _manBtn = [[UIButton alloc] init];
        if (_manBtn.selected) {
            [_manBtn setBackgroundColor:[UIColor colorWithHexString:fineixColor]];
        }else{
            [_manBtn setBackgroundColor:[UIColor whiteColor]];
        }
        [_manBtn setTitle:@"男" forState:UIControlStateNormal];
        [_manBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_manBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _manBtn;
}

-(UIImageView *)cameraImageView{
    if (!_cameraImageView) {
        _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_camera"]];
    }
    return _cameraImageView;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 105*0.5/667.0*SCREEN_HEIGHT;
        
    }
    return _headImageView;
}

@end
