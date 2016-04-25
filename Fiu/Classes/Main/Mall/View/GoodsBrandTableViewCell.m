//
//  GoodsBrandTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsBrandTableViewCell.h"

@implementation GoodsBrandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellViewUI];
        
    }
    return self;
}

- (void)setUI {
    self.brandBgImg.image = [UIImage imageNamed:@"banner2"];
    self.brandImg.image = [UIImage imageNamed:@"asdfsd"];
    [self changeContentLabStyle:self.brandIntroduce withText:@"Being the savage's bowsman, that is, the person who pulled the bow-oar in his boat (the second one from forward), it was my cheerful duty to attend upon him while taking that hard-scrabble scramble upon the dead whale's back. You have seen Italian organ-boys holding a dancing-ape by a long cord."];
}

//  内容文字的样式
- (void)changeContentLabStyle:(UILabel *)lable withText:(NSString *)str {
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    lable.attributedText = contentText;
    
    CGSize size = [lable boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    
    [lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width , size.height + 20));
    }];
}

#pragma mark - 获取高度
//  计算内容高度
- (void)getContentCellHeight:(NSString *)content {
    self.brandIntroduce.text = content;
    CGSize size = [self.brandIntroduce boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    self.cellHeight = size.height + 270;
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.brandBgImg];
    [_brandBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , 210));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.brandImg];
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.bottom.equalTo(self.brandBgImg.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
    }];

    [self addSubview:self.brandIntroduce];
    [_brandIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 100));
        make.top.equalTo(self.brandBgImg.mas_bottom).with.offset(25);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
}

#pragma mark - 品牌背景
- (UIImageView *)brandBgImg {
    if (!_brandBgImg) {
        _brandBgImg = [[UIImageView alloc] init];
    }
    return _brandBgImg;
}

#pragma mark - 品牌头像
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] init];
    }
    return _brandImg;
}

#pragma mark - 品牌介绍
- (UILabel *)brandIntroduce {
    if (!_brandIntroduce) {
        _brandIntroduce = [[UILabel alloc] init];
        _brandIntroduce.textColor = [UIColor colorWithHexString:@"#222222"];
        _brandIntroduce.font = [UIFont systemFontOfSize:Font_Tag];
        _brandIntroduce.numberOfLines = 0;
    }
    return _brandIntroduce;
}


@end
