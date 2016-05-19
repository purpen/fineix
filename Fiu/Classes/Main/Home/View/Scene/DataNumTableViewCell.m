//
//  DataNumTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DataNumTableViewCell.h"
#import "CommentNViewController.h"

@implementation DataNumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellViewUI];
        
    }
    return self;
}

#pragma mark - 
- (void)setSceneDataNum:(SceneInfoData *)model {
    [_lookBtn setTitle:[self abouText:_lookBtn withText:model.viewCount] forState:(UIControlStateNormal)];
    [_likeBtn setTitle:[self abouText:_likeBtn withText:model.loveCount]  forState:(UIControlStateNormal)];
    [_commentBtn setTitle:[self abouText:_commentBtn withText:model.commentCount] forState:(UIControlStateNormal)];
    self.tagetId = [NSString stringWithFormat:@"%zi", model.idField];
}

#pragma mark - 设置cell的UI
- (void)setCellViewUI {
    [self addSubview:self.lookBtn];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self addSubview:self.likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(_lookBtn.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 44));
        make.centerY.equalTo(self);
        make.left.equalTo(_likeBtn.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [self addSubview:self.line];
    [self addSubview:self.bottomline];

}

#pragma mark - 观看
- (UIButton *)lookBtn {
    if (!_lookBtn) {
        _lookBtn = [[UIButton alloc] init];
        [_lookBtn setImage:[UIImage imageNamed:@"lookNum"] forState:(UIControlStateNormal)];
        [_lookBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Number];
        [_lookBtn setTitleEdgeInsets:(UIEdgeInsetsMake(-15, 0, 0, 0))];
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
        [_likeBtn setTitleEdgeInsets:(UIEdgeInsetsMake(-15, 0, 0, 0))];
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
        [_commentBtn setTitleEdgeInsets:(UIEdgeInsetsMake(-15, 0, 0, 0))];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:tabBarTitle alpha:1] forState:(UIControlStateNormal)];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _commentBtn;
}

- (void)commentBtnClick {
    CommentNViewController * commentVC = [[CommentNViewController alloc] init];
    commentVC.targetId = self.tagetId;
    [self.nav pushViewController:commentVC animated:YES];
}

//  数字宽度
- (NSString *)abouText:(UIButton *)button withText:(NSInteger)num {
    if (num/1000 > 1) {
        NSString * numText = [NSString stringWithFormat:@"%zik", num/1000];
        CGFloat textLength = [numText boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textLength + 35);
        }];
        return numText;
        
    } else {
        NSString * numText = [NSString stringWithFormat:@"%zi", num];
        CGFloat textLength = [numText boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textLength + 30);
        }];
        return numText;
    }
}

#pragma mark - 更多
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
    }
    return _moreBtn;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    }
    return _line;
}

- (UILabel *)bottomline {
    if (!_bottomline) {
        _bottomline = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        _bottomline.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    }
    return _bottomline;
}

@end
