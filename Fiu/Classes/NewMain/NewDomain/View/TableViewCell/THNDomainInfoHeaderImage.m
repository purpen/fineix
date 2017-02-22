//
//  THNDomainInfoHeaderImage.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoHeaderImage.h"

@interface THNDomainInfoHeaderImage () {
    NSInteger _imageIndex;
}

@end

@implementation THNDomainInfoHeaderImage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageIndex = 1;
        [self setViewUI];
    }
    return self;
}

- (void)thn_setRollimageView:(DominInfoData *)model {
    if (model.covers.count) {
        [self thn_setCurrentImageIndex:_imageIndex];
        self.sumLabel.text = [NSString stringWithFormat:@" / %zi", model.covers.count];
        self.rollImageView.imageURLStringsGroup = model.covers;
    }
}

- (void)thn_setCurrentImageIndex:(NSInteger)index {
    self.indexLabel.text = [NSString stringWithFormat:@"%zi", index];
}

- (void)setViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    [self addSubview:self.rollImageView];
    [_rollImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.sumLabel];
    [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 15));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
    
    [self addSubview:self.indexLabel];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(_sumLabel.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textAlignment = NSTextAlignmentRight;
        _indexLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _indexLabel;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sumLabel.font = [UIFont systemFontOfSize:12];
        _sumLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _sumLabel;
}

- (SDCycleScrollView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[SDCycleScrollView alloc] init];
        _rollImageView.autoScroll = NO;
        _rollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _rollImageView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _rollImageView.delegate = self;
        _rollImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _rollImageView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _rollImageView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [self thn_setCurrentImageIndex:(_imageIndex + index)];
}

//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    
//}

@end
