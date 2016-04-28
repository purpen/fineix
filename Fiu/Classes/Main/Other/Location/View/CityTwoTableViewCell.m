//
//  CityTwoTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CityTwoTableViewCell.h"
#import "Fiu.h"

@implementation CityTwoTableViewCell

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
        
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 184/667.0*SCREEN_HEIGHT));
        }];
    }
    return self;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        
        [_bgImageView addSubview:self.locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 22));
            make.bottom.mas_equalTo(-12/667.0*SCREEN_HEIGHT);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }
    return _bgImageView;
}

-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.textColor = [UIColor whiteColor];
    }
    return _locationLabel;
}



@end
