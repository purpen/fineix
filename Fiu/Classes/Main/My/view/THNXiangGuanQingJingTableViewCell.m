//
//  THNXiangGuanQingJingTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//


#import "THNXiangGuanQingJingTableViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "UIImageView+WebCache.h"
#import "THNProductDongModel.h"
#import "FBGoodsInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNSenceModel.h"
#import "THNSenecCollectionViewCell.h"

@interface THNXiangGuanQingJingTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) UILabel *biaoTiLabel;
/**  */
@property (nonatomic, assign) BOOL b;

@end

@implementation THNXiangGuanQingJingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THNXIANGGuanQingJingTableViewCell]) {
        self.b = NO;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * SCREEN_HEIGHT);
        flowlayout.minimumLineSpacing = 15.0f;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
        self.collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(40);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        }];
         [self.collectionView registerNib:[UINib nibWithNibName:@"THNSenecCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.collectionView.mas_top).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(40);
        }];
        
        self.biaoTiLabel = [[UILabel alloc] init];
        self.biaoTiLabel.font = [UIFont systemFontOfSize:13];
        self.biaoTiLabel.text = @"相关情境";
        self.biaoTiLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.biaoTiLabel];
        [_biaoTiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(17);
        }];
    }
    return self;
}

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(void)setString:(NSString *)string{
    _string = string;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:@{
                                                                                          @"page" : @(1),
                                                                                          @"size" : @(6),
                                                                                          @"category_ids" : string,
                                                                                          @"stick" : @(1),
                                                                                          @"sort" : @(1)
                                                                                          } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rows = result[@"data"][@"rows"];
        if (rows.count == 6) {
            [self.modelAry removeAllObjects];
            for (NSDictionary * sceneDic in rows) {
                THNSenceModel * homeSceneModel = [THNSenceModel mj_objectWithKeyValues:sceneDic];
                [self.modelAry addObject:homeSceneModel];
            }
            if (self.b == NO) {
                [self.collectionView reloadData];
                self.b = YES;
            }
        }
    } failure:nil];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2, 15, 1, 15);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    THNSenecCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"allSceneCollectionViewCellID" forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FBAPI *api = [[FBAPI alloc] init];
    NSString *uuid = [api uuid];
    THNSenceModel *model = self.modelAry[indexPath.row];
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                           @"id" : model._id,
                                                                                           @"uuid" : uuid,
                                                                                           @"app_type" : @2
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result[@"success"] isEqualToNumber:@1]) {
            THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
            vc.sceneDetalId = model._id;
            [self.nav pushViewController:vc animated:YES];
        }
    } failure:nil];
}

@end
