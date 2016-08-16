//
//  MarkGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkGoodsCollectionViewCell.h"

@implementation MarkGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        
    }
    return self;
}

#pragma mark -
- (void)setMarkGoodsData:(MarkGoodsRow *)model {
    [self.goodsImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    self.goodsNewPrice.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
    NSString * marketPrice = [NSString stringWithFormat:@"￥%.2f",model.marketPrice];
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:marketPrice];
    //  添加删除线
    [attributedStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,attributedStr.length)];
    self.goodsMarketPrice.attributedText = attributedStr;
//    self.likeNumLab.text = [NSString stringWithFormat:@"%zi",model.loveCount];
}

#pragma mark - 
- (void)setCellUI {
    [self addSubview:self.goodsImage];
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60)/2, (SCREEN_WIDTH - 60)/2));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImage.mas_left).with.offset(0);
        make.right.equalTo(_goodsImage.mas_right).with.offset(0);
        make.top.equalTo(_goodsImage.mas_bottom).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.goodsNewPrice];
    [_goodsNewPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    [self addSubview:self.goodsMarketPrice];
    [_goodsMarketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsNewPrice.mas_right).with.offset(1);
        make.bottom.equalTo(_goodsNewPrice.mas_bottom).with.offset(-2);
    }];

//    [self addSubview:self.likeNumLab];
//    [_likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_goodsNewPrice);
//        make.right.equalTo(self.mas_right).with.offset(-10);
//    }];
//    
//    [self addSubview:self.likeIcon];
//    [_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(10,9));
//        make.centerY.equalTo(_likeNumLab);
//        make.right.equalTo(_likeNumLab.mas_left).with.offset(-3);
//    }];
    
    [self addSubview:self.lineLab];
    [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-30)/2-20,.5));
        make.bottom.equalTo(_goodsNewPrice.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)goodsImage {
    if (!_goodsImage) {
        _goodsImage = [[UIImageView alloc] init];
        _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImage.clipsToBounds  = YES;
        [_goodsImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _goodsImage;
}

- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        if (IS_iOS9) {
            _goodsTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _goodsTitle.font = [UIFont systemFontOfSize:12];
        }
        _goodsTitle.numberOfLines = 2;
        _goodsTitle.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsTitle;
}

- (UILabel *)lineLab {
    if (!_lineLab) {
        _lineLab = [[UILabel alloc] init];
        _lineLab.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"];
    }
    return _lineLab;
}

- (UILabel *)goodsNewPrice {
    if (!_goodsNewPrice) {
        _goodsNewPrice = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsNewPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _goodsNewPrice.font = [UIFont systemFontOfSize:12];
        }
        _goodsNewPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsNewPrice.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsNewPrice;
}

- (UILabel *)goodsMarketPrice {
    if (!_goodsMarketPrice) {
        _goodsMarketPrice = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsMarketPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _goodsMarketPrice.font = [UIFont systemFontOfSize:9];
        }
        _goodsMarketPrice.textColor = [UIColor grayColor];
        _goodsMarketPrice.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsMarketPrice;
}

- (UILabel *)likeNumLab {
    if (!_likeNumLab) {
        _likeNumLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _likeNumLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _likeNumLab.font = [UIFont systemFontOfSize:9];
        }
        _likeNumLab.textColor = [UIColor grayColor];
        _likeNumLab.textAlignment = NSTextAlignmentLeft;
    }
    return _likeNumLab;
}

- (UIImageView *)likeIcon {
    if (!_likeIcon) {
        _likeIcon = [[UIImageView alloc] init];
        _likeIcon.image = [UIImage imageNamed:@"likeNum"];
    }
    return _likeIcon;
}

@end
