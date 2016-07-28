//
//  LikeSceneView.m
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "LikeSceneView.h"

@implementation LikeSceneView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.likeBtn];
        
        [self addSubview:self.line];
    }
    return self;
}

#pragma mark - 场景点赞按钮
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _likeBtn.backgroundColor = [UIColor whiteColor];
        [_likeBtn setTitle:NSLocalizedString(@"sceneLike", nil) forState:(UIControlStateNormal)];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _likeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        } else {
            _likeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        [_likeBtn setImage:[UIImage imageNamed:@"Like_Scene"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"Like_Scene_Selected"] forState:(UIControlStateSelected)];
        [_likeBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
    }
    return _likeBtn;
}

#pragma mark - 分割线 
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

@end
