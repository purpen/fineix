//
//  FiuPeopleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleTableViewCell.h"
#import "TagFlowLayout.h"
#import "UIImage+MultiFormat.h"
#import "HomePageViewController.h"
#import "GoodsBrandViewController.h"

@implementation FiuPeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:cellBgColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headerMarr = [NSMutableArray array];
        self.userIdMarr = [NSMutableArray array];
        [self addSubview:self.peopleView];
        self.widthArr = @[@"30", @"40", @"50"];
    
    }
    return self;
}

#pragma mark - 
- (void)setFiuPeopleData:(NSMutableArray *)model withType:(NSInteger)type {
    [self.headerMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    self.type = type;
    for (NSDictionary * userDict in model) {
        FiuPeopleUser * user = [[FiuPeopleUser alloc] initWithDictionary:userDict];
        [self.headerMarr addObject:user.mediumAvatarUrl];
        [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", user.idField]];
    }
    [self.peopleView reloadData];
}

- (void)setFiuBrandData:(NSMutableArray *)model withType:(NSInteger)type {
    [self.headerMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    self.type = type;
    for (NSDictionary * brandDict in model) {
        FiuBrandRow * brand = [[FiuBrandRow alloc] initWithDictionary:brandDict];
        [self.headerMarr addObject:brand.coverUrl];
        [self.userIdMarr addObject:brand.idField.idField];
    }
    [self.peopleView reloadData];
}

#pragma mark - 头像列表
- (UICollectionView *)peopleView {
    if (!_peopleView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _peopleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155) collectionViewLayout:flowLayout];
        _peopleView.delegate = self;
        _peopleView.dataSource = self;
        _peopleView.backgroundColor = [UIColor colorWithHexString:cellBgColor];
        _peopleView.showsVerticalScrollIndicator = NO;
        [_peopleView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FiuPeopleCollectionViewCell"];
    }
    return _peopleView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userIdMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiuPeopleCollectionViewCell" forIndexPath:indexPath];
    UIImageView * headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.width)];
    [headerImg downloadImage:self.headerMarr[indexPath.row] place:[UIImage imageNamed:@""]];
    cell.layer.cornerRadius = cell.bounds.size.width / 2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.7].CGColor;
    cell.backgroundView = headerImg;
    cell.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = arc4random() % 3;
    CGFloat headerW = [self.widthArr[index] floatValue];
    return CGSizeMake(headerW, headerW);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
        peopleHomeVC.isMySelf = NO;
        peopleHomeVC.type = @2;
        peopleHomeVC.userId = self.userIdMarr[indexPath.row];
        [self.nav pushViewController:peopleHomeVC animated:YES];
    
    } else if (self.type == 1) {
        GoodsBrandViewController * brandVC = [[GoodsBrandViewController alloc] init];
        brandVC.brandId = self.userIdMarr[indexPath.row];
        [self.nav pushViewController:brandVC animated:YES];
    }

}



@end
