//
//  AddLocationView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddLocationView.h"
#import "SearchLocationViewController.h"

@implementation AddLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.addLocation];
        [self addSubview:self.locationView];
        [self addSubview:self.clearBtn];
        
        for (NSUInteger idx = 0; idx < 2; ++ idx) {
            UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 43 * idx, SCREEN_WIDTH, 1)];
            lineLab.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2" alpha:0.5f];
            [self addSubview:lineLab];
        }
    }
    return self;
}

- (void)setEditSceneLocationData:(NSString *)latitude withLng:(NSString *)longitude {
    self.latitude = latitude;
    self.longitude = longitude;
}

#pragma mark - 显示位置信息视图
- (UIView *)locationView {
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 25, 44)];
        _locationView.hidden = YES;
        
        [_locationView addSubview:self.locationIcon];
        [_locationView addSubview:self.locationLab];
        [_locationView addSubview:self.cityLab];
    }
    return _locationView;
}

#pragma mark 地点图标
- (UIButton *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 44)];
        [_locationIcon setImage:[UIImage imageNamed:@"icon_addLocation"] forState:(UIControlStateNormal)];
    }
    return _locationIcon;
}

#pragma mark 位置
- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, SCREEN_WIDTH - 80, 20)];
        _locationLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _locationLab.font = [UIFont systemFontOfSize:12];
    }
    return _locationLab;
}

#pragma mark 城市
- (UILabel *)cityLab {
    if (!_cityLab) {
        _cityLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, SCREEN_WIDTH - 80, 20)];
        _cityLab.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _cityLab.font = [UIFont systemFontOfSize:12];
    }
    return _cityLab;
}

#pragma mark 清空
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
        [_clearBtn setImage:[UIImage imageNamed:@"clear"] forState:(UIControlStateNormal)];
        _clearBtn.hidden = YES;
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _clearBtn;
}

- (void)clearBtnClick {
    self.cityLab.text = @"";
    self.locationLab.text = @"";
    self.locationView.hidden = YES;
    self.addLocation.hidden = NO;
    self.clearBtn.hidden = YES;
}

#pragma mark 地点按钮
- (UIButton *)addLocation {
    if (!_addLocation) {
        _addLocation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_addLocation setTitle:NSLocalizedString(@"addLocation", nil) forState:(UIControlStateNormal)];
        _addLocation.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addLocation setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _addLocation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addLocation setImage:[UIImage imageNamed:@"icon_addLocation"] forState:(UIControlStateNormal)];
        [_addLocation setImageEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        [_addLocation setTitleEdgeInsets:(UIEdgeInsetsMake(0, 25, 0, 0))];
        [_addLocation addTarget:self action:@selector(addLocationClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addLocation;
}

#pragma mark 打开地点搜索视图
- (void)addLocationClick {
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reciveNotice:) name:@"a" object:nil];
    
    SearchLocationViewController * searchLocation = [[SearchLocationViewController alloc] init];
    searchLocation.type = @"edit";
    searchLocation.selectedLocationBlock = ^(NSString * location, NSString * city, NSString * latitude, NSString * longitude){
        self.addLocation.hidden = YES;
        self.clearBtn.hidden = NO;
        self.locationView.hidden = NO;
        self.locationLab.text = [NSString stringWithFormat:@"%@", location];
        self.cityLab.text = [NSString stringWithFormat:@"%@", city];
        self.latitude = latitude;
        self.longitude = longitude;
    };
    [self.vc presentViewController:searchLocation animated:YES completion:nil];
}

- (void)reciveNotice:(NSNotification *)notification {
    self.addLocation.hidden = YES;
    self.clearBtn.hidden = NO;
    self.locationView.hidden = NO;
    self.locationLab.text = [NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"name"]];
    self.cityLab.text = [NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"city"]];
    self.latitude = [notification.userInfo objectForKey:@"lat"];
    self.longitude = [notification.userInfo objectForKey:@"lon"];
}

@end
