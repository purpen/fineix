//
//  CategoryMenuCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryMenuCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"

@implementation CategoryMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellUI];
    }
    return self;
}

- (void)setCategoryData:(CategoryRow *)model withType:(NSInteger)type {
    self.categoryLab.text = model.title;
    if (type == 1) {
       [self.categoryImg downloadImage:model.appCoverUrl place:[UIImage imageNamed:@""]];
        self.botLine.hidden = NO;
    } else if (type == 2) {
        [self.categoryImg downloadImage:model.backUrl place:[UIImage imageNamed:@""]];
        self.botLine.hidden = YES;
        self.categoryLab.font = [UIFont systemFontOfSize:7];
        [self.categoryLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 10));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
    }
}

- (void)setCellUI {
    [self addSubview:self.categoryImg];
    [_categoryImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self addSubview:self.categoryLab];
    [_categoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 10));
        make.centerY.equalTo(self);
        make.left.equalTo(_categoryImg.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 1));
        make.centerX.equalTo(self);
        make.top.equalTo(_categoryLab.mas_bottom).with.offset(2);
    }];
}

- (UIImageView *)categoryImg {
    if (!_categoryImg) {
        _categoryImg = [[UIImageView alloc] init];
        _categoryImg.contentMode = UIViewContentModeScaleAspectFit;
        _categoryImg.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _categoryImg.layer.cornerRadius = 40/2;
        _categoryImg.layer.masksToBounds = YES;
    }
    return _categoryImg;
}

- (UILabel *)categoryLab {
    if (!_categoryLab) {
        _categoryLab = [[UILabel alloc] init];
        _categoryLab.textAlignment = NSTextAlignmentCenter;
        _categoryLab.font = [UIFont systemFontOfSize:10];
        _categoryLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _categoryLab;
}

- (UILabel *)botLine {
    if (!_botLine) {
        _botLine = [[UILabel alloc] init];
        _botLine.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _botLine;
}

@end
