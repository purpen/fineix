//
//  SearchResultsRollView.m
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchResultsRollView.h"
#import "SceneListTableViewCell.h"
#import "SearchSceneTableViewCell.h"

static const NSInteger tableTag = 687;

@implementation SearchResultsRollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
    }
    return self;
}

#pragma mark - 创建搜索结果列表
- (void)setSearchResultTable:(NSArray *)tableArr {
    for (NSUInteger idx = 0; idx < tableArr.count; ++ idx) {
        UITableView * searchTable = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        searchTable.showsVerticalScrollIndicator = NO;
        searchTable.showsHorizontalScrollIndicator = NO;
        searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        searchTable.delegate = self;
        searchTable.dataSource = self;
        
        searchTable.tag = tableTag + idx;
        if (searchTable.tag == tableTag) {
            self.fSceneTable = searchTable;
        } else if (searchTable.tag == tableTag + 1) {
            self.sceneTable = searchTable;
        } else if (searchTable.tag == tableTag + 2) {
            self.userTable = searchTable;
            self.userTable.tableFooterView = [UIView new];
        } else if (searchTable.tag == tableTag + 3) {
            self.goodsTable = searchTable;
        }
        
        [self addSubview:searchTable];
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.fSceneTable) {
        return 1;
    } else if (tableView == self.sceneTable) {
        return 5;
    } else if (tableView == self.userTable) {
        return 5;
    } else if (tableView == self.goodsTable) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.fSceneTable) {
        static NSString * FSceneTablecellId = @"fSceneTablecellId";
        SearchSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FSceneTablecellId];
        if (!cell) {
            cell = [[SearchSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FSceneTablecellId];
        }
        return cell;
        
    } else if (tableView == self.sceneTable) {
        static NSString * SceneTablecellId = @"sceneTablecellId";
        SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SceneTablecellId];
        if (!cell) {
            cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SceneTablecellId];
        }
        [cell setUI];
        return cell;
        
    } else if (tableView == self.userTable) {
        static NSString * UserTablecellId = @"userTablecellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UserTablecellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:UserTablecellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"用户 %zi", indexPath.row];
        return cell;
        
    } else if (tableView == self.goodsTable) {
        static NSString * GoodsTablecellId = @"goodsTablecellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GoodsTablecellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsTablecellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"商品 %zi", indexPath.row];
        return cell;
        
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.fSceneTable) {
        return SCREEN_HEIGHT;
    } else if (tableView == self.sceneTable) {
        return SCREEN_HEIGHT;
    } else if (tableView == self.userTable) {
        return 55;
    } else if (tableView == self.goodsTable) {
        return 290;
    }
    return 0;
}


@end
