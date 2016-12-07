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

- (void)thn_setViewTapAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLogisticsInfoVC:)];
    [self addGestureRecognizer:tap];
}

- (void)openLogisticsInfoVC:(UITapGestureRecognizer *)tap {
    THNLogisticsInfoViewController *logisticsInfoVC = [[THNLogisticsInfoViewController alloc] init];
    logisticsInfoVC.rid = _rid;
    logisticsInfoVC.expressCaty = _expressCaty;
    logisticsInfoVC.expressNo = _expressNo;
    logisticsInfoVC.expressCom = _expressCom;
    [self.nav pushViewController:logisticsInfoVC animated:YES];
}

- (void)thn_setOrederExpressData:(OrderInfoModel *)model {
    if (model.expressNo.length == 0) {
        self.expressCompany.hidden = YES;
        self.expressNum.hidden = YES;
        self.noExpressInfo.hidden = NO;
        
    } else {
        [self thn_setViewTapAction];
        
        self.expressCompany.text = [NSString stringWithFormat:@"承运来源：%@", model.express_company];
        self.expressNum.text = [NSString stringWithFormat:@"快递编号：%@", model.expressNo];
        _rid = model.rid;
        _expressNo = model.expressNo;
        _expressCaty = model.expressCaty;
        _expressCom = model.express_company;
    }
}

- (void)thn_setSubOrederExpressData:(SubOrderModel *)model withRid:(NSString *)rid {
    if (model.expressNo.length == 0) {
        self.expressCompany.hidden = YES;
        self.expressNum.hidden = YES;
        self.noExpressInfo.hidden = NO;
        
    } else {
        [self thn_setViewTapAction];
        
        self.expressCompany.text = [NSString stringWithFormat:@"承运来源：%@", model.expressCompany];
        self.expressNum.text = [NSString stringWithFormat:@"快递编号：%@", model.expressNo];
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
        make.size.mas_equalTo(CGSizeMake(130, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.expressNum];
    [_expressNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.noExpressInfo];
    [_noExpressInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self).with.offset(0);
    }];
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
