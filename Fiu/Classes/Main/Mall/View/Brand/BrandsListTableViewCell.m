//
//  BrandsListTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BrandsListTableViewCell.h"

@implementation BrandsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

- (void)setBrandListData:(BrandListModel *)model {
    [self.brandImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.brandName.text = model.title;
}

#pragma mark - 
- (void)setCellUI {
    [self addSubview:self.brandImg];
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.brandName];
    [_brandName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.centerY.equalTo(_brandImg);
        make.left.equalTo(_brandImg.mas_right).with.offset(15);
    }];
}

#pragma mark - 品牌头像
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] init];
        _brandImg.layer.borderColor = [UIColor colorWithHexString:@"#666666" alpha:.5].CGColor;
        _brandImg.layer.borderWidth = 0.5f;
        _brandImg.layer.masksToBounds = YES;
        _brandImg.layer.cornerRadius = 25;
        _brandImg.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE" alpha:.5];
    }
    return _brandImg;
}

#pragma mark - 品牌名称
- (UILabel *)brandName {
    if (!_brandName) {
        _brandName = [[UILabel alloc] init];
        if (IS_iOS9) {
            _brandName.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _brandName.font = [UIFont systemFontOfSize:14];
        }
        _brandName.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
    }
    return _brandName;
}


@end
