//
//  THNBankTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNBankTableViewCell.h"
#import "Fiu.h"

@interface THNBankTableViewCell ()

/**  */
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation THNBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        }];
    }
    return self;
}

-(void)setModel:(THNYinHangModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
}

@end
