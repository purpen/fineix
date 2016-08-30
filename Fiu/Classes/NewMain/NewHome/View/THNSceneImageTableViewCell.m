//
//  THNSceneImageTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageTableViewCell.h"
#import "FBGoodsInfoViewController.h"
#import "UILable+Frame.h"
#import "UIImage+Helper.h"
#import "THNSceneImageViewController.h"

@interface THNSceneImageTableViewCell () {
    NSString *_titleStr;
    NSString *_suTitleStr;
    NSString *_image;
    NSInteger _type;
}

@end

@implementation THNSceneImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel
- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel {
    self.tagDataMarr = [NSMutableArray arrayWithArray:sceneModel.product];
    self.goodsIds = [NSMutableArray arrayWithArray:[sceneModel.product valueForKey:@"idField"]];
    self.goodsType = [NSMutableArray arrayWithArray:[sceneModel.product valueForKey:@"type"]];
    if (self.tagDataMarr.count) {
        [self setUserTagBtn];
    }
    
    _image = sceneModel.coverUrl;
    [self.sceneImage sd_setImageWithURL:[NSURL URLWithString:sceneModel.coverUrl]
                               forState:(UIControlStateNormal)
                       placeholderImage:[UIImage imageNamed:@""]];
    
    if (sceneModel.title.length == 0 || [sceneModel.title isKindOfClass:[NSNull class]]) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;

    } else if (sceneModel.title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", [sceneModel.title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString *suTitleStr = [NSString stringWithFormat:@"    %@  ", [sceneModel.title substringFromIndex:10]];
        self.suTitle.text = suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:suTitleStr].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
            make.bottom.equalTo(self.mas_bottom).with.offset(-48);
        }];
        
    } else if (sceneModel.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr].width));
        }];
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - 创建用户添加商品按钮
- (void)setUserTagBtn {
    self.userTagMarr = [NSMutableArray array];
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString * title = [self.tagDataMarr[idx] valueForKey:@"title"];
        NSInteger loc = [[self.tagDataMarr[idx] valueForKey:@"loc"] integerValue];
        
        UserGoodsTag * userTag = [[UserGoodsTag alloc] init];
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        userTag.isMove = NO;
        CGFloat width = [userTag.title boundingRectWithSize:CGSizeMake(320, 0)].width;
        if (width*1.3 > SCREEN_WIDTH/2) {
            width = SCREEN_WIDTH/2;
        } else {
            width = [userTag.title boundingRectWithSize:CGSizeMake(320, 0)].width * 1.3;
        }
        
        if (loc == 1) {
            userTag.frame = CGRectMake((btnX*SCREEN_WIDTH) - ((width+25)-18), btnY*SCREEN_WIDTH-32, width+25, 32);
        } else if (loc == 2) {
            userTag.frame = CGRectMake(btnX*SCREEN_WIDTH-44, btnY*SCREEN_WIDTH-32, width+25, 32);
        }
        [userTag thn_setSceneImageUserGoodsTagLoc:loc];

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoodsInfo:)];
        [userTag addGestureRecognizer:tapGesture];
        
        [self addSubview:userTag];
        [self.userTagMarr addObject:userTag];
    }
}

- (void)openGoodsInfo:(UITapGestureRecognizer *)tapGesture {
    NSInteger index = [self.userTagMarr indexOfObject:tapGesture.view];
    _type = [self.goodsType[index] integerValue];

    if (_type == 2) {
        FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIds[index];
        [self.nav pushViewController:goodsInfoVC animated:YES];
        
    } else if (_type == 1) {
        [SVProgressHUD showSuccessWithStatus:@"用户自建的商品"];
    }
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.sceneImage];
    [_sceneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
}

#pragma mark - init
- (UIButton *)sceneImage {
    if (!_sceneImage) {
        _sceneImage = [[UIButton alloc] init];
        _sceneImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImage.imageView.clipsToBounds = YES;
        [_sceneImage addTarget:self action:@selector(sceneImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sceneImage;
}

- (void)sceneImageClick:(UIButton *)button {
    THNSceneImageViewController *sceneImageVC = [[THNSceneImageViewController alloc] init];
    sceneImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    sceneImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sceneImageVC.image = _image;
    [self.vc presentViewController:sceneImageVC animated:YES completion:nil];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:0.8];
        _title.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:0.8];
        _suTitle.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _suTitle.font = [UIFont systemFontOfSize:17];
    }
    return _suTitle;
}

@end
