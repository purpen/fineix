//
//  THNUserAddGoodsTitleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/9/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNUserAddGoodsTitleTableViewCell.h"

@implementation THNUserAddGoodsTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        
    }
    return self;
}

- (void)getContentCellHeight:(NSString *)content {
    self.goodsTitle.text = content;
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 0)];
    self.cellHeight = size.height + 50;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-90);
    }];
}

#pragma mark -  标题
- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
        _goodsTitle.font = [UIFont systemFontOfSize:Font_InfoTitle];
        _goodsTitle.numberOfLines = 2;
    }
    return _goodsTitle;
}
@end
