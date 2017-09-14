//
//  THNCuXiaoDetalTopView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoDetalTopView.h"
#import "THNCuXiaoDetalModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"
#import "Masonry.h"

@interface THNCuXiaoDetalTopView ()



@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;

@end

@implementation THNCuXiaoDetalTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self addSubview:self.testLabel];
    [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(5);
        make.centerY.mas_equalTo(self.timeImage.mas_centerY).mas_offset(0);
        make.left.mas_equalTo(self.timeImage.mas_right).mas_offset(2);
    }];
}

-(UILabel *)testLabel{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.textColor = [UIColor colorWithHexString:@"#666666" alpha:0.8];
        _testLabel.font = [UIFont systemFontOfSize:12];
    }
    return _testLabel;
}

-(void)setModel:(THNCuXiaoDetalModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    self.textLabel.text = model.title;
    self.summaryLabel.text = model.summary;
    if (model.evt == 2) {
        self.testLabel.text = @"已结束";
    } else {
        self.testLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
    }
    self.subTitleLabel.text = model.short_title;
}

@end
