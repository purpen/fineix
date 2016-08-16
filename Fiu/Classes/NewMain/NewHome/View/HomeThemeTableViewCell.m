//
//  HomeThemeTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeThemeTableViewCell.h"
#import "HomeThemeCollectionViewCell.h"

static NSString *const themeCollectionCellID = @"ThemeCollectionCellID";

@implementation HomeThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.themeCollectionView];
    }
    return self;
}

- (NSMutableArray *)themeMarr {
    if (!_themeMarr) {
        _themeMarr = [NSMutableArray array];
    }
    return _themeMarr;
}

- (void)setThemeModelArr:(NSMutableArray *)data {
    self.themeMarr = data;
    [self.themeCollectionView reloadData];
}

- (UICollectionView *)themeCollectionView {
    if (!_themeCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _themeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)
                                                  collectionViewLayout:flowLayout];
        _themeCollectionView.backgroundColor = [UIColor whiteColor];
        _themeCollectionView.delegate = self;
        _themeCollectionView.dataSource = self;
        _themeCollectionView.showsHorizontalScrollIndicator = NO;
        [_themeCollectionView registerClass:[HomeThemeCollectionViewCell class]
                 forCellWithReuseIdentifier:themeCollectionCellID];
    }
    return _themeCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.themeMarr.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.themeMarr.count) {
        return CGSizeMake(70, 70);
    } else {
        return CGSizeMake(160, 70);
    }
    return CGSizeMake(50, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:themeCollectionCellID
                                                                                   forIndexPath:indexPath];
    if (self.themeMarr.count) {
        if (indexPath.row == self.themeMarr.count) {
            [cell setMoreTheme];
        } else {
            [cell setThemeDataModel:self.themeMarr[indexPath.row]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.themeMarr.count) {
        [SVProgressHUD showSuccessWithStatus:@"查看更多主题"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"打开主题页"];
    }
}

@end
