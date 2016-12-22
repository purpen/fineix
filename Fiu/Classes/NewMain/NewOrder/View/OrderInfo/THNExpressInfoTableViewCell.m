//
//  THNExpressInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNExpressInfoTableViewCell.h"
#import "THNLogisticsInfoViewController.h"

@interface THNExpressInfoTableViewCell () {
    NSString *_rid;
    NSString *_expressCaty;
    NSString *_expressNo;
    NSString *_expressCom;
}

@end

@implementation THNExpressInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setOrederExpressData:(OrderInfoModel *)model {
    if (model.expressNo.length == 0) {
        self.expressCompany.hidden = YES;
        self.lookExpress.hidden = YES;
        self.noExpressInfo.hidden = NO;
        
    } else {
        self.expressCompany.text = [NSString stringWithFormat:@"%@ (%@)", model.express_company, model.expressNo];
        _rid = model.rid;
        _expressNo = model.expressNo;
        _expressCaty = model.expressCaty;
        _expressCom = model.express_company;
    }
}

- (void)thn_setSubOrederExpressData:(SubOrderModel *)model withRid:(NSString *)rid {
    if (model.expressNo.length == 0) {
        self.expressCompany.hidden = YES;
        self.lookExpress.hidden = YES;
        self.noExpressInfo.hidden = NO;
        
    } else {
        self.expressCompany.text = [NSString stringWithFormat:@"%@ (%@)", model.expressCompany, model.expressNo];
        _rid = rid;
        _expressNo = model.expressNo;
        _expressCaty = model.expressCaty;
        _expressCom = model.expressCompany;
    }
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    [self addSubview:topLine];
    
    [self addSubview:self.expressCompany];
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-100);
        make.top.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.noExpressInfo];
    [_noExpressInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.lookExpress];
    [_lookExpress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UIButton *)lookExpress {
    if (!_lookExpress) {
        _lookExpress = [[UIButton alloc] init];
        _lookExpress.layer.borderWidth = 0.5f;
        _lookExpress.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
        _lookExpress.layer.cornerRadius = 2.0f;
        _lookExpress.layer.masksToBounds = YES;
        _lookExpress.titleLabel.font = [UIFont systemFontOfSize:13];
        [_lookExpress setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_lookExpress setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [_lookExpress addTarget:self action:@selector(lookExpressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookExpress;
}

- (void)lookExpressClick:(UIButton *)button {
    THNLogisticsInfoViewController *logisticsInfoVC = [[THNLogisticsInfoViewController alloc] init];
    logisticsInfoVC.rid = _rid;
    logisticsInfoVC.expressCaty = _expressCaty;
    logisticsInfoVC.expressNo = _expressNo;
    logisticsInfoVC.expressCom = _expressCom;
    [self.nav pushViewController:logisticsInfoVC animated:YES];
}

- (UILabel *)expressCompany {
    if (!_expressCompany) {
        _expressCompany = [[UILabel alloc] init];
        _expressCompany.font = [UIFont systemFontOfSize:12];
        _expressCompany.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _expressCompany;
}

- (UILabel *)expressNum {
    if (!_expressNum) {
        _expressNum = [[UILabel alloc] init];
        _expressNum.font = [UIFont systemFontOfSize:12];
        _expressNum.textColor = [UIColor colorWithHexString:@"#666666"];
        _expressNum.textAlignment = NSTextAlignmentRight;
    }
    return _expressNum;
}

- (UILabel *)noExpressInfo {
    if (!_noExpressInfo) {
        _noExpressInfo = [[UILabel alloc] init];
        _noExpressInfo.font = [UIFont systemFontOfSize:12];
        _noExpressInfo.textColor = [UIColor colorWithHexString:@"#999999"];
        _noExpressInfo.textAlignment = NSTextAlignmentCenter;
        _noExpressInfo.text = @"暂时没有物流信息";
        _noExpressInfo.hidden = YES;
    }
    return _noExpressInfo;
}

@end
