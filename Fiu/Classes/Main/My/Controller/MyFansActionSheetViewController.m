//
//  MyFansActionSheetViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyFansActionSheetViewController.h"
#import "Fiu.h"

@interface MyFansActionSheetViewController ()

@end

@implementation MyFansActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    [self.view addSubview:self.alertView];
}

-(void)setUI{
    self.headImageView.image = [UIImage imageNamed:@"user"];
    self.sheetLabel.text = @"停止关注 swimmme?";
}

-(UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 978*0.5/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 356*0.5/667.0*SCREEN_HEIGHT)];
        _alertView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        _alertView.userInteractionEnabled = YES;
        
        
        [_alertView addSubview:self.firstView];
        [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 90/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_alertView.mas_top).with.offset(0);
            make.left.mas_equalTo(_alertView.mas_left).with.offset(0);
        }];
        
                UIView *linview = [[UIView alloc] init];
                linview.backgroundColor = [UIColor lightGrayColor];
                [_firstView addSubview:linview];
                [linview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
                    make.left.mas_equalTo(_firstView.mas_left).with.offset(0);
                    make.bottom.mas_equalTo(_firstView.mas_bottom).with.offset(0);
                }];
        
        [_alertView addSubview:self.stopBtn];
        [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_firstView.mas_bottom).with.offset(0);
            make.left.mas_equalTo(_alertView.mas_left).with.offset(0);
        }];
        
                UIView *linview2 = [[UIView alloc] init];
                linview2.backgroundColor = [UIColor lightGrayColor];
                [_firstView addSubview:linview2];
                [linview2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
                    make.left.mas_equalTo(_stopBtn.mas_left).with.offset(0);
                    make.bottom.mas_equalTo(_stopBtn.mas_bottom).with.offset(0);
                }];
        
        [_alertView addSubview:self.cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_stopBtn.mas_bottom).with.offset(0);
            make.left.mas_equalTo(_alertView.mas_left).with.offset(0);
        }];
        
    }
    return _alertView;
}

-(UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        
        
        [_firstView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32/667.0*SCREEN_HEIGHT, 32/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(_firstView.mas_centerX);
            make.top.mas_equalTo(_headImageView.mas_top).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [_firstView addSubview:self.sheetLabel];
        [_sheetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_firstView.mas_left).with.offset(10);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(10/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_firstView.mas_right).with.offset(-10/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_firstView.mas_bottom).with.offset(-18/667.0*SCREEN_HEIGHT);
        }];
    }
    return _firstView;
}

-(UIButton *)stopBtn{
    if (!_stopBtn) {
        _stopBtn = [[UIButton alloc] init];
        

        
        [_stopBtn setTitle:@"停止关注" forState:UIControlStateNormal];
        [_stopBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateNormal];
    }
    return _stopBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 16/667.0*SCREEN_HEIGHT;
    }
    return _headImageView;
}

-(UILabel *)sheetLabel{
    if (!_sheetLabel) {
        _sheetLabel = [[UILabel alloc] init];
        _sheetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sheetLabel;
}

-(void)initFBAlertVc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
