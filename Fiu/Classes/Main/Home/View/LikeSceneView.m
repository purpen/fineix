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

#pragma mark - 订阅情景按钮
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _likeBtn.backgroundColor = [UIColor whiteColor];
        [_likeBtn setTitle:@" 赞" forState:(UIControlStateNormal)];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_likeBtn setImage:[UIImage imageNamed:@"Like_Scene"] forState:(UIControlStateNormal)];
        [_likeBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        
        [_likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
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

//  订阅情景
- (void)likeBtnClick {
    NSLog(@"－－－－－＝＝＝＝＝＝－－－－点赞此场景");
}

@end
