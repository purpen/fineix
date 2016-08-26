//
//  HomeThemeTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeThemeTableViewCell.h"
#import "HomeThemeCollectionViewCell.h"
#import "FBSubjectModelRow.h"
#import "THNArticleDetalViewController.h"

static NSString *const themeCollectionCellID = @"ThemeCollectionCellID";

@interface HomeThemeTableViewCell () {
    NSInteger _type;
}

@end

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

- (NSMutableArray *)themeIdMarr {
    if (!_themeIdMarr) {
        _themeIdMarr = [NSMutableArray array];
    }
    return _themeIdMarr;
}

- (NSMutableArray *)themeTypeMarr {
    if (!_themeTypeMarr) {
        _themeTypeMarr = [NSMutableArray array];
    }
    return _themeTypeMarr;
}

- (void)setThemeModelArr:(NSMutableArray *)data {
    self.themeMarr = data;
    for (FBSubjectModelRow *model in data) {
        [self.themeTypeMarr addObject:[NSString stringWithFormat:@"%zi", model.type]];
        [self.themeIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    }
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
    if (self.themeMarr.count == 0) {
        return 0;
    } else {
        return self.themeMarr.count + 1;
    }
    return 0;
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
        _type = [self.themeTypeMarr[indexPath.row] integerValue];
        
        if (_type == 1) {
//            THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
//            
//            [self.nav pushViewController:articleVC animated:YES];
            [SVProgressHUD showSuccessWithStatus:@"文章"];
            
        } else if (_type == 2) {
            [SVProgressHUD showSuccessWithStatus:@"活动"];
            
        } else if (_type == 3) {
            [SVProgressHUD showSuccessWithStatus:@"促销"];
            
        } else if (_type == 4) {
            [SVProgressHUD showSuccessWithStatus:@"新品"];
            
        } else if (_type == 5) {
            [SVProgressHUD showSuccessWithStatus:@"好货"];
            
        }
    }
}

@end
