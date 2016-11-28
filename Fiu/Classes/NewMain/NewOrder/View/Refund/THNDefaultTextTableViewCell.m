//
//  THNDefaultTextTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDefaultTextTableViewCell.h"

@interface THNDefaultTextTableViewCell () {
    NSArray *_explainArr;
}

@end

@implementation THNDefaultTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _explainArr = @[@"退款金额", @"退款原因", @"退款说明", @"退款编号", @"退款时间"];
        [self set_cellViewUI];
    }
    return self;
}


- (void)thn_setExplainText:(NSInteger)index data:(NSString *)data {
    data = [NSString stringWithFormat:@"%@", data];
    self.explain.text = _explainArr[index];
    self.dataLab.text = data;
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.explain];
    [_explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.dataLab];
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.left.equalTo(_explain.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:topLine];
}

- (UILabel *)explain {
    if (!_explain) {
        _explain = [[UILabel alloc] init];
        _explain.textColor = [UIColor colorWithHexString:@"#999999"];
        _explain.font = [UIFont systemFontOfSize:14];
    }
    return _explain;
}

- (UILabel *)dataLab {
    if (!_dataLab) {
        _dataLab = [[UILabel alloc] init];
        _dataLab.textColor = [UIColor colorWithHexString:@"#222222"];
        _dataLab.font = [UIFont systemFontOfSize:14];
    }
    return _dataLab;
}

@end
