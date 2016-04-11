//
//  CommentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setCellViewUI];
        
    }
    return self;
}

#pragma mark 
- (void)setUI:(NSString *)str {
    _userHeader.image = [UIImage imageNamed:@"asd"];
    
    _comment.text = str;
    CGSize size = [_comment boundingRectWithSize:CGSizeMake(220, 0)];

    if (size.width > 200) {
        [self changeCommentStyle:str];
        
        CGFloat labelHeight = [_comment sizeThatFits:CGSizeMake(200, MAXFLOAT)].height;
        NSNumber * count = @((labelHeight) / _comment.font.lineHeight);
        
        [_comment mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, size.height + ([count integerValue] * 2) + 15));
        }];
        
        [_bubble mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(220, size.height + ([count integerValue] * 2) + 15));
        }];
        
    } else {
        [_comment mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, 15));
        }];
        
        [_bubble mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width + 27, size.height + 15));
        }];
    }
    
    _bubble.image = [[UIImage imageNamed:@"bubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
}

#pragma mark - 获取高度
- (void)getCellHeight:(NSString *)str {
    _comment.text = str;
    CGSize size = [_comment boundingRectWithSize:CGSizeMake(220, 0)];
    CGFloat labelHeight = [_comment sizeThatFits:CGSizeMake(200, MAXFLOAT)].height;
    NSNumber * count = @((labelHeight) / _comment.font.lineHeight);

    self.cellHeight = size.height + ([count integerValue] * 2) + 30;
    
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.mas_top).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.bubble];
    [_bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.top.equalTo(_userHeader.mas_top).with.offset(0);
        make.left.equalTo(_userHeader.mas_right).with.offset(10);
    }];

    [self.bubble addSubview:self.comment];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.left.equalTo(_bubble.mas_left).with.offset(15);
        make.centerY.equalTo(_bubble);
    }];
}

#pragma mark - 用户头像
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 30 / 2;
        _userHeader.layer.masksToBounds = YES;
    }
    return _userHeader;
}

#pragma mark - 内容气泡背景
- (UIImageView *)bubble {
    if (!_bubble) {
        _bubble = [[UIImageView alloc] init];
    }
    return _bubble;
}

#pragma mark - 评论内容
- (UILabel *)comment {
    if (!_comment) {
        _comment = [[UILabel alloc] init];
        _comment.textColor = [UIColor colorWithHexString:titleColor alpha:1];
        _comment.font = [UIFont systemFontOfSize:Font_Comment];
        _comment.numberOfLines = 0;
    }
    return _comment;
}

//  评论内容的格式
- (void)changeCommentStyle:(NSString *)comment {
    NSMutableAttributedString * commentText = [[NSMutableAttributedString alloc] initWithString:comment];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [commentText addAttributes:textDict range:NSMakeRange(0, commentText.length)];
    _comment.attributedText = commentText;
}

#pragma mark - 查看全部评论
- (UIButton *)allComment {
    if (!_allComment) {
        _allComment = [[UIButton alloc] init];
        
    }
    return _allComment;
}


@end
