//
//  THNCuXiaoCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoCollectionViewCell.h"
#import "THNArticleModel.h"
#import <UIImageView+WebCache.h>
#import "Fiu.h"
#import "UIView+FSExtension.h"
#import "THNCuXiaoProductModel.h"
#import <MJExtension.h>
#import "THNProjectGoodsCollectionViewCell.h"
#import "FBGoodsInfoViewController.h"

@interface THNCuXiaoCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
/**  */
@property (nonatomic, strong) NSArray *goodAry;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**  */
@property (nonatomic, strong) UICollectionView *contenView;

@end

NSString *cellId = @"THNProjectGoodsCollectionViewCell";

@implementation THNCuXiaoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bottomView addSubview:self.contenView];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bottomView.height = 0;
    }
    return self;
}

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.titileLabel.text = model.title;
    self.subTitleLabel.text = model.short_title;
    self.goodAry = [THNCuXiaoProductModel mj_objectArrayWithKeyValuesArray:model.products];
    [self.contenView reloadData];
}

-(UICollectionView *)contenView{
    if (!_contenView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        _contenView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bottomView.height) collectionViewLayout:layout];
        _contenView.backgroundColor = [UIColor whiteColor];
        _contenView.showsVerticalScrollIndicator = NO;
        _contenView.scrollEnabled = YES;
        _contenView.delegate = self;
        _contenView.dataSource = self;
        _contenView.showsHorizontalScrollIndicator = NO;
        [_contenView registerNib:[UINib nibWithNibName:@"THNProjectGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    return _contenView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    THNProjectGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = self.goodAry[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 5 * 2) / 3.5, 135);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FBGoodsInfoViewController *vc = [[FBGoodsInfoViewController alloc] init];
    vc.goodsID = ((THNCuXiaoProductModel*)self.goodAry[indexPath.row])._id;
    [self.navi pushViewController:vc animated:YES];
}

@end
