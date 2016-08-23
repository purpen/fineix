//
//  THNActivityCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActivityCollectionViewCell.h"
#import "THNArticleModel.h"
#import <UIImageView+WebCache.h>

@interface THNActivityCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSubTitleLabel;

@end

@implementation THNActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(THNArticleModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    
    if (model.evt == 2) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
        self.tipImageView.hidden = NO;
        self.endTitleLabel.hidden = NO;
        self.endTitleLabel.text = model.title;
        self.titleLabel.hidden = YES;
        self.peopleImageView.hidden = YES;
        self.countLabel.hidden = YES;
        self.endSubTitleLabel.hidden = NO;
        self.endSubTitleLabel.text = model.short_title;
        self.subTitleLabel.hidden = YES;
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_time_at,model.end_time_at];
        self.tipImageView.hidden = YES;
        self.endTitleLabel.hidden = YES;
        self.titleLabel.text = model.title;
        self.titleLabel.hidden = NO;
        self.peopleImageView.hidden = NO;
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"已有%@人参与",model.attend_count];
        self.endSubTitleLabel.hidden = YES;
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = model.short_title;
    }
    
}

@end
