//
//  CommentDataTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentDataTableViewCell.h"

@implementation CommentDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
        
    }
    return self;
}

- (void)setCommentData:(CommentRow *)model {
    [self.userHeader downloadImage:model.user.smallAvatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = model.user.nickname;
    self.time.text = model.createdAt;
    if (model.isReply == 1) {
        self.content.text = [NSString stringWithFormat:@"回复 %@：%@", model.replyUserName, model.content];
    } else {
        self.content.text = model.content;
    }
}

#pragma mark - 
- (void)setCellViewUI {
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.top.equalTo(self.mas_top ).with.offset(10);
        make.left.equalTo(self.userHeader.mas_right).with.offset(15);
    }];
    
    [self addSubview:self.time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.top.equalTo(self.mas_top).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).with.offset(10);
        make.left.equalTo(self.userName.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
}

#pragma mark - 头像
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 15;
        _userHeader.layer.masksToBounds = YES;
    }
    return _userHeader;
}

#pragma mark - 昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#222222"];
        _userName.font = [UIFont systemFontOfSize:12];
    }
    return _userName;
}

#pragma mark - 回复内容
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor colorWithHexString:titleColor];
        _content.font = [UIFont systemFontOfSize:12];
        _content.numberOfLines = 0;
    }
    return _content;
}

#pragma mark - 日期
- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor colorWithHexString:@"#999999"];
        _time.font = [UIFont systemFontOfSize:12];
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}

@end

