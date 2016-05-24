//
//  InfoGoodsHighlightsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoGoodsHighlightsTableViewCell.h"

@implementation InfoGoodsHighlightsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellViewUI];
        
    }
    return self;
}

- (void)setGoodsInfoData:(GoodsInfoData *)model {
    [self changeContentLabStyle:self.describe withText:[NSString stringWithFormat:@"%@", model.descriptionField]];
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.goodsDescribe];
    [_goodsDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,15));
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.describe];
    [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        make.top.equalTo(self.goodsDescribe.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
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
- (void)getContentCellHeight:(NSString *)content {
    self.describe.text = content;
    CGSize size = [self.describe boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    self.cellHeight = size.height + 65;
}

#pragma mark - 产品描述
- (UILabel *)goodsDescribe {
    if (!_goodsDescribe) {
        _goodsDescribe = [[UILabel alloc] init];
        _goodsDescribe.text = @"产品描述";
        _goodsDescribe.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        _goodsDescribe.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _goodsDescribe;
}

- (UILabel *)describe {
    if (!_describe) {
        _describe = [[UILabel alloc] init];
        _describe.font = [UIFont systemFontOfSize:Font_Tag];
        _describe.textColor = [UIColor colorWithHexString:@"#333333"];
        _describe.numberOfLines = 0;
    }
    return _describe;
}

@end
