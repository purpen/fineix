//
//  THNDesTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDesTableViewCell.h"

@implementation THNDesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setDesData:(DominInfoData *)model {
    if (model.des.length) {
        [self getDesText:model.des];
        
        CGSize size = [self getTextFrame:model.des];
        
        self.defaultCellHigh = size.height * 1.4 + 15;
    }
}


- (void)getDesText:(NSString *)content {
    self.desLabel.attributedText = [self getAttributedStringWithString:content lineSpace:5.0f];
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

#pragma mark - setUI

- (void)setCellViewUI {
    [self addSubview:self.desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
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
