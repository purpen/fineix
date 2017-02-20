//
//  THNDomainInfoFooter.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoFooter.h"
#import "MallListGoodsCollectionViewCell.h"
#import "THNBusinessInfoTableViewCell.h"

static NSString *const goodsListCellId = @"MallListGoodsCollectionViewCellId";
static NSString *const infoCellId = @"THNBusinessInfoTableViewCellId";
static NSString *const commentCellId = @"commentCellId";

static CGFloat const newGoodsCellHeight = ((SCREEN_WIDTH - 45)/2)*1.21;
static NSInteger const tableViewTag = 2421;
static NSInteger const tableViewCount = 2;

@interface THNDomainInfoFooter () {
    BOOL _onFooter;
    NSArray *_leftArr;
    NSArray *_rightArr;
}

@end

@implementation THNDomainInfoFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _leftArr = @[@"营业时间：", @"联系电话：", @"商家标签："];
        _rightArr = @[@"9:00 —— 18:00", @"010-83921988", @"民宿"];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setTableViewData:(id)sceneData goods:(id)goodsData info:(id)infoData {
    NSLog(@"==== 给table赋值");
}

- (void)thn_tableViewStartRolling:(BOOL)roll {
    self.sceneTable.scrollEnabled = roll;
    self.goodsList.scrollEnabled = roll;
    self.infoTable.scrollEnabled = roll;
}

- (void)setViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self addSubview:self.menuView];
    
    [self addSubview:self.rollView];
    [_rollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(44);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self creatTableViewCount:tableViewCount];
    [self.rollView addSubview:self.goodsList];
    [_goodsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(_rollView.mas_left).with.offset(SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).with.offset(50);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (SGTopTitleView *)menuView {
    if (!_menuView) {
        _menuView = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _menuView.staticTitleArr = @[@"相关情景", @"相关产品", @"商家信息"];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.delegate_SG = self;
        [_menuView staticTitleLabelSelecteded:_menuView.allTitleLabel[0]];
    }
    return _menuView;
}

- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    self.rollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
}


- (UIScrollView *)rollView {
    if (!_rollView) {
        _rollView = [[UIScrollView alloc] init];
        _rollView.contentSize = CGSizeMake(SCREEN_WIDTH * tableViewCount, 0);
        _rollView.pagingEnabled = YES;
        _rollView.showsVerticalScrollIndicator = NO;
        _rollView.showsHorizontalScrollIndicator = NO;
        _rollView.bounces = NO;
        _rollView.scrollEnabled = NO;
    }
    return _rollView;
}

- (UILabel *)backLabel {
    if (!_backLabel) {
        
    }
    return _backLabel;
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, newGoodsCellHeight);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                        collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.goodsListMarr.count;
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId
                                                                                       forIndexPath:indexPath];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
//    goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
//    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (UIView *)mapView {
    if (!_mapView) {
        _mapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        _mapView.backgroundColor = [UIColor grayColor];
    }
    return _mapView;
}

- (UIView *)commentView {
    if (!_commentView) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _commentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5, 100, 15)];
        leftLabel.text = @"用户评价";
        leftLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        [_commentView addSubview:leftLabel];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105, 10, 90, 30)];
        [sendButton setTitle:@"发表评价" forState:(UIControlStateNormal)];
        sendButton.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        [sendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        sendButton.layer.cornerRadius = 3;
        [_commentView addSubview:sendButton];
    }
    return _commentView;
}

- (void)creatTableViewCount:(NSInteger)count {
    for (NSInteger idx = 0; idx < count; ++ idx) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * 2) * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                              style:(UITableViewStyleGrouped)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled = NO;
        tableView.tag = tableViewTag + idx;
        if (tableView.tag == tableViewTag + 1) {
            tableView.tableHeaderView = self.mapView;
        }
        [self initTableViewIndex:tableView];
        
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 30)];
        backLabel.font = [UIFont systemFontOfSize:12];
        backLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.text = @"继续下拉返回详情";
        [tableView addSubview:backLabel];
        
        [self.rollView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.left.equalTo(self.rollView.mas_left).with.offset((SCREEN_WIDTH * 2) * idx);
            make.top.equalTo(self.mas_top).with.offset(50);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.infoTable) {
        return 2;
    } else if (tableView == self.sceneTable) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.sceneTable) {
        return 10;
    } else if (tableView == self.infoTable) {
        if (section == 0) {
            return 3;
        } else
            return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTable) {
        if (indexPath.section == 0) {
            THNBusinessInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
            cell = [[THNBusinessInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
            [cell thn_setBusinessInfoData:_leftArr[indexPath.row] right:_rightArr[indexPath.row]];
            if (indexPath.row == 2) {
                cell.line.hidden = YES;
            }
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentCellId];
        return cell;
        
    } else if (tableView == self.sceneTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        cell.textLabel.text = [NSString stringWithFormat:@"%zi", indexPath.row];
        return cell;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.infoTable) {
        if (section == 0) {
            return 0.01;
        } else
            return 50;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.infoTable) {
        if (section == 1) {
            return self.commentView;
        }
    }
    return [UIView new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTable) {
        if (indexPath.section == 0) {
            return 35;
        } else {
            return 100;
        }
        
    } else if (tableView == self.sceneTable) {
        return 120;
    
    }
    return 0.01f;
}

#pragma mark - 判断滑动到顶部继续下拉返回
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.sceneTable || scrollView == self.goodsList || scrollView == self.infoTable) {
        NSInteger contentOffset = scrollView.contentOffset.y;
        if (contentOffset < -SCREEN_HEIGHT * 0.13) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableOnHeader" object:nil];
        }
    }
}

- (void)initTableViewIndex:(UITableView *)table {
    switch (table.tag) {
        case tableViewTag:
            self.sceneTable = table;
            break;
        case tableViewTag + 1:
            self.infoTable = table;
            break;
    }
}

@end
