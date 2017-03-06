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
#import "THNUserAddGoodsViewController.h"
#import "THNSceneDetalViewController.h"

@interface THNSceneImageTableViewCell () {
    NSString *_titleStr;
    NSString *_suTitleStr;
    NSString *_image;
    NSString *_brandTitle;
    NSString *_sceneId;
    NSInteger _isFine;
    NSInteger _isStick;
    NSInteger _isCheck;
    ClickOpenType _openType;
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
- (void)thn_touchUpOpenControllerType:(ClickOpenType)type {
    _openType = type;
}

- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel {
    self.tagDataMarr = [NSMutableArray arrayWithArray:sceneModel.product];
    self.goodsIds = [NSMutableArray arrayWithArray:[sceneModel.product valueForKey:@"idField"]];
    if (self.tagDataMarr.count) {
        [self setUserTagBtn];
    }
    
    _sceneId = [NSString stringWithFormat:@"%zi", sceneModel.idField];
    _isFine = sceneModel.fine;
    _isStick = sceneModel.stick;
    _isCheck = sceneModel.isCheck;
    _image = sceneModel.coverUrl;

    [self.sceneImage sd_setImageWithURL:[NSURL URLWithString:sceneModel.coverUrl]
                       placeholderImage:[UIImage imageNamed:@""]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  [self thn_showLoadImageAnimate:YES];
                              }];

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
            make.width.equalTo(@([self getTextSizeWidth:suTitleStr font:17].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr font:17].width));
            make.bottom.equalTo(self.mas_bottom).with.offset(-48);
        }];
        
    } else if (sceneModel.title.length <= 10) {
        self.suTitle.hidden = YES;
        self.title.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"    %@  ", sceneModel.title];
        self.title.text = titleStr;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:titleStr font:17].width));
        }];
    }
    
}

- (void)thn_showLoadImageAnimate:(BOOL)show {
    if (show) {
        self.sceneImage.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            self.sceneImage.alpha = 1.0f;
        }];
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text font:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
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
    [self.userTagMarr removeAllObjects];
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString *title = [NSString stringWithFormat:@"%@  ", [self.tagDataMarr[idx] valueForKey:@"title"]];
        NSString *price = [NSString stringWithFormat:@"￥%.2f", [[self.tagDataMarr[idx] valueForKey:@"price"] floatValue]];
        NSInteger loc = [[self.tagDataMarr[idx] valueForKey:@"loc"] integerValue];
        CGFloat buttonWidth = [self getTextSizeWidth:title font:12].width + 25;
        
        UserGoodsTag * userTag = [[UserGoodsTag alloc] init];
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        if ([price isEqualToString:@"￥0.00"]) {
            userTag.price.font = [UIFont systemFontOfSize:10];
            price = @"￥暂未销售";
        }
        userTag.price.text = price;
        userTag.isMove = NO;
        
        if (buttonWidth > SCREEN_WIDTH/2) {
            buttonWidth = SCREEN_WIDTH/2;
        }
        
        if (loc == 1) {
            userTag.frame = CGRectMake((btnX * SCREEN_WIDTH) - (buttonWidth - 18), btnY * SCREEN_WIDTH - 32, buttonWidth + 7, 46);
        } else if (loc == 2) {
            userTag.frame = CGRectMake(btnX * SCREEN_WIDTH - 44, btnY * SCREEN_WIDTH - 32, buttonWidth + 7, 46);
        }
        [userTag thn_setSceneImageUserGoodsTagLoc:loc];

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoodsInfo:)];
        [userTag addGestureRecognizer:tapGesture];
        
        [self addSubview:userTag];
        [self bringSubviewToFront:self.title];
        
        [self.userTagMarr addObject:userTag];
    }
}

- (void)openGoodsInfo:(UITapGestureRecognizer *)tapGesture {
    NSInteger index = [self.userTagMarr indexOfObject:tapGesture.view];

    FBGoodsInfoViewController *goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = self.goodsIds[index];
    [self.nav pushViewController:goodsInfoVC animated:YES];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.sceneImage];
    [_sceneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
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
- (UIImageView *)sceneImage {
    if (!_sceneImage) {
        _sceneImage = [[UIImageView alloc] init];
        _sceneImage.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImage.clipsToBounds = YES;
        _sceneImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *sceneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sceneImageClick:)];
        [_sceneImage addGestureRecognizer:sceneTap];
    }
    return _sceneImage;
}

- (void)sceneImageClick:(UITapGestureRecognizer *)tap {
    switch (_openType) {
        case ClickOpenTypeSceneList:
            [self openSceneInfoController];
            break;
        case ClickOpenTypeSceneInfo:
            [self openSceneInfoImage];
            break;
    }
}

#pragma mark - 打开情境详情
- (void)openSceneInfoController {
    THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
    sceneDataVC.sceneDetalId = _sceneId;
    [self.nav pushViewController:sceneDataVC animated:YES];
}

#pragma mark - 打开情境大图
- (void)openSceneInfoImage {
    THNSceneImageViewController *sceneImageVC = [[THNSceneImageViewController alloc] init];
    sceneImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    sceneImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sceneImageVC.sceneId = _sceneId;
    [sceneImageVC thn_setLookSceneImage:_image];
    [sceneImageVC thn_getSceneState:_isFine stick:_isStick check:_isCheck];
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

- (NSMutableArray *)userTagMarr {
    if (!_userTagMarr) {
        _userTagMarr = [NSMutableArray array];
    }
    return _userTagMarr;
}

@end
