//
//  THNDomainGoodsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/5/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainGoodsTableViewCell.h"

static NSString *const URLAddGoods = @"/scene_scene/add_product";
static NSString *const URLShareLink = @"/gateway/share_link";

@interface THNDomainGoodsTableViewCell() {
    NSString *_goodsId;
    NSString *_domainId;
    NSString *_linkUrl;
    NSString *_oLinkUrl;
}

@end

@implementation THNDomainGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}
    
- (void)thn_setGoodsItemData:(GoodsRow *)model chooseHidden:(BOOL)hidden domainId:(NSString *)dominId {
    _goodsId = [NSString stringWithFormat:@"%zi", model.idField];
    _domainId = dominId;
    
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.titleLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"销售价：¥%.2f", model.salePrice];
    self.commissionLabel.text = [NSString stringWithFormat:@"佣金：%.2f％", model.commision * 100];
    self.chooseBtn.hidden = hidden;
}

/**
 添加商品

 @param goodsId 商品id
 @param domainId 地盘id
 */
- (void)thn_networkAddGoods:(NSString *)goodsId domainId:(NSString *)domainId {
    self.addGoodsRequest = [FBAPI postWithUrlString:URLAddGoods requestDictionary:@{@"scene_id":domainId, @"product_id":goodsId} delegate:nil];
    [self.addGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            self.chooseBtn.selected = YES;
            self.chooseBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@ --", error);
    }];
}

/**
 获取分享链接
 
 @param goodsId 商品id
 @param domainId 地盘id
 */
- (void)thn_networkGoodsShareUrl:(NSString *)goodsId domainId:(NSString *)domainId {
    self.shareRequest = [FBAPI postWithUrlString:URLShareLink requestDictionary:@{@"id":goodsId, @"type":@"1", @"storage_id":domainId} delegate:self];
    [self.shareRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSDictionary *dict =  [result valueForKey:@"data"];
            _linkUrl = [dict valueForKey:@"url"];
            _oLinkUrl = [dict valueForKey:@"o_url"];
            if (_linkUrl.length > 0) {
                [self thn_copyToClipboard:_linkUrl];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
    }];
}

/**
 复制到粘贴板

 @param url 链接
 */
- (void)thn_copyToClipboard:(NSString *)url {
    if (url.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
        [SVProgressHUD showSuccessWithStatus:@"链接已复制"];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂时无法获取链接"];
    }
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImg.mas_top).with.offset(0);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    
    [self addSubview:self.priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
    }];
    
    [self addSubview:self.commissionLabel];
    [_commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top).with.offset(0);
        make.left.equalTo(_priceLabel.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.linkBtn];
    [_linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        make.top.equalTo(_priceLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.top.equalTo(_linkBtn.mas_top).with.offset(0);
        make.left.equalTo(_linkBtn.mas_right).with.offset(15);
    }];
}
    
- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.clipsToBounds = YES;
        _goodsImg.layer.borderWidth = 0.5f;
        _goodsImg.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:0.8].CGColor;
    }
    return _goodsImg;
}
    
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _titleLabel;
}
    
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }
    return _priceLabel;
}
    
- (UILabel *)commissionLabel {
    if (!_commissionLabel) {
        _commissionLabel = [[UILabel alloc] init];
        _commissionLabel.font = [UIFont systemFontOfSize:12];
        _commissionLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }
    return _commissionLabel;
}

- (UIButton *)linkBtn {
    if (!_linkBtn) {
        _linkBtn = [[UIButton alloc] init];
        _linkBtn.layer.cornerRadius = 2;
        _linkBtn.clipsToBounds = YES;
        _linkBtn.layer.borderWidth = 0.5f;
        _linkBtn.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        _linkBtn.backgroundColor = [UIColor whiteColor];
        [_linkBtn setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:(UIControlStateNormal)];
        _linkBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_linkBtn setTitle:@"推广链接" forState:(UIControlStateNormal)];
        [_linkBtn addTarget:self action:@selector(linkBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _linkBtn;
}

- (void)linkBtnClick:(UIButton *)button {
    if (_goodsId.length && _domainId.length) {
        [self thn_networkGoodsShareUrl:_goodsId domainId:_domainId];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂时无法获取"];
    }
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        _chooseBtn.layer.cornerRadius = 2;
        _chooseBtn.clipsToBounds = YES;
        _chooseBtn.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        [_chooseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_chooseBtn setTitle:@"添加" forState:(UIControlStateNormal)];
        [_chooseBtn setTitle:@"已添加" forState:(UIControlStateSelected)];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseBtn;
}

- (void)chooseBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        if (_goodsId.length && _domainId.length) {
            [self thn_networkAddGoods:_goodsId domainId:_domainId];
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂时无法添加"];
        }
    }
}
    
@end
