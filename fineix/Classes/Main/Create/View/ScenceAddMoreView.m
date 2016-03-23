//
//  ScenceAddMoreView.m
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenceAddMoreView.h"
#import "SearchLocationViewController.h"
#import "AddTagViewController.h"
#import "SelectSceneViewController.h"

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
        _addLoacation.backgroundColor = [UIColor whiteColor];
        
        UIButton * locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, 100, 35)];
        [locationBtn setTitle:@"推荐的地址" forState:(UIControlStateNormal)];
        locationBtn.backgroundColor = [UIColor blueColor];
        [locationBtn addTarget:self action:@selector(locationFrame) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_addLoacation addSubview:locationBtn];
        
        [_addLoacation addSubview:self.addLoacationBtn];
        
        [_addLoacation addSubview:self.locationIcon];
        
        [_addLoacation addSubview:self.locationView];
        self.locationView.hidden = YES;
        
    }
    return _addLoacation;
}

//  添加地理位置后恢复“添加地点”的高度
- (void)locationFrame {
    [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
    }];
}

//  推荐地点时，改变“添加地点”的高度
- (void)changeLocationFrame {
    [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
}

#pragma mark - 地点图标
- (UIImageView *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _locationIcon.image = [UIImage imageNamed:@"icon_map"];
        _locationIcon.contentMode = UIViewContentModeCenter;
    }
    return _locationIcon;
}

#pragma mark - 添加地理位置按钮
- (UIButton *)addLoacationBtn {
    if (!_addLoacationBtn) {
        _addLoacationBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 44, 44)];
        [_addLoacationBtn setTitle:@"添加地点" forState:(UIControlStateNormal)];
        [_addLoacationBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addLoacationBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addLoacationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addLoacationBtn.backgroundColor = [UIColor whiteColor];
        [_addLoacationBtn addTarget:self action:@selector(changeLocation) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addLoacationBtn;
}

//  选择地理位置
- (void)changeLocation {
    SearchLocationViewController * searchLocation = [[SearchLocationViewController alloc] init];
    searchLocation.selectedLocationBlock = ^(NSString * location, NSString * city){
        _location.text = [NSString stringWithFormat:@"%@ %@", city, location];
        _addLoacationBtn.hidden = YES;
        _locationView.hidden = NO;
        [self locationFrame];
    };
    [self.nav pushViewController:searchLocation animated:YES];
}

#pragma mark - 显示地理位置的视图
- (UIView *)locationView {
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 44, 44)];
        
        [_locationView addSubview:self.removeLocation];
        [_removeLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_locationView.mas_top).with.offset(0);
            make.right.equalTo(_locationView.mas_right).with.offset(0);
        }];
        
        [_locationView addSubview:self.location];
    
    }
    return _locationView;
}

#pragma mark - 地点
- (UILabel *)location {
    if (!_location) {
        _location = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        _location.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        _location.font = [UIFont systemFontOfSize:14];
//        _location.text = @"北京 太火红鸟科技有限公司";
    }
    return _location;
    
}

#pragma mark - 删除地点
- (UIButton *)removeLocation {
    if (!_removeLocation) {
        _removeLocation = [[UIButton alloc] init];
        [_removeLocation addTarget:self action:@selector(removeLocationClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_removeLocation setImage:[UIImage imageNamed:@"removeLocation"] forState:(UIControlStateNormal)];
    }
    return _removeLocation;
}

- (void)removeLocationClick {
    _locationView.hidden = YES;
    _addLoacationBtn.hidden = NO;
}

#pragma mark - 添加标签
- (UIView *)addTag {
    if (!_addTag) {
        _addTag = [[UIView alloc] init];
        _addTag.backgroundColor = [UIColor whiteColor];
        
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
        [_addTagBtn addTarget:self action:@selector(chooesTag) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addTagBtn;
}

//  改变高度
- (void)changeTagFrame {
    [_addTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
}

//  去选择标签
- (void)chooesTag {
    AddTagViewController * addTagVC = [[AddTagViewController alloc] init];
    [self.nav pushViewController:addTagVC animated:YES];

}

#pragma mark - 添加所属情景
- (UIView *)addScene {
    if (!_addScene) {
        _addScene = [[UIView alloc] init];
        _addScene.backgroundColor = [UIColor whiteColor];

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
        [_addSceneBtn addTarget:self action:@selector(chooseScene) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addSceneBtn;
}

//  改变高度
- (void)changeSceneFrame {
    [_addScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
}

//  去选择所属的情境
- (void)chooseScene {
    SelectSceneViewController * selectSceneVC = [[SelectSceneViewController alloc] init];
    [self.nav pushViewController:selectSceneVC animated:YES];
}

@end
