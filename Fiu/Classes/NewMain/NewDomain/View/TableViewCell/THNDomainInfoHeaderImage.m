//
//  THNDomainInfoHeaderImage.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoHeaderImage.h"

@implementation THNDomainInfoHeaderImage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        [self addSubview:self.rollImageView];
        [_rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
    }
    return self;
}

- (void)thn_setRollimageView:(DominInfoData *)model {
    if (model.covers.count) {
        self.rollImageView.imageURLStringsGroup = model.covers;
    }
}

- (SDCycleScrollView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[SDCycleScrollView alloc] init];
        _rollImageView.autoScrollTimeInterval = 3;
        _rollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _rollImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//        _rollImageView.placeholderImage = [UIImage imageNamed:@"Defaul_Bg_420"];
        _rollImageView.delegate = self;
        _rollImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _rollImageView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _rollImageView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    IDMPhotoBrowser *imageBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:self.goodsImageMarr animatedFromView:self];
//    imageBrowser.doneButtonImage = [UIImage imageNamed:@"icon_cancel"];
//    imageBrowser.displayArrowButton = NO;
//    imageBrowser.displayActionButton = NO;
//    imageBrowser.usePopAnimation = YES;
//    [self.vc presentViewController:imageBrowser animated:YES completion:nil];
    [SVProgressHUD showInfoWithStatus:@"打开更多图片"];
}

@end
