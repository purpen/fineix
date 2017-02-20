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
    }
    return self;
}

- (void)thn_setUserHelpModelArr:(NSMutableArray *)data type:(NSInteger)type {
    _type = type;
    [self.userHelpMarr removeAllObjects];
    [self.userHelpIdMarr removeAllObjects];
    
    self.userHelpMarr = data;
    for (HelpUserRow *model in data) {
        [self.userHelpIdMarr addObject:model.webUrl];
    }
    [self.domainCollectionView reloadData];
}

- (void)thn_setDomainModelArr:(NSMutableArray *)data type:(NSInteger)type {
    _type = type;
    [self.domainMarr removeAllObjects];
    [self.domainIdMarr removeAllObjects];
    
    self.domainMarr = data;
    for (NiceDomainRow *model in data) {
        [self.domainIdMarr addObject:model.webUrl];
    }
    [self.domainCollectionView reloadData];
}

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

- (UICollectionView *)domainCollectionView {
    if (!_domainCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _domainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.48)
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
    return CGSizeMake(SCREEN_WIDTH * 0.85, SCREEN_WIDTH * 0.48);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:domainCollectionCellID
                                                                                  forIndexPath:indexPath];
    if (_type == 1) {
        if (self.domainMarr.count) {
            [cell thn_setDomainDataModel:self.domainMarr[indexPath.row]];
        }
        
    } else {
        if (self.userHelpMarr.count) {
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
        [SVProgressHUD showInfoWithStatus:@"打开新人专区"];
    }
}

@end
