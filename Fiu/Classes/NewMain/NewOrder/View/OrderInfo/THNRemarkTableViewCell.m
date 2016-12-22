//
//  THNRemarkTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/12/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemarkTableViewCell.h"
#import "UILable+Frame.h"

@interface THNRemarkTableViewCell() {
    CGFloat _contentH;
}

@end

@implementation THNRemarkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setRemarkContentData:(OrderInfoModel *)model {
    self.content.text = model.summary;
    if (model.summary.length == 0) {
        self.remarkLab.hidden = YES;
    }
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (CGFloat)thn_getRemarkContentHeight:(NSString *)content {
    self.content.text = content;
    CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(320, 0)].height;
    return 30 + contentH;
}

- (void)setCellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.remarkLab];
    [_remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(5);
    }];
}

- (UILabel *)remarkLab {
    if (!_remarkLab) {
        _remarkLab = [[UILabel alloc] init];
        _remarkLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _remarkLab.text = @"备注";
        if (IS_iOS9) {
            _remarkLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _remarkLab.font = [UIFont systemFontOfSize:14];
        }
    }
    return _remarkLab;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = [UIColor colorWithHexString:@"#666666"];
        if (IS_iOS9) {
            _content.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _content.font = [UIFont systemFontOfSize:12];
        }
    }
    return _content;
}

@end
