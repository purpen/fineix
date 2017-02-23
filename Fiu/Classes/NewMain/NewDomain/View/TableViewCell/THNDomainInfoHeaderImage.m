//
//  THNDomainInfoHeaderImage.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoHeaderImage.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface THNDomainInfoHeaderImage () <BMKLocationServiceDelegate> {
    NSInteger _imageIndex;
    BMKLocationService *_locService;
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

-(void)setAry:(NSArray *)ary{
    _ary = ary;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.ary[0] doubleValue],[self.ary[1] doubleValue]));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    self.locLabel.text = [NSString stringWithFormat:@"%0.1fkm",distance/1000.0];
    [_locService stopUserLocationService];
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
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    backView.layer.cornerRadius = 3;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_iconImage.mas_left).with.offset(-5);
//        make.right.equalTo(_sumLabel.mas_right).with.offset(5);
//        make.top.equalTo(_indexLabel.mas_top).with.offset(-2);
//        make.bottom.equalTo(_indexLabel.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(58, 20));
        make.right.equalTo(self.mas_right).with.offset(-14);
        make.bottom.equalTo(self.mas_bottom).with.offset(-14);
    }];
    
    [self addSubview:self.sumLabel];
    [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 18));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
    
    [self addSubview:self.indexLabel];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 18));
        make.right.equalTo(_sumLabel.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
    
    [self addSubview:self.iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.left.equalTo(_indexLabel.mas_left).with.offset(5);
        make.centerY.equalTo(_indexLabel);
    }];
    
    [self addSubview:self.locImage];
    [_locImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(_indexLabel);
    }];
    
    [self addSubview:self.locLabel];
    [_locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 10));
        make.left.equalTo(_locImage.mas_right).with.offset(5);
        make.centerY.equalTo(_locImage);
    }];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textAlignment = NSTextAlignmentRight;
//        _indexLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _indexLabel;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sumLabel.font = [UIFont systemFontOfSize:12];
//        _sumLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _sumLabel;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"icon_domain_photos"];
    }
    return _iconImage;
}

- (UIImageView *)locImage {
    if (!_locImage) {
        _locImage = [[UIImageView alloc] init];
        _locImage.image = [UIImage imageNamed:@"icon_domain_loc"];
    }
    return _locImage;
}

- (UILabel *)locLabel {
    if (!_locLabel) {
        _locLabel = [[UILabel alloc] init];
        _locLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _locLabel.font = [UIFont systemFontOfSize:12];
//        _locLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _locLabel;
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
