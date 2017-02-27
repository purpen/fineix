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
    self.cellHeight = [self getTextFrame:content];
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
        make.width.mas_equalTo(@(SCREEN_WIDTH - 40));
        make.top.equalTo(self.headerTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.headerTitle.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
}

//  内容文字的样式
- (void)changeContentLabStyle:(UILabel *)lable withText:(NSString *)str {
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:12]};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    lable.attributedText = contentText;
}

//  文字高度
- (CGFloat)getTextFrame:(NSString *)text {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSDictionary *attribute = @{NSParagraphStyleAttributeName :paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGFloat textHeight = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0)
                                           options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading |
                          NSStringDrawingUsesDeviceMetrics
                                        attributes:attribute
                                           context:nil].size.height * 1.2;
    return textHeight + 40;
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
