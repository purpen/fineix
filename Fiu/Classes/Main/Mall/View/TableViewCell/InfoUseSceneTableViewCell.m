//
//  InfoUseSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoUseSceneTableViewCell.h"
#import "SceneInfoData.h"
#import "SceneInfoViewController.h"
#import "SceneCollectionViewCell.h"

@implementation InfoUseSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

- (void)setGoodsScene:(NSMutableArray *)scene {
    self.sceneList = scene;
    [self.useSceneRollView reloadData];
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    
    [self addSubview:self.line];
    
    [self addSubview:self.useSceneRollView];
    
    UILabel * botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ((SCREEN_WIDTH - 15)/2 * 1.77) + 55, SCREEN_WIDTH, 5)];
    botLine.backgroundColor = [UIColor colorWithHexString:cellBgColor];
    [self addSubview:botLine];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _headerTitle.text = NSLocalizedString(@"userSceneTitle", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        if (IS_iOS9) {
            _headerTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_GoodsTitle];
        } else {
            _headerTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        }
    }
    return _headerTitle;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

#pragma mark - 推荐场景
- (UICollectionView *)useSceneRollView {
    if (!_useSceneRollView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _useSceneRollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, (SCREEN_WIDTH - 15)/2 * 1.77) collectionViewLayout:flowLayout];
        _useSceneRollView.dataSource = self;
        _useSceneRollView.delegate = self;
        _useSceneRollView.showsVerticalScrollIndicator = NO;
        _useSceneRollView.showsHorizontalScrollIndicator = NO;
        _useSceneRollView.backgroundColor = [UIColor whiteColor];
        [_useSceneRollView registerClass:[SceneCollectionViewCell class] forCellWithReuseIdentifier:@"UseSceneRollViewCell"];
    }
    return _useSceneRollView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UseSceneRollViewCell" forIndexPath:indexPath];
    if (self.sceneList.count) {
        [cell setAllFiuSceneListData:self.sceneList[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
    sceneInfoVC.sceneId = [NSString stringWithFormat:@"%zi", [[self.sceneList[indexPath.row] valueForKey:@"idField"] integerValue]];
    [self.nav pushViewController:sceneInfoVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
}

- (NSMutableArray *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}

@end
