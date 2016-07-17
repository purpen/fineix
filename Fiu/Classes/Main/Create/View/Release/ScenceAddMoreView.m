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
#import "AddTagViewController.h"
#import "ChooseTagsCollectionViewCell.h"
#import "SelectAllFSceneViewController.h"
#import "TagFlowLayout.h"
#import "EditChooseTagsViewController.h"

static const NSInteger btnTag = 100;

@interface ScenceAddMoreView () {
    CGFloat  _tagsViewH;
}

@end

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
    
    [self addSubview:self.recommendView];
    [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0));
        make.top.equalTo(_addTag.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.addScene];
    [_addScene mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(_recommendView.mas_bottom).with.offset(5);
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
        if (result.poiList.count > 5) {
            for (NSUInteger idx = 0; idx < 5; ++ idx) {
                BMKPoiInfo * poi = [result.poiList objectAtIndex:idx];
                [_nameMarr addObject:poi.name];
                [_cityMarr addObject:poi.city];
            }
            
        } else if (result.poiList.count > 5) {
            for (NSUInteger idx = 0; idx < result.poiList.count; ++ idx) {
                BMKPoiInfo * poi = [result.poiList objectAtIndex:idx];
                [_nameMarr addObject:poi.name];
                [_cityMarr addObject:poi.city];
            }
        }
        
        //  最后一个为“搜索”按钮
        if (_nameMarr.count > 0) {
            [_nameMarr addObject:@"  搜索  "];
            [self addLocationScrollView:_nameMarr];
        }
        
    } else {
        NSLog(@"搜索结果错误 －－－－－ %d", error);
    }
}

- (void)dealloc {
    _geoCodeSearch.delegate = nil;
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"a" object:nil];
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
    //  搜索地点d
    if (button.tag == btnTag + 5) {
        SearchLocationViewController * searchLocationVC = [[SearchLocationViewController alloc] init];
        searchLocationVC.delegeta = self;
        NSLog(@"%@",searchLocationVC.delegeta);
        [self.nav pushViewController:searchLocationVC animated:YES];
        
    } else {
        _location.text = [NSString stringWithFormat:@"%@ %@", _cityMarr[button.tag - btnTag], _nameMarr[button.tag - btnTag]];
        _addLoacationBtn.hidden = YES;
        _locationView.hidden = NO;
        [self offLocationFrame];
    }
}

-(void)getUserInfo:(NSString *)name{
    self.location.text = name;
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
        _addLoacationBtn = [[UIButton alloc] initWithFrame:CGRectMake(34, 0, SCREEN_WIDTH - 44, 44)];
        [_addLoacationBtn setTitle:NSLocalizedString(@"addLocation", nil) forState:(UIControlStateNormal)];
        [_addLoacationBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addLoacationBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addLoacationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addLoacationBtn.backgroundColor = [UIColor whiteColor];
        [_addLoacationBtn addTarget:self action:@selector(changeLocation) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addLoacationBtn;
}

- (void)reciveNotice:(NSNotification *)notification{
    
    _location.text = [NSString stringWithFormat:@"%@ %@", [notification.userInfo objectForKey:@"city"], [notification.userInfo objectForKey:@"name"]];
    _latitude = [notification.userInfo objectForKey:@"lat"];
    _longitude = [notification.userInfo objectForKey:@"lon"];
    _addLoacationBtn.hidden = YES;
    _locationView.hidden = NO;
    [self offLocationFrame];
    NSArray * locaArr = [NSArray arrayWithObjects:_latitude, _longitude, nil];
    //  from #import "ReleaseViewController.h"
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationArr" object:locaArr];
    
}


//  选择地理位置
- (void)changeLocation {
    //获取通知中心
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    
    //添加观察者 Observer表示观察者  reciveNotice:表示接收到的消息  name表示再通知中心注册的通知名  object表示可以相应的对象 为nil的话表示所有对象都可以相应
    [center addObserver:self selector:@selector(reciveNotice:) name:@"a" object:nil];
    SearchLocationViewController * searchLocation = [[SearchLocationViewController alloc] init];
    searchLocation.type = @"release";
    searchLocation.selectedLocationBlock = ^(NSString * location, NSString * city, NSString * latitude, NSString * longitude){
        _location.text = [NSString stringWithFormat:@"%@ %@", city, location];
        _latitude = latitude;
        _longitude = longitude;
        _addLoacationBtn.hidden = YES;
        _locationView.hidden = NO;
        [self offLocationFrame];
        NSArray * locaArr = [NSArray arrayWithObjects:_latitude, _longitude, nil];
        //  from #import "ReleaseViewController.h"
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationArr" object:locaArr];
    };
    [self.nav pushViewController:searchLocation animated:YES];
}

#pragma mark - 显示地理位置的视图
- (UIView *)locationView {
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(34, 0, SCREEN_WIDTH - 44, 44)];
        
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

#pragma mark - 标签图标
- (UIImageView *)tagIcon {
    if (!_tagIcon) {
        _tagIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _tagIcon.image = [UIImage imageNamed:@"icon_map"];
        _tagIcon.contentMode = UIViewContentModeCenter;
    }
    return _tagIcon;
}

#pragma mark - 添加标签
- (UIView *)addTag {
    if (!_addTag) {
        _addTag = [[UIView alloc] init];
        _addTag.backgroundColor = [UIColor whiteColor];
        
        [_addTag addSubview:self.tagIcon];
        [_addTag addSubview:self.addTagBtn];
    }
    return _addTag;
}

- (UILabel *)addTagLab {
    if (!_addTagLab) {
        _addTagLab = [[UILabel alloc] init];
        _addTagLab.text = NSLocalizedString(@"recommendTag", nil);
        _addTagLab.textAlignment = NSTextAlignmentCenter;
        _addTagLab.font = [UIFont systemFontOfSize:13];
        _addTagLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _addTagLab;
}

//  添加标签
- (UIButton *)addTagBtn {
    if (!_addTagBtn) {
        _addTagBtn = [[UIButton alloc] initWithFrame:CGRectMake(34, 0, SCREEN_WIDTH - 44, 44)];
        [_addTagBtn setTitle:NSLocalizedString(@"tag", nil) forState:(UIControlStateNormal)];
        [_addTagBtn setTitleColor:[UIColor colorWithHexString:blackFont alpha:1] forState:(UIControlStateNormal)];
        _addTagBtn.titleLabel.font = [UIFont systemFontOfSize:Font_GroupHeader];
        _addTagBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addTagBtn.backgroundColor = [UIColor whiteColor];
    }
    return _addTagBtn;
}


#pragma mark - 选择的标签列表
- (UICollectionView *)chooseTagView {
    if (!_chooseTagView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.max = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
        
        _chooseTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(34, 0, SCREEN_WIDTH - 44, 0) collectionViewLayout:flowLayout];
        _chooseTagView.backgroundColor = [UIColor whiteColor];
        _chooseTagView.delegate = self;
        _chooseTagView.dataSource = self;
        _chooseTagView.showsHorizontalScrollIndicator = NO;
        [_chooseTagView registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
    }
    return _chooseTagView;
}

#pragma mark - 有选择的标签时改变frame
- (void)chooseTags {
    [self.addTag addSubview:self.chooseTagView];
    [_chooseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH - 44));
        make.top.equalTo(_addTag.mas_top).with.offset(8);
        make.left.equalTo(_addTag.mas_left).with.offset(34);
        make.bottom.equalTo(_addTag.mas_bottom).with.offset(0);
    }];
    
    CGFloat tagsWidth = 0.0f;
    for (NSUInteger idx = 0; idx < self.chooseTagMarr.count; ++ idx) {
        CGFloat tagW = [self.chooseTagMarr[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 44, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        tagsWidth += (tagW + 40);
    }
    
    CGFloat tagsLineNum = tagsWidth/SCREEN_WIDTH;
    if (tagsLineNum < 1) {
        tagsLineNum = 1;
    }
    CGFloat tagsViewH = (tagsLineNum * 44) + 20;
    
    [_addTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tagsViewH));
    }];
    
    [self.chooseTagView reloadData];
}

#pragma mark - 推荐标签视图
- (UIView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[UIView alloc] init];
        _recommendView.backgroundColor = [UIColor whiteColor];
    }
    return _recommendView;
}

#pragma mark - 推荐的标签列表
- (UICollectionView *)recommendTagView {
    if (!_recommendTagView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.max = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _recommendTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) collectionViewLayout:flowLayout];
        _recommendTagView.backgroundColor = [UIColor whiteColor];
        _recommendTagView.delegate = self;
        _recommendTagView.dataSource = self;
        _recommendTagView.showsHorizontalScrollIndicator = NO;
        [_recommendTagView registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendTagsCollectionViewCell"];
    }
    return _recommendTagView;
}

#pragma mark - 有推荐标签时改变frame
- (void)getRecommendTagS:(NSMutableArray *)tags {
    
    self.recommendTagMarr = tags;
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lab.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    [self.recommendView addSubview:lab];
    
    [self.recommendView addSubview:self.addTagLab];
    [_addTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.left.equalTo(_recommendView.mas_left).with.offset(0);
        make.top.equalTo(_recommendView.mas_top).with.offset(10);
    }];
    
    [self.recommendView addSubview:self.recommendTagView];
    [_recommendTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(_addTagLab.mas_bottom).with.offset(5);
        make.left.equalTo(_recommendView.mas_left).with.offset(0);
        make.bottom.equalTo(_recommendView.mas_bottom).with.offset(0);
    }];
    
    CGFloat tagsWidth = 0.0f;
    for (NSUInteger idx = 0; idx < self.recommendTagMarr.count; ++ idx) {
        CGFloat tagW = [self.recommendTagMarr[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        tagsWidth += (tagW + 40);
    }
    
    CGFloat tagsLineNum = tagsWidth/SCREEN_WIDTH;
    if (tagsLineNum < 1) {
        tagsLineNum = 1;
    }
    _tagsViewH = tagsLineNum * 44 + 40;
    
    [_recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_tagsViewH));
    }];
    
    [self layoutIfNeeded];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.recommendTagView) {
        return self.recommendTagMarr.count;
    } else if (collectionView == self.chooseTagView) {
        return self.chooseTagMarr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendTagView) {
        ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendTagsCollectionViewCell" forIndexPath:indexPath];
        [cell.tagBtn setTitle:self.recommendTagMarr[indexPath.row] forState:(UIControlStateNormal)];
        return cell;
    } else if (collectionView == self.chooseTagView) {
        ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
        [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendTagView) {
        CGFloat tagW = [self.recommendTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        return CGSizeMake(tagW + 30, 28);
    } else if (collectionView == self.chooseTagView) {
        
        CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        return CGSizeMake(tagW + 30, 28);
    }
    return CGSizeMake(0.01, 0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendTagView) {
        if ([self.chooseTagMarr containsObject:self.recommendTagMarr[indexPath.row]]) {
            [SVProgressHUD showInfoWithStatus:@"不可添加重复标签"];
        } else {
            [self.chooseTagMarr addObject:self.recommendTagMarr[indexPath.row]];
            [self chooseTags];
        }
        
    } else if (collectionView == self.chooseTagView) {
        EditChooseTagsViewController * editTagsVC = [[EditChooseTagsViewController alloc] init];
        
        [self.vc presentViewController:editTagsVC animated:YES completion:nil];
    }
}

#pragma mark - 添加所属情景
- (UIView *)addScene {
    if (!_addScene) {
        _addScene = [[UIView alloc] init];
        _addScene.backgroundColor = [UIColor whiteColor];
        [_addScene addSubview:self.addSceneBtn];
        [_addScene addSubview:self.selectFSceneBtn];
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
        
        UIButton * goIcon = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 59, 0, 44, 44)];
        [goIcon setImage:[UIImage imageNamed:@"entr"] forState:(UIControlStateNormal)];
        [_addSceneBtn addSubview:goIcon];
        
    }
    return _addSceneBtn;
}

//  改变高度
- (void)changeSceneFrame:(NSString *)title {
    [_addScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
    
    [self addSelectFSceneBtn:title];

}

- (UIButton *)selectFSceneBtn {
    if (!_selectFSceneBtn) {
        self.selectFSceneBtn = [[UIButton alloc] init];
        [self.selectFSceneBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        self.selectFSceneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.selectFSceneBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        self.selectFSceneBtn.layer.borderWidth = 0.5f;
        self.selectFSceneBtn.layer.cornerRadius = 3;
        self.selectFSceneBtn.layer.masksToBounds = YES;
    }
    return _selectFSceneBtn;
}

- (void)addSelectFSceneBtn:(NSString *)title {
    CGFloat btnW = [title boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    self.selectFSceneBtn.frame = CGRectMake(15, 52, btnW + 20, 29);
    [self.selectFSceneBtn layoutIfNeeded];
    [self.selectFSceneBtn setTitle:title forState:(UIControlStateNormal)];
}

//  去选择所属的情境
- (void)chooseScene {
    SelectAllFSceneViewController * selectSceneVC = [[SelectAllFSceneViewController alloc] init];
    selectSceneVC.type = @"release";
    selectSceneVC.getIdxAndTitltBlock = ^(NSString * idx, NSString * title) {
        [self changeSceneFrame:title];
        self.fiuId = idx;
    };
    [self.nav pushViewController:selectSceneVC animated:YES];
}

#pragma mark - 
- (NSMutableArray *)recommendTagMarr {
    if (!_recommendTagMarr) {
        _recommendTagMarr = [NSMutableArray array];
    }
    return _recommendTagMarr;
}

- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}
@end
