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
#import "THNProjectGoodsModel.h"
#import <MJExtension.h>
#import "THNProjectGoodsCollectionViewCell.h"

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
    self.goodAry = [THNProjectGoodsModel mj_objectArrayWithKeyValuesArray:model.goodsAry];
    [self.contenView reloadData];
}

-(UICollectionView *)contenView{
    if (!_contenView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _contenView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bottomView.height) collectionViewLayout:layout];
        _contenView.backgroundColor = [UIColor whiteColor];
        _contenView.showsVerticalScrollIndicator = NO;
        _contenView.delegate = self;
        _contenView.dataSource = self;
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

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 135);
}

@end
