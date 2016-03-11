//
//  ScenceAddMoreView.m
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenceAddMoreView.h"

@implementation ScenceAddMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
        
        [self setUI];
    }
    return self;
}

#pragma mark - 设置UI
- (void)setUI {
    [self addSubview:self.addLoacation];
    [_addLoacation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.addTag];
    [_addTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(self.addLoacation.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.addScene];
    [_addScene mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(self.addTag.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
}

#pragma mark - 添加地理位置
- (UIView *)addLoacation {
    if (!_addLoacation) {
        _addLoacation = [[UIView alloc] init];
        _addLoacation.backgroundColor = [UIColor purpleColor];
        
        UIButton * locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, 100, 35)];
        [locationBtn setTitle:@"推荐的地址" forState:(UIControlStateNormal)];
        locationBtn.backgroundColor = [UIColor blueColor];
        [locationBtn addTarget:self action:@selector(locationFrame) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_addLoacation addSubview:locationBtn];
        
        [_addLoacation addSubview:self.addLoacationBtn];
    }
    return _addLoacation;
}

//  添加地点
- (UIButton *)addLoacationBtn {
    if (!_addLoacationBtn) {
        _addLoacationBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 50, 44)];
        [_addLoacationBtn setTitle:@"添加地点" forState:(UIControlStateNormal)];
        [_addLoacationBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addLoacationBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addLoacationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addLoacationBtn.backgroundColor = [UIColor whiteColor];
        [_addLoacationBtn addTarget:self action:@selector(changeLocationFrame) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addLoacationBtn;
}

- (void)changeLocationFrame {
    [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
    
}

- (void)locationFrame {
    [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
    }];
}

#pragma mark - 添加标签
- (UIView *)addTag {
    if (!_addTag) {
        _addTag = [[UIView alloc] init];
        _addTag.backgroundColor = [UIColor orangeColor];
        
        [_addTag addSubview:self.addTagBtn];
    }
    return _addTag;
}

//  添加标签
- (UIButton *)addTagBtn {
    if (!_addTagBtn) {
        _addTagBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 44)];
        [_addTagBtn setTitle:@"标签" forState:(UIControlStateNormal)];
        [_addTagBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addTagBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addTagBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addTagBtn.backgroundColor = [UIColor whiteColor];
        [_addTagBtn addTarget:self action:@selector(changeTagFrame) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addTagBtn;
}

- (void)changeTagFrame {
    [_addTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
}

#pragma mark - 添加所属情景
- (UIView *)addScene {
    if (!_addScene) {
        _addScene = [[UIView alloc] init];
        _addScene.backgroundColor = [UIColor grayColor];

        [_addScene addSubview:self.addSceneBtn];
    }
    return _addScene;
}

//  所属情景
- (UIButton *)addSceneBtn {
    if (!_addSceneBtn) {
        _addSceneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 44)];
        [_addSceneBtn setTitle:@"所属情景" forState:(UIControlStateNormal)];
        [_addSceneBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addSceneBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addSceneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addSceneBtn.backgroundColor = [UIColor whiteColor];
        [_addSceneBtn addTarget:self action:@selector(changeSceneFrame) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addSceneBtn;
}

- (void)changeSceneFrame {
    [_addScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
}

@end
