//
//  THNDomainTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainTableViewCell.h"
#import "THNDomainCollectionViewCell.h"
#import "THNDomainInfoViewController.h"

static NSString *const domainCollectionCellID = @"THNDomainCollectionViewCellId";

@interface THNDomainTableViewCell () {
    NSInteger _type;
}

@end

@implementation THNDomainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.domainCollectionView];
        [_domainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        }];
    }
    return self;
}

- (void)thn_setUserHelpModelArr:(NSMutableArray *)data type:(NSInteger)type {
    _type = type;
    [self.userHelpMarr removeAllObjects];
    [self.userHelpIdMarr removeAllObjects];
    
    self.userHelpMarr = data;
    for (HelpUserRow *model in data) {
        [self.userHelpIdMarr addObject:[NSString stringWithFormat:@"%zi", [model.webUrl integerValue]]];
    }
    [self.domainCollectionView reloadData];
}

- (void)thn_setDomainModelArr:(NSMutableArray *)data type:(NSInteger)type {
    _type = type;
    [self.domainMarr removeAllObjects];
    [self.domainIdMarr removeAllObjects];
    
    self.domainMarr = data;
    for (NiceDomainRow *model in data) {
        [self.domainIdMarr addObject:[NSString stringWithFormat:@"%zi", [model.webUrl integerValue]]];
    }
    [self.domainCollectionView reloadData];
}

- (UICollectionView *)domainCollectionView {
    if (!_domainCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _domainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195)
                                                  collectionViewLayout:flowLayout];
        _domainCollectionView.backgroundColor = [UIColor whiteColor];
        _domainCollectionView.delegate = self;
        _domainCollectionView.dataSource = self;
        _domainCollectionView.showsHorizontalScrollIndicator = NO;
        [_domainCollectionView registerClass:[THNDomainCollectionViewCell class] forCellWithReuseIdentifier:domainCollectionCellID];
    }
    return _domainCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_type == 1) {
        return self.domainMarr.count;
    } else
        return self.userHelpMarr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, 180);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:domainCollectionCellID
                                                                                  forIndexPath:indexPath];
    if (self.domainMarr.count || self.userHelpMarr.count) {
        if (_type == 1) {
            [cell thn_setDomainDataModel:self.domainMarr[indexPath.row]];
        } else {
            [cell thn_setHelpUserDataModel:self.userHelpMarr[indexPath.row]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        THNDomainInfoViewController *domainInfoVC = [[THNDomainInfoViewController alloc] init];
        domainInfoVC.infoId = self.domainIdMarr[indexPath.row];
        [self.nav pushViewController:domainInfoVC animated:YES];
    
    } else {
        self.openUserHelp(self.userHelpIdMarr[indexPath.row]);
    }
}

#pragma mark - 
- (NSMutableArray *)domainMarr {
    if (!_domainMarr) {
        _domainMarr = [NSMutableArray array];
    }
    return _domainMarr;
}

- (NSMutableArray *)domainIdMarr {
    if (!_domainIdMarr) {
        _domainIdMarr = [NSMutableArray array];
    }
    return _domainIdMarr;
}

- (NSMutableArray *)userHelpMarr {
    if (!_userHelpMarr) {
        _userHelpMarr = [NSMutableArray array];
    }
    return _userHelpMarr;
}

- (NSMutableArray *)userHelpIdMarr {
    if (!_userHelpIdMarr) {
        _userHelpIdMarr = [NSMutableArray array];
    }
    return _userHelpIdMarr;
}


@end
