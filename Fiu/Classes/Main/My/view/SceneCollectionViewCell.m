//
//  SceneCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneCollectionViewCell.h"


@implementation SceneCollectionViewCell

-(void)setAllFiuSceneListData:(FiuSceneInfoData *)model{
    [super setAllFiuSceneListData:model];
    self.locationLab.hidden = YES;
    self.locationIcon.hidden = YES;
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}


@end
