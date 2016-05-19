//
//  FBBuyGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBuyGoodsViewController.h"
#import "GoodsSceneCollectionViewCell.h"
#import "FBLoginRegisterViewController.h"
#import "FBGoodsInfoViewController.h"

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
    
    self.num = 1;
    
    __weak __typeof(self) weakSelf = self;
    self.getGoodsModel = ^(GoodsInfoData * model) {
        CGRect buyViewRect = weakSelf.buyView.frame;
        buyViewRect = CGRectMake(0, SCREEN_HEIGHT - 410, SCREEN_WIDTH, 410);
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.buyView.frame = buyViewRect;
        }];

        weakSelf.goodsSkus = [NSMutableArray arrayWithArray:model.skus];
        if (weakSelf.goodsSkus.count == 0) {
            NSDictionary * skuDict = @{@"mode":NSLocalizedString(@"Default", nil),
                                       @"price":[NSString stringWithFormat:@"%.2f",[[model valueForKey:@"salePrice"] floatValue]],
                                       @"quantity":[model valueForKey:@"inventory"],
                                       @"targetId":[NSString stringWithFormat:@"%@", [model valueForKey:@"idField"]]};
            [weakSelf.goodsSkus addObject:skuDict];
        }
        [weakSelf setBuyGoodsData:model];
    };
}

#pragma mark - 设置购买信息
- (void)setBuyGoodsData:(GoodsInfoData *)model {
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", model.salePrice];
    self.chooseNum.text = [NSString stringWithFormat:@"%zi", self.num];
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
        [_buyingBtn addTarget:self action:@selector(buyingBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyingBtn;
}

- (void)buyingBtnClick {
    if ([self isUserLogin]) {
        if (self.skuId.length > 0) {
            NSString * num = [NSString stringWithFormat:@"%zi", self.num];
            NSString * type;
            NSString * targetId;
            if ([[self.goodsSkus valueForKey:@"mode"][0] isEqualToString:NSLocalizedString(@"Default", nil)]) {
                type = @"1";
            } else {
                type = @"2";
            }
            targetId = self.skuId;
            NSDictionary * orderDict = @{@"target_id":targetId, @"type":type, @"n":num};
            [self dismissViewControllerAnimated:YES completion:^{
                self.buyingGoodsBlock(orderDict); 
            }];
        }
       
    } else {
        [self openUserLoginVC];
    }
}

#pragma mark 加入购物车
- (UIButton *)addCarBtn {
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 410 - 44, SCREEN_WIDTH/2, 44)];
        [_addCarBtn setTitle:NSLocalizedString(@"addCarBtn", nil) forState:(UIControlStateNormal)];
        [_addCarBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addCarBtn.backgroundColor = [UIColor colorWithHexString:@"DB9E18"];
        [_addCarBtn addTarget:self action:@selector(addCarBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addCarBtn;
}

- (void)addCarBtnClick {
    if ([self isUserLogin]) {
        if (self.skuId.length > 0) {
            NSString * num = [NSString stringWithFormat:@"%zi", self.num];
            NSString * type;
            NSString * targetId;
            if ([[self.goodsSkus valueForKey:@"mode"][0] isEqualToString:NSLocalizedString(@"Default", nil)]) {
                type = @"1";
            } else {
                type = @"2";
            }
            targetId = self.skuId;
            NSDictionary * orderDict = @{@"target_id":targetId, @"type":type, @"n":num};
            [self dismissViewControllerAnimated:YES completion:^{
                self.addGoodsCarBlock(orderDict);
            }];
        }
        
    } else {
        [self openUserLoginVC];
    }
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
        _goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 15, SCREEN_WIDTH - 120, 35)];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
        _goodsTitle.font = [UIFont systemFontOfSize:14];
        _goodsTitle.numberOfLines = 2;
    }
    return _goodsTitle;
}

#pragma mark  商品价格
- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, SCREEN_WIDTH - 115, 25)];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.goodsChoose.text = [NSString stringWithFormat:@"已选：%@", [self.goodsSkus valueForKey:@"mode"][indexPath.row]];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@", [self.goodsSkus valueForKey:@"price"][indexPath.row]];
    self.quantity = [[self.goodsSkus valueForKey:@"quantity"][indexPath.row] integerValue];
    self.chooseNum.text = @"1";
    self.num = 1;
    if ([[self.goodsSkus valueForKey:@"mode"][indexPath.row] isEqualToString:NSLocalizedString(@"Default", nil)]) {
        self.skuId = [NSString stringWithFormat:@"%@", [self.goodsSkus valueForKey:@"targetId"][indexPath.row]];
    } else {
        self.skuId = [NSString stringWithFormat:@"%@", [self.goodsSkus valueForKey:@"_id"][indexPath.row]];
    }
}

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
        [addBtn addTarget:self action:@selector(addChooseNum:) forControlEvents:(UIControlEventTouchUpInside)];
        self.addBtn = addBtn;
        
        UIButton * subBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 30, 30)];
        subBtn.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        subBtn.layer.borderWidth = 1.0f;
        [subBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [subBtn setTitle:@"－" forState:(UIControlStateNormal)];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [subBtn addTarget:self action:@selector(subChooseNum:) forControlEvents:(UIControlEventTouchUpInside)];
        self.subBtn = subBtn;
        
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

- (void)addChooseNum:(UIButton *)button {
    self.num += 1;
    if (self.num >= self.quantity) {
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        [self showMessage:@"库存不足了～"];
        
    } else if (self.num <= self.quantity) {
        self.subBtn.userInteractionEnabled = YES;
        self.subBtn.backgroundColor = [UIColor whiteColor];
    }
    
    self.chooseNum.text = [NSString stringWithFormat:@"%zi", self.num];
}

- (void)subChooseNum:(UIButton *)button {
    if (self.num > 1) {
        self.num -= 1;
    }
    
    if (self.num <= 1) {
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        [self showMessage:@"不能再少了～"];
        
    } else if (self.num <= self.quantity) {
        self.addBtn.userInteractionEnabled = YES;
        self.addBtn.backgroundColor = [UIColor whiteColor];
    }
    
    self.chooseNum.text = [NSString stringWithFormat:@"%zi", self.num];
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