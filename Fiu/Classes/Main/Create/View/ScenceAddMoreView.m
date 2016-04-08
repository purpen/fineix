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

static const NSInteger btnTag = 100;

@implementation ScenceAddMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
        
        [self setUI];
        
        [self initBMKSearch];

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

#pragma mark - 搜索照片所带位置的附近
- (void)changeLocationFrame:(NSArray *)locationArr {
    [self searchPhotoLocation:[locationArr[1] floatValue] withLongitude:[locationArr[0] floatValue]];

}

#pragma mark - 初始化geo地理编码搜索
- (void)initBMKSearch {
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    _nameMarr = [NSMutableArray array];
    _cityMarr = [NSMutableArray array];
}

- (void)searchPhotoLocation:(CGFloat )latitude withLongitude:(CGFloat )longitude {
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = CLLocationCoordinate2DMake(latitude, longitude);
    [_geoCodeSearch reverseGeoCode:option];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        for (NSUInteger idx = 0; idx < 5; ++ idx) {
            BMKPoiInfo * poi = [result.poiList objectAtIndex:idx];
            [_nameMarr addObject:poi.name];
            [_cityMarr addObject:poi.city];
        }
        //  最后一个为“搜索”按钮
        [_nameMarr addObject:@"  搜索  "];
        [self addLocationScrollView:_nameMarr];
        
    } else {
        NSLog(@"搜索结果错误 －－－－－ %d", error);
    }
}

- (void)dealloc {
    _geoCodeSearch.delegate = nil;
}

- (void)addLocationScrollView:(NSMutableArray *)locationMarr {
    
    CGFloat width = 0;
    CGFloat height = 8;

    for (NSUInteger idx = 0; idx < locationMarr.count; ++ idx) {
        UIButton * locationBtn = [[UIButton alloc] init];
        CGFloat btnLength = [[locationMarr objectAtIndex:idx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        [locationBtn setTitle:locationMarr[idx] forState:(UIControlStateNormal)];
        [locationBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        locationBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Number];
        locationBtn.layer.cornerRadius = 5;
        locationBtn.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:1].CGColor;
        locationBtn.layer.borderWidth = 0.5f;
        locationBtn.frame = CGRectMake(15 + width + (10 * idx), height, btnLength + 40, 29);
        width = locationBtn.frame.size.width + width;
        locationBtn.tag = btnTag + idx;
        
        if (locationBtn.tag == btnTag + 5) {
            [locationBtn setImage:[UIImage imageNamed:@"Search"] forState:(UIControlStateNormal)];
        }
        
        [locationBtn addTarget:self action:@selector(changeLocationName:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.locationScrollView addSubview:locationBtn];
    }
    self.locationScrollView.contentSize = CGSizeMake(width + 80, 0);
    [_addLoacation addSubview:self.locationScrollView];
    
    //  分割线
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7" alpha:1];
    [_addLoacation addSubview:line];
    
    [self onLocationFrame];
   
}

#pragma mark - 选择推荐位置改变选择地点 
- (void)changeLocationName:(UIButton *)button {
    
    //  搜索地点
    if (button.tag == btnTag + 5) {
        SearchLocationViewController * searchLocationVC = [[SearchLocationViewController alloc] init];
        [self.nav pushViewController:searchLocationVC animated:YES];
        
    } else {
        _location.text = [NSString stringWithFormat:@"%@ %@", _cityMarr[button.tag - btnTag], _nameMarr[button.tag - btnTag]];
        _addLoacationBtn.hidden = YES;
        _locationView.hidden = NO;
        [self offLocationFrame];
    }
}

#pragma mark - 创建根据照片位置推荐的五个附近
- (UIScrollView *)locationScrollView {
    if(!_locationScrollView) {
        _locationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
        _locationScrollView.showsHorizontalScrollIndicator = NO;
        _locationScrollView.showsVerticalScrollIndicator = NO;
    }
    return _locationScrollView;
}

#pragma mark - 添加地理位置
- (UIView *)addLoacation {
    if (!_addLoacation) {
        _addLoacation = [[UIView alloc] init];
        _addLoacation.backgroundColor = [UIColor whiteColor];
        
        [_addLoacation addSubview:self.addLoacationBtn];
        
        [_addLoacation addSubview:self.locationIcon];
        
        [_addLoacation addSubview:self.locationView];
        
        self.locationView.hidden = YES;
        
    }
    return _addLoacation;
}

//  添加地理位置后恢复“添加地点”的高度
- (void)offLocationFrame {
    [UIView animateWithDuration:.3 animations:^{
        [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            
            [_addLoacation layoutIfNeeded];
        }];
    }];
    
}

//  如果有推荐的位置，更新“添加地点”的约束
- (void)onLocationFrame {
    [UIView animateWithDuration:.3 animations:^{
        [_addLoacation mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@88);
        }];
        
        [_addLoacation layoutIfNeeded];
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
        [_addLoacationBtn setTitle:NSLocalizedString(@"addLocation", nil) forState:(UIControlStateNormal)];
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
        [self offLocationFrame];
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
        _location = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 88, 44)];
        _location.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        _location.font = [UIFont systemFontOfSize:Font_GroupHeader];
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
        [_addTagBtn setTitle:NSLocalizedString(@"tag", nil) forState:(UIControlStateNormal)];
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
        [_addSceneBtn setTitle:NSLocalizedString(@"onScene", nil) forState:(UIControlStateNormal)];
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