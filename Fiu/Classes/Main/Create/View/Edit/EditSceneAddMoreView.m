//
//  EditSceneAddMoreView.m
//  Fiu
//
//  Created by FLYang on 16/6/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditSceneAddMoreView.h"
#import "SearchLocationViewController.h"
#import "AddTagViewController.h"
#import "SelectSceneViewController.h"
#import "AddTagViewController.h"
#import "ChooseTagsCollectionViewCell.h"

@implementation EditSceneAddMoreView

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

//  选择地理位置
- (void)changeLocation {
    SearchLocationViewController * searchLocation = [[SearchLocationViewController alloc] init];
    searchLocation.type = @"edit";
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
    [self.vc presentViewController:searchLocation animated:YES completion:nil];
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

#pragma mark - 添加标签
- (UIView *)addTag {
    if (!_addTag) {
        _addTag = [[UIView alloc] init];
        _addTag.backgroundColor = [UIColor whiteColor];
        
        [_addTag addSubview:self.addTagBtn];
        [_addTag addSubview:self.chooseTagView];
        
        UIButton * goIcon = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
        [goIcon setImage:[UIImage imageNamed:@"entr"] forState:(UIControlStateNormal)];
        [_addTag addSubview:goIcon];
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
    addTagVC.type = @"edit";
    addTagVC.chooseTagsBlock = ^(NSMutableArray * title, NSMutableArray * ids) {
        self.chooseTagMarr = title;
        self.chooseTagIdMarr = ids;
        if (self.chooseTagMarr.count > 0) {
            [self changeTagFrame];
            [self.chooseTagView reloadData];
        }
    };
    
    [self.vc presentViewController:addTagVC animated:YES completion:nil];
    
}

#pragma mark - 选中的标签列表
- (UICollectionView *)chooseTagView {
    if (!_chooseTagView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _chooseTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH,44) collectionViewLayout:flowLayout];
        _chooseTagView.backgroundColor = [UIColor whiteColor];
        _chooseTagView.delegate = self;
        _chooseTagView.dataSource = self;
        _chooseTagView.showsHorizontalScrollIndicator = NO;
        [_chooseTagView registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        lab.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        [self.addTag addSubview:lab];
    }
    return _chooseTagView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chooseTagMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
    [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(tagW + 30, 35);
}


#pragma mark - 添加所属情景
- (UIView *)addScene {
    if (!_addScene) {
        _addScene = [[UIView alloc] init];
        _addScene.backgroundColor = [UIColor whiteColor];
        [_addScene addSubview:self.addSceneBtn];
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        [_addScene addSubview:line];
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
    SelectSceneViewController * selectSceneVC = [[SelectSceneViewController alloc] init];
    selectSceneVC.type = @"edit";
    selectSceneVC.getIdxAndTitltBlock = ^(NSString * idx, NSString * title) {
        [self changeSceneFrame:title];
        self.fiuId = idx;
    };
    [self.vc presentViewController:selectSceneVC animated:YES completion:nil];
}

@end
