//
//  THNDataInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDataInfoTableViewCell.h"
#import "CommentNViewController.h"

@implementation THNDataInfoTableViewCell {
    NSString *_sceneId;
    NSString *_userId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel;
- (void)thn_setSceneData:(HomeSceneListRow *)dataModel {
    [self.look setTitle:[NSString stringWithFormat:@"%zi", dataModel.viewCount] forState:(UIControlStateNormal)];
    [self.like setTitle:[NSString stringWithFormat:@"%zi", dataModel.loveCount] forState:(UIControlStateNormal)];
    _sceneId = [NSString stringWithFormat:@"%zi", dataModel.idField];
    _userId = [NSString stringWithFormat:@"%zi", dataModel.userId];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.look];
    [_look mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.more];
    [_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.share];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.right.equalTo(_more.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.comments];
    [_comments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.right.equalTo(_share.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.like];
    [_like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.right.equalTo(_comments.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - init
- (UIButton *)look {
    if (!_look) {
        _look = [[UIButton alloc] init];
        _look.titleLabel.font = [UIFont systemFontOfSize:10];
        [_look setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        [_look setImage:[UIImage imageNamed:@"shouye_look"] forState:(UIControlStateNormal)];
        _look.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_look setTitleEdgeInsets:(UIEdgeInsetsMake(-10, 3, 0, 0))];
    }
    return _look;
}

- (UIButton *)more {
    if (!_more) {
        _more = [[UIButton alloc] init];
        [_more setImage:[UIImage imageNamed:@"shouye_more"] forState:(UIControlStateNormal)];
        [_more addTarget:self action:@selector(moreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _more;
}

- (void)moreClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"查看更多"];
}

- (UIButton *)share {
    if (!_share) {
        _share = [[UIButton alloc] init];
        [_share setImage:[UIImage imageNamed:@"shouye_share"] forState:(UIControlStateNormal)];
        [_share addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _share;
}

- (void)shareClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"分享"];
}

- (UIButton *)comments {
    if (!_comments) {
        _comments = [[UIButton alloc] init];
        [_comments setImage:[UIImage imageNamed:@"shouye_comment"] forState:(UIControlStateNormal)];
        [_comments addTarget:self action:@selector(commentsClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _comments;
}

- (void)commentsClick:(UIButton *)button {
    CommentNViewController * commentVC = [[CommentNViewController alloc] init];
    commentVC.targetId = _sceneId;
    commentVC.sceneUserId = _userId;
    [self.nav pushViewController:commentVC animated:YES];
}

- (UIButton *)like {
    if (!_like) {
        _like = [[UIButton alloc] init];
        [_like setImage:[UIImage imageNamed:@"icon_zan"] forState:(UIControlStateNormal)];
        [_like setImage:[UIImage imageNamed:@"icon_yizan"] forState:(UIControlStateSelected)];
        [_like addTarget:self action:@selector(likeClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_like setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _like.titleLabel.font = [UIFont systemFontOfSize:10];
        _like.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_like setTitleEdgeInsets:(UIEdgeInsetsMake(-10, 3, 0, 0))];
    }
    return _like;
}

- (void)likeClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    }
}

@end
