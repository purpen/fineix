//
//  THNBusinessTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNBusinessTableViewCell.h"

@implementation THNBusinessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setBusinessData:(DominInfoData *)model {
//    [self set_BusinessStarCount:model.scoreAverage];
    [self.headerImage downloadImage:model.avatarUrl place:[UIImage imageNamed:@""]];
    self.name.text = model.title;
    self.subName.text = model.subTitle;
    if (model.tags.count) {
        [self set_BusinessTagsCount:model.tags];
    }
//    self.persoMoney.text = @"人均消费￥2500";
}

- (void)setCellViewUI {
    [self addSubview:self.headerImage];
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.equalTo(self.mas_top).with.offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 20));
        make.top.equalTo(_headerImage.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.subName];
    [_subName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 20));
        make.top.equalTo(_name.mas_bottom).with.offset(5);
        make.centerX.equalTo(self);
    }];
    
//    [self addSubview:self.persoMoney];
//    [_persoMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 20));
//        make.bottom.equalTo(self.mas_bottom).with.offset(0);
//        make.centerX.equalTo(self);
//    }];
}

- (void)set_BusinessTagsCount:(NSArray *)tags {
    UIView *tagsView = [[UIView alloc] init];
    tagsView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tagsView];
    [tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75 * tags.count, 25));
        make.top.equalTo(self.subName.mas_bottom).with.offset(8);
        make.centerX.equalTo(self);
    }];
    
    NSInteger count = tags.count;
    if (count > 4) {
        count = 4;
    }
    
    for (NSInteger idx = 0; idx < count; ++ idx) {
        UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(idx * 75, 0, 65, 25)];
        tagsLabel.text = tags[idx];
        tagsLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        tagsLabel.font = [UIFont systemFontOfSize:12];
        tagsLabel.textAlignment = NSTextAlignmentCenter;
        tagsLabel.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        tagsLabel.layer.borderWidth = 0.5;
        tagsLabel.layer.cornerRadius = 3;
        [tagsView addSubview:tagsLabel];
    }
}

- (void)set_BusinessStarCount:(NSInteger)count {
    UIView *starView = [[UIView alloc] init];
    [self addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13 * count, 10));
        make.top.equalTo(_name.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    for (NSInteger idx = 0; idx < count; ++ idx) {
        UIImageView *starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape_star"]];
        [starView addSubview:starImage];
        [starImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.equalTo(starView.mas_left).with.offset(13 * idx);
            make.centerY.equalTo(starView);
        }];
    }
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] init];
        _headerImage.layer.cornerRadius = 75/2;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.borderWidth = 0.5f;
        _headerImage.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _headerImage.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _headerImage;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:@"#222222"];
        _name.font = [UIFont systemFontOfSize:17];
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}

- (UILabel *)subName {
    if (!_subName) {
        _subName = [[UILabel alloc] init];
        _subName.textColor = [UIColor colorWithHexString:@"#666666"];
        _subName.font = [UIFont systemFontOfSize:12];
        _subName.textAlignment = NSTextAlignmentCenter;
    }
    return _subName;
}

- (UILabel *)persoMoney {
    if (!_persoMoney) {
        _persoMoney = [[UILabel alloc] init];
        _persoMoney.textColor = [UIColor colorWithHexString:@"#666666"];
        _persoMoney.font = [UIFont systemFontOfSize:12];
        _persoMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _persoMoney;
}

- (CGSize)getTextFrame:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)
                                         options:\
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading |
                       NSStringDrawingUsesDeviceMetrics
                                      attributes:attribute
                                         context:nil].size;
    return textSize;
}

@end
