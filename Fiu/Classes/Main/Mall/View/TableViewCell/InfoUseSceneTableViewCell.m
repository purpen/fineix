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
#import "GoodsSceneCollectionViewCell.h"

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
    self.sceneList = [NSMutableArray arrayWithArray:[scene valueForKey:@"title"]];
    self.sceneIds = [NSMutableArray arrayWithArray:[scene valueForKey:@"idField"]];
    [self.useSceneRollView reloadData];
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    
    [self addSubview:self.line];
    
    [self addSubview:self.useSceneRollView];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _headerTitle.text = NSLocalizedString(@"userSceneTitle", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _headerTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _headerTitle;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

#pragma mark - 推荐场景
- (UICollectionView *)useSceneRollView {
    if (!_useSceneRollView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(3.5, 15, 3.5, 15);
        
        _useSceneRollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 45) collectionViewLayout:flowLayout];
        _useSceneRollView.dataSource = self;
        _useSceneRollView.delegate = self;
        _useSceneRollView.showsVerticalScrollIndicator = NO;
        _useSceneRollView.showsHorizontalScrollIndicator = NO;
        _useSceneRollView.backgroundColor = [UIColor whiteColor];
        [_useSceneRollView registerClass:[GoodsSceneCollectionViewCell class] forCellWithReuseIdentifier:@"UseSceneRollViewCell"];
    }
    return _useSceneRollView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UseSceneRollViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    cell.title.text = self.sceneList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
    sceneInfoVC.sceneId = self.sceneIds[indexPath.row];
    [self.nav pushViewController:sceneInfoVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat btnLength = [[self.sceneList objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(btnLength + 40, 29);
}


@end
