//
//  THNActivityCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActivityCollectionViewCell.h"
#import "THNArticleModel.h"
#import "UIImageView+WebCache.h"

@interface THNActivityCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation THNActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
    self.tipImageView.hidden = model.evt != 2;
    self.subTitleLabel.text = model.short_title;
    self.countLabel.text = [NSString stringWithFormat:@"已有%@人参与",model.attend_count];
    self.titleLabel.text = model.title;
}

@end
