//
//  OpenAllTagListTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

typedef void(^GetTagDataBlock)(NSString * title, NSString * ids);

@interface OpenAllTagListTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UILabel             *   titleLab;       //  标题
@pro_strong UICollectionView    *   tagListView;    //  标签

@pro_strong NSMutableArray      *   titleData;
@pro_strong NSMutableArray      *   tagListData;
@pro_strong NSMutableArray      *   tagIdData;

@pro_assign CGFloat                 cellHeight;

@pro_strong GetTagDataBlock         getTagDataBlock;

- (void)getOpenTagListCellHeight:(NSMutableArray *)tag;

- (void)setAllTagListData:(NSString *)title withTagList:(NSMutableArray *)tagList withTagId:(NSMutableArray *)tagId;

@end
