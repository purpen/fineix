//
//  FBBuyGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBuyGoodsViewController.h"
#import "GoodsSceneCollectionViewCell.h"
#import "THNLoginRegisterViewController.h"
#import "FBGoodsInfoViewController.h"
#import "TagFlowLayout.h"

@interface FBBuyGoodsViewController () {
    NSString *_goodsDefaultImage;
}

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
    self.getGoodsModel = ^(FBGoodsInfoModelData * model) {
        CGRect buyViewRect = weakSelf.buyView.frame;
        buyViewRect = CGRectMake(0, SCREEN_HEIGHT - 410, SCREEN_WIDTH, 410);
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.buyView.frame = buyViewRect;
        }];
        
        [weakSelf setBuyGoodsData:model];
        
        if (model.skus.count == 0) {
            NSDictionary * skuDict = @{@"mode":NSLocalizedString(@"Default", nil),
                                       @"price":[NSString stringWithFormat:@"%zi",[[model valueForKey:@"salePrice"] integerValue]],
                                       @"quantity":[NSString stringWithFormat:@"%zi",[[model valueForKey:@"inventory"] integerValue]],
                                       @"idField":[NSString stringWithFormat:@"%zi", [[model valueForKey:@"idField"] integerValue]]};
            [weakSelf.goodsSkus addObject:skuDict];
            
        } else {
            weakSelf.goodsSkus = [NSMutableArray arrayWithArray:model.skus];
        }
        
        [weakSelf thn_getGoodsSkuImage:weakSelf.goodsSkus];
        
        //  没有颜色分类，默认选中第一个
        if (weakSelf.goodsSkus.count == 1) {
            [weakSelf chooseDefaultColor];
        }
    };
}

#pragma mark - 设置购买信息
- (void)setBuyGoodsData:(FBGoodsInfoModelData *)model {
    _goodsDefaultImage = model.coverUrl;
    
    [self thn_setGoodsImage:model.coverUrl];
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%zi", model.salePrice];
    self.chooseNum.text = [NSString stringWithFormat:@"%zi", self.num];
    [self.goodsColorView reloadData];
}

//  设置商品图片
- (void)thn_setGoodsImage:(NSString *)goodsImage {
     [self.goodsImg downloadImage:goodsImage place:[UIImage imageNamed:@""]];
}

#pragma mark - 保存每个SKU的图片
- (void)thn_getGoodsSkuImage:(NSMutableArray *)skus {
    if (skus.count > 1) {
        for (FBGoodsInfoModelSku *skuModel in skus) {
            if (skuModel.coverUrl.length == 0) {
                skuModel.coverUrl = _goodsDefaultImage;
            }
            [self.goodsSkusImage addObject:skuModel.coverUrl];
        }
    }
}

- (void)chooseDefaultColor {
    [self.goodsColorView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      animated:YES
                                scrollPosition:(UICollectionViewScrollPositionNone)];
    
    self.goodsChoose.text = [NSString stringWithFormat:@"已选：%@", [self.goodsSkus valueForKey:@"mode"][0]];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@", [self.goodsSkus valueForKey:@"price"][0]];
    self.quantity = [[self.goodsSkus valueForKey:@"quantity"][0] integerValue];
    
    if (self.quantity == 0) {
        [self NotCanBuy];
    } else {
        [self IsCanBuy];
        self.chooseNum.text = @"1";
    }
    
    self.num = 1;

    if ([[self.goodsSkus valueForKey:@"mode"][0] isEqualToString:NSLocalizedString(@"Default", nil)]) {
        self.skuId = [NSString stringWithFormat:@"%zi", [[self.goodsSkus valueForKey:@"idField"][0] integerValue]];
    } else {
        self.skuId = [NSString stringWithFormat:@"%zi", [[self.goodsSkus valueForKey:@"idField"][0] integerValue]];
    }
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
    
        [_buyView addSubview:self.sureBtn];
        [_buyView addSubview:self.closeBtn];
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

#pragma mark - 确定
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 410 - 44, SCREEN_WIDTH, 44)];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

- (void)sureBtnClick:(UIButton *)button {
    if (self.buyState == 1) {
        [self addCarBtnClick];
    } else if (self.buyState == 2) {
        [self buyingBtnClick];
    }
}

#pragma mark - 关闭视图
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 410)];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40)];
        [_closeBtn setImage:[UIImage imageNamed:@"jifen_close"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 立即购买
- (void)buyingBtnClick {
    if ([self isUserLogin]) {
        if (self.skuId.length > 0) {
            NSString * num = [NSString stringWithFormat:@"%zi", self.num];
            NSString * type = @"2";
            NSString * targetId;
            targetId = self.skuId;
            if (self.storageId.length == 0) {
                self.storageId = @"";
            }
            NSDictionary * orderDict = @{@"target_id":targetId, @"type":type, @"n":num, @"referral_code":[self thn_getGoodsReferralCode], @"storage_id":self.storageId};
            [self dismissViewControllerAnimated:YES completion:^{
                self.buyingGoodsBlock(orderDict); 
            }];
            
        } else {
            [self showMessage:@"请选择喜欢的颜色分类"];
        }
       
    } else {
        [self openUserLoginVC];
    }
}

#pragma mark - 加入购物车
- (void)addCarBtnClick {
    if ([self isUserLogin]) {
        if (self.skuId.length > 0) {
            NSString * num = [NSString stringWithFormat:@"%zi", self.num];
            NSString * type = @"2";
            NSString * targetId;
            targetId = self.skuId;
            if (self.storageId.length == 0) {
                self.storageId = @"";
            }
            NSDictionary *orderDict = @{@"target_id":targetId, @"type":type, @"n":num, @"referral_code":[self thn_getGoodsReferralCode], @"storage_id":self.storageId};
            [self dismissViewControllerAnimated:YES completion:^{
                self.addGoodsCarBlock(orderDict);
            }];
        
        } else {
            [self showMessage:@"请选择喜欢的颜色分类"];
        }
        
    } else {
        [self openUserLoginVC];
    }
}

#pragma mark  商品图片
- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
        _goodsImg.layer.borderWidth = 0.5f;
        _goodsImg.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:0.7].CGColor;
    }
    return _goodsImg;
}

#pragma mark  商品标题
- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 15, SCREEN_WIDTH - 140, 35)];
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
        _goodsChoose.textColor = [UIColor colorWithHexString:@"#222222"];
        _goodsChoose.font = [UIFont systemFontOfSize:12];
        _goodsChoose.text = @"";
        _goodsChoose.numberOfLines = 2;
    }
    return _goodsChoose;
}

#pragma mark - 颜色分类
- (UICollectionView *)goodsColorView {
    if (!_goodsColorView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        
        _goodsColorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
        _goodsColorView.dataSource = self;
        _goodsColorView.delegate = self;
        _goodsColorView.showsVerticalScrollIndicator = NO;
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
    
    if (self.quantity == 0) {
        [self NotCanBuy];
    } else {
        [self IsCanBuy];
        self.chooseNum.text = @"1";
    }
    self.num = 1;
    if ([[self.goodsSkus valueForKey:@"mode"][indexPath.row] isEqualToString:NSLocalizedString(@"Default", nil)]) {
        self.skuId = [NSString stringWithFormat:@"%zi", [[self.goodsSkus valueForKey:@"idField"][indexPath.row] integerValue]];
    } else {
        self.skuId = [NSString stringWithFormat:@"%zi", [[self.goodsSkus valueForKey:@"idField"][indexPath.row] integerValue]];
    }
    
    if (self.goodsSkusImage.count) {
         [self thn_setGoodsImage:self.goodsSkusImage[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat btnLength = [[[self.goodsSkus valueForKey:@"mode"] objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(320, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    return CGSizeMake(btnLength + 40, 30);
}

- (void)NotCanBuy {
    [self showMessage:@"库存不足了"];
    
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    self.sureBtn.userInteractionEnabled = NO;
    
    self.subBtn.userInteractionEnabled = NO;
    self.addBtn.userInteractionEnabled = NO;
}

- (void)IsCanBuy {
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
    self.sureBtn.userInteractionEnabled = YES;
    
    self.subBtn.userInteractionEnabled = YES;
    self.addBtn.userInteractionEnabled = YES;
}

#pragma mark - 选择数量视图
- (UIView *)chooseNumView {
    if (!_chooseNumView) {
        _chooseNumView = [[UIView alloc] init];
        _chooseNumView.backgroundColor = [UIColor whiteColor];
        
        UILabel * chooseNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 30, 20)];
        chooseNumTitle.text = @"数量";
        chooseNumTitle.font = [UIFont systemFontOfSize:16];
        
        UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 30, 30)];
        addBtn.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        addBtn.layer.borderWidth = 1.0f;
        [addBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [addBtn setTitle:@"＋" forState:(UIControlStateNormal)];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBtn addTarget:self action:@selector(addChooseNum:) forControlEvents:(UIControlEventTouchUpInside)];
        self.addBtn = addBtn;
        
        UIButton * subBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 30, 30)];
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
    if ([self.goodsChoose.text isEqualToString:@""]) {
        [self showMessage:@"请先选择喜欢的颜色分类吧"];
        
    } else {
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
}

- (void)subChooseNum:(UIButton *)button {
    if ([self.goodsChoose.text isEqualToString:@""]) {
        [self showMessage:@"请先选择喜欢的颜色分类吧～"];
        
    } else {
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

#pragma mark -
- (NSMutableArray *)goodsSkus {
    if (!_goodsSkus) {
        _goodsSkus = [NSMutableArray array];
    }
    return _goodsSkus;
}

- (NSMutableArray *)goodsSkusImage {
    if (!_goodsSkusImage) {
        _goodsSkusImage = [NSMutableArray array];
    }
    return _goodsSkusImage;
}

@end
