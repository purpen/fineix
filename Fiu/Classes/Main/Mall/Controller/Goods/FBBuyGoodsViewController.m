//
//  FBBuyGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBuyGoodsViewController.h"
#import "GoodsSceneCollectionViewCell.h"

@interface FBBuyGoodsViewController ()

@end

@implementation FBBuyGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.buyView];
    
    __weak __typeof(self) weakSelf = self;
    self.getGoodsModel = ^(GoodsInfoData * model) {
        CGRect buyViewRect = weakSelf.buyView.frame;
        buyViewRect = CGRectMake(0, SCREEN_HEIGHT - 410, SCREEN_WIDTH, 410);
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.buyView.frame = buyViewRect;
        }];
        
        [weakSelf setBuyGoodsData:model];
        weakSelf.goodsSkus = [NSMutableArray arrayWithArray:model.skus];
    };
}

#pragma mark - 设置购买信息
- (void)setBuyGoodsData:(GoodsInfoData *)model {
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", model.salePrice];
    [self.goodsColorView reloadData];
}

#pragma mark - 取消购买
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 410)];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 购买视图
- (UIView *)buyView {
    if (!_buyView) {
        _buyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 410)];
        _buyView.backgroundColor = [UIColor whiteColor];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, SCREEN_WIDTH - 30, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        
        UILabel * colorLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, SCREEN_WIDTH - 30, 20)];
        colorLab.text = @"颜色分类";
        colorLab.font = [UIFont systemFontOfSize:16];
        
        [_buyView addSubview:self.buyingBtn];
        [_buyView addSubview:self.addCarBtn];
        [_buyView addSubview:self.goodsImg];
        [_buyView addSubview:self.goodsTitle];
        [_buyView addSubview:self.goodsPrice];
        [_buyView addSubview:self.goodsChoose];
        [_buyView addSubview:lineLab];
        [_buyView addSubview:colorLab];
        [_buyView addSubview:self.goodsColorView];
        [_buyView addSubview:self.chooseNumView];
        [_chooseNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 80));
            make.top.equalTo(_goodsColorView.mas_bottom).with.offset(10);
            make.left.equalTo(_buyView.mas_left).with.offset(15);
        }];
    }
    return _buyView;
}

#pragma mark 立即购买
- (UIButton *)buyingBtn {
    if (!_buyingBtn) {
        _buyingBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 410 - 44, SCREEN_WIDTH/2, 44)];
        [_buyingBtn setTitle:NSLocalizedString(@"buyingBtn", nil) forState:(UIControlStateNormal)];
        [_buyingBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _buyingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _buyingBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
    }
    return _buyingBtn;
}

#pragma mark 加入购物车
- (UIButton *)addCarBtn {
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 410 - 44, SCREEN_WIDTH/2, 44)];
        [_addCarBtn setTitle:NSLocalizedString(@"addCarBtn", nil) forState:(UIControlStateNormal)];
        [_addCarBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addCarBtn.backgroundColor = [UIColor colorWithHexString:@"DB9E18"];
    }
    return _addCarBtn;
}

#pragma mark  商品图片
- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    }
    return _goodsImg;
}

#pragma mark  商品标题
- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 15, SCREEN_WIDTH - 120, 40)];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
        _goodsTitle.font = [UIFont systemFontOfSize:14];
        _goodsTitle.numberOfLines = 2;
    }
    return _goodsTitle;
}

#pragma mark  商品价格
- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, SCREEN_WIDTH - 120, 25)];
        _goodsPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsPrice.font = [UIFont systemFontOfSize:14];
        _goodsPrice.numberOfLines = 2;
    }
    return _goodsPrice;
}

#pragma mark  已选颜色
- (UILabel *)goodsChoose {
    if (!_goodsChoose) {
        _goodsChoose = [[UILabel alloc] initWithFrame:CGRectMake(105, 80, SCREEN_WIDTH - 120, 15)];
        _goodsChoose.textColor = [UIColor colorWithHexString:titleColor];
        _goodsChoose.font = [UIFont systemFontOfSize:12];
        _goodsChoose.numberOfLines = 2;
    }
    return _goodsChoose;
}

#pragma mark - 颜色分类
- (UICollectionView *)goodsColorView {
    if (!_goodsColorView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 5.0f;
        
        _goodsColorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
        _goodsColorView.dataSource = self;
        _goodsColorView.delegate = self;
        _goodsColorView.showsVerticalScrollIndicator = NO;
        _goodsColorView.showsHorizontalScrollIndicator = NO;
        _goodsColorView.backgroundColor = [UIColor whiteColor];
        [_goodsColorView registerClass:[GoodsSceneCollectionViewCell class] forCellWithReuseIdentifier:@"goodsColorViewCell"];
        
    }
    return _goodsColorView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsSkus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsColorViewCell" forIndexPath:indexPath];
    cell.title.text = [self.goodsSkus valueForKey:@"mode"][indexPath.row];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
//    sceneInfoVC.sceneId = self.sceneIds[indexPath.row];
//    [self.nav pushViewController:sceneInfoVC animated:YES];
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat btnLength = [[[self.goodsSkus valueForKey:@"mode"] objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(btnLength + 40, 30);
}

#pragma mark - 选择数量视图
- (UIView *)chooseNumView {
    if (!_chooseNumView) {
        _chooseNumView = [[UIView alloc] init];
        _chooseNumView.backgroundColor = [UIColor whiteColor];
        
        UILabel * chooseNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 30, 20)];
        chooseNumTitle.text = @"数量";
        chooseNumTitle.font = [UIFont systemFontOfSize:16];
        
        UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 30, 30)];
        addBtn.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        addBtn.layer.borderWidth = 1.0f;
        [addBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [addBtn setTitle:@"＋" forState:(UIControlStateNormal)];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBtn addTarget:self action:@selector(addChooseNum) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIButton * subBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 30, 30)];
        subBtn.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        subBtn.layer.borderWidth = 1.0f;
        [subBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [subBtn setTitle:@"－" forState:(UIControlStateNormal)];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [subBtn addTarget:self action:@selector(subChooseNum) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        
        [_chooseNumView addSubview:lineLab];
        [_chooseNumView addSubview:chooseNumTitle];
        [_chooseNumView addSubview:addBtn];
        [_chooseNumView addSubview:self.chooseNum];
        [_chooseNumView addSubview:subBtn];
        
    }
    return _chooseNumView;
}

- (void)addChooseNum {
    
}

- (void)subChooseNum {
    
}

#pragma mark 数量
- (UILabel *)chooseNum {
    if (!_chooseNum) {
        _chooseNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 80, 30)];
        _chooseNum.text = @"1";
        _chooseNum.textColor = [UIColor colorWithHexString:titleColor];
        _chooseNum.font = [UIFont systemFontOfSize:14];
        _chooseNum.textAlignment = NSTextAlignmentCenter;
        _chooseNum.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        _chooseNum.layer.borderWidth = 0.5f;
    }
    return _chooseNum;
}


@end
