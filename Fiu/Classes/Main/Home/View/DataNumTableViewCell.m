//
//  DataNumTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DataNumTableViewCell.h"

@implementation DataNumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setCellViewUI];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark - 
- (void)setUI {
    
    CGFloat lookNum = 4231;
    if (lookNum/1000 > 1) {
        [_lookBtn setTitle:[NSString stringWithFormat:@"%.1fk", lookNum/1000] forState:(UIControlStateNormal)];
    } else {
        [_lookBtn setTitle:[NSString stringWithFormat:@"%.0f", lookNum] forState:(UIControlStateNormal)];
    }
    
    CGFloat likeNum = 321;
    if (likeNum/1000 > 1) {
        [_likeBtn setTitle:[NSString stringWithFormat:@"%.1fk", likeNum/1000] forState:(UIControlStateNormal)];
    } else {
        [_likeBtn setTitle:[NSString stringWithFormat:@"%.0f", likeNum] forState:(UIControlStateNormal)];
    }
    
    CGFloat commentNum = 53131;
    if (commentNum/1000 > 1) {
        [_commentBtn setTitle:[NSString stringWithFormat:@"%.1fk", commentNum/1000] forState:(UIControlStateNormal)];
    } else {
        [_commentBtn setTitle:[NSString stringWithFormat:@"%.0f", commentNum] forState:(UIControlStateNormal)];
    }
}

#pragma mark - 设置cell的UI
- (void)setCellViewUI {
    [self addSubview:self.lookBtn];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    [self addSubview:self.likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(_lookBtn.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(_likeBtn.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}

#pragma mark - 观看
- (UIButton *)lookBtn {
    if (!_lookBtn) {
        _lookBtn = [[UIButton alloc] init];
        [_lookBtn setImage:[UIImage imageNamed:@"lookNum"] forState:(UIControlStateNormal)];
        [_lookBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Number];
        [_lookBtn setTitleColor:[UIColor colorWithHexString:tabBarTitle alpha:1] forState:(UIControlStateNormal)];
    }
    return _lookBtn;
}

#pragma mark - 喜欢
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"likeNum"] forState:(UIControlStateNormal)];
        [_likeBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Number];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:tabBarTitle alpha:1] forState:(UIControlStateNormal)];
    }
    return _likeBtn;
}

#pragma mark - 评论
- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setImage:[UIImage imageNamed:@"commentNum"] forState:(UIControlStateNormal)];
        [_commentBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Number];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:tabBarTitle alpha:1] forState:(UIControlStateNormal)];
    }
    return _commentBtn;
}

#pragma mark - 更多
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
        
    }
    return _moreBtn;
}

@end
