//
//  THNPeopleView.m
//  Fiu
//
//  Created by dys on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNPeopleView.h"
#import "THNFocusUserModel.h"
#import "UIColor+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FBAPI.h"
#import "FBRequest.h"
#import "SVProgressHUD.h"

@interface THNPeopleView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profielLabel;
@property (weak, nonatomic) IBOutlet UIButton *fucosBtn;


@end

@implementation THNPeopleView

-(void)awakeFromNib{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
    
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 3;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    self.fucosBtn.layer.borderWidth = 1;
}

-(void)setModel:(THNFocusUserModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.medium_avatar_url] placeholderImage:[UIImage imageNamed:@"Circle + User"]];
    self.nickNameLabel.text = model.nickname;
    self.profielLabel.text = [NSString stringWithFormat:@"%@ %@",model.expert_label,model.expert_info];
    
    
}

- (IBAction)fucos:(UIButton*)sender {
}
@end
