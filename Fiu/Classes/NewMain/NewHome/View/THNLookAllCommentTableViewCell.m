//
//  THNLookAllCommentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLookAllCommentTableViewCell.h"

@implementation THNLookAllCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

- (void)thn_setAllCommentCountData:(NSInteger)count {
    self.allComment.text = [NSString stringWithFormat:@"查看全部%zi条评论", count];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.graybackView];
    [_graybackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.allComment];
    [_allComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
}

#pragma mark - init
- (UIView *)graybackView {
    if (!_graybackView) {
        _graybackView = [[UIView alloc] init];
        _graybackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _graybackView;
}

- (UILabel *)allComment {
    if (!_allComment) {
        _allComment = [[UILabel alloc] init];
        _allComment.textColor = [UIColor colorWithHexString:@"#999999"];
        _allComment.font = [UIFont systemFontOfSize:10];
    }
    return _allComment;
}

@end
