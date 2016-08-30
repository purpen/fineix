//
//  FBRollImages.m
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBRollImages.h"
#import "FBGoodsInfoViewController.h"
#import "THNProjectViewController.h"


@implementation FBRollImages

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgMarr = [NSMutableArray array];
        self.targetIdMarr = [NSMutableArray array];
        self.typeMarr = [NSMutableArray array];
        
        [self addSubview:self.rollImageView];
        [_rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *0.56));
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
    
    if (model.count > 0) {
        for (RollImageRow * row in model) {
            [self.imgMarr addObject:row.coverUrl];
            [self.typeMarr addObject:row.type];
            [self.targetIdMarr addObject:[NSString stringWithFormat:@"%@",row.webUrl]];
        }
        self.rollImageView.imageURLStringsGroup = self.imgMarr;
    }
}

- (void)setGoodsRollimageView:(GoodsInfoData *)model {
    self.rollImageView.imageURLStringsGroup = model.bannerAsset;
}

- (void)setThnGoodsRollImgData:(FBGoodsInfoModelData *)model {
    self.rollImageView.imageURLStringsGroup = model.asset;
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
        NSInteger type = [self.typeMarr[index] integerValue];
        NSString * ids = self.targetIdMarr[index];

        if (type == 8) {

        } else if (type == 9) {
            FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
            goodsInfoVC.goodsID = ids;
            [self.navVC pushViewController:goodsInfoVC animated:YES];
            
        } else if (type == 10) {
            
        } else if (type == 11){
            self.getProjectType(ids);
            
        } else if (type == 1){
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ids]];
            if (isExsit) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ids]];
            }

        }
    }
}

@end
