//
//  CityTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CityTableViewCell.h"
#import "Fiu.h"

@implementation CityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.bgImageView];
    }
    return self;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 184/667.0*SCREEN_HEIGHT)];
        _bgImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.0f)];
        shadow.frame = _bgImageView.bounds;
        [_bgImageView.layer addSublayer:shadow];
        
        [_bgImageView addSubview:self.locationImageView];
        [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(17/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(-14/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgImageView addSubview:self.locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 22));
            make.bottom.mas_equalTo(-12/667.0*SCREEN_HEIGHT);
            make.left.mas_equalTo(_locationImageView.mas_right).with.offset(2/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgImageView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(0);
            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(0);
        }];
    }
    return _bgImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.alpha = 0.5;
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        if (IS_iOS9) {
            _locationLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        } else {
            _locationLabel.font = [UIFont systemFontOfSize:16];
        }
        _locationLabel.textColor = [UIColor whiteColor];
    }
    return _locationLabel;
}

-(UIImageView *)locationImageView{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location Indicator"]];
    }
    return _locationImageView;
}

@end
