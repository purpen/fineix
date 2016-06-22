//
//  FBRollImages.m
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBRollImages.h"
#import "SceneInfoViewController.h"
#import "FiuSceneViewController.h"
#import "GoodsInfoViewController.h"
#import "ProjectViewController.h"


@implementation FBRollImages

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgMarr = [NSMutableArray array];
        self.targetIdMarr = [NSMutableArray array];
        self.typeMarr = [NSMutableArray array];
        
        [self addSubview:self.rollImageView];
        [_rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, Banner_height));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
    }
    return self;
}

- (void)setRollimageView:(NSMutableArray *)model {
    [self.imgMarr removeAllObjects];
    [self.typeMarr removeAllObjects];
    [self.targetIdMarr removeAllObjects];
    
    for (RollImageRow * row in model) {
        [self.imgMarr addObject:row.coverUrl];
        [self.typeMarr addObject:row.type];
        [self.targetIdMarr addObject:[NSString stringWithFormat:@"%zi",row.webUrl]];
    }
    self.rollImageView.imageURLStringsGroup = self.imgMarr;
}

- (void)setGoodsRollimageView:(GoodsInfoData *)model {
    self.rollImageView.imageURLStringsGroup = model.bannerAsset;
}

- (void)setThnGoodsRollImgData:(GoodsInfoData *)model {
    self.rollImageView.imageURLStringsGroup = model.thnAsset;
}

- (SDCycleScrollView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[SDCycleScrollView alloc] init];
        _rollImageView.autoScrollTimeInterval = 3;
        _rollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _rollImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _rollImageView.placeholderImage = [UIImage imageNamed:@"Defaul_Bg_420"];
        _rollImageView.delegate = self;
    }
    return _rollImageView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.typeMarr.count > 0) {
        NSString * type = self.typeMarr[index];
        NSString * ids = self.targetIdMarr[index];
        if ([type isEqualToString:@"8"]) {
            SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
            sceneInfoVC.sceneId = ids;
            [self.navVC pushViewController:sceneInfoVC animated:YES];
            
        } else if ([type isEqualToString:@"9"]) {
            GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
            goodsInfoVC.goodsID = ids;
            [self.navVC pushViewController:goodsInfoVC animated:YES];
            
        } else if ([type isEqualToString:@"10"]) {
            FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
            fiuSceneVC.fiuSceneId = ids;
            [self.navVC pushViewController:fiuSceneVC animated:YES];
        }else if ([type isEqualToString:@"11"]){
            ProjectViewController *vc = [[ProjectViewController alloc] init];
            vc.projectId = ids;
            [self.navVC pushViewController:vc animated:YES];
        }
    }
}

@end
