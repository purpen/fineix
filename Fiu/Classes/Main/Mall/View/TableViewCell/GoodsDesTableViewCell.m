//
//  GoodsDesTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/6/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsDesTableViewCell.h"

@implementation GoodsDesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setCellUI];
    }
    return self;
}

#pragma mark
- (void)setGoodsDesText:(NSString *)text {
    [self changeContentLabStyle:self.desContent withText:text];
}

#pragma mark - 获取高度
- (void)getContentCellHeight:(NSString *)content {
    self.desContent.text = content;
    CGSize size = [self.desContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    self.cellHeight = size.height + 40;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 30));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.desContent];
    [_desContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 15));
        make.top.equalTo(self.headerTitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.headerTitle.mas_left).with.offset(0);
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
        make.size.mas_equalTo(CGSizeMake(size.width , size.height + 10));
    }];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.text = NSLocalizedString(@"goodsStern", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#222222"];
        _headerTitle.font = [UIFont systemFontOfSize:14];
    }
    return _headerTitle;
}

#pragma mark - 产品描述内容
- (UILabel *)desContent {
    if (!_desContent) {
        _desContent = [[UILabel alloc] init];
        _desContent.font = [UIFont systemFontOfSize:12];
        _desContent.textColor = [UIColor colorWithHexString:@"#222222"];
        _desContent.numberOfLines = 0;
    }
    return _desContent;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

@end
