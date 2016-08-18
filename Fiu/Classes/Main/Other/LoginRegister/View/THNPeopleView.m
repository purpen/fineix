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



@end

@implementation THNPeopleView

-(void)awakeFromNib{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
    
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 3;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    self.fucosBtn.layer.borderWidth = 1;
    [self.fucosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.fucosBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

-(void)setModel:(THNFocusUserModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.medium_avatar_url] placeholderImage:[UIImage imageNamed:@"Circle + User"]];
    self.nickNameLabel.text = model.nickname;
    self.profielLabel.text = [NSString stringWithFormat:@"%@ %@",model.expert_label,model.expert_info];
    
    [self fucos:self.fucosBtn];
}

- (IBAction)fucos:(UIButton*)sender {
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    
//    sender.selected = !sender.selected;
//    
//    
//    if (sender.selected) {
//        
//        sender.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
//        sender.layer.borderColor = [UIColor clearColor].CGColor;
//        
//        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{
//                                                                @"follow_id" : self.model._id
//                                                                } delegate:self];
//        [request startRequestSuccess:^(FBRequest *request, id result) {
//            if ([result objectForKey:@"success"]) {
//                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
//            }else{
//                [SVProgressHUD showErrorWithStatus:@"关注失败"];
//            }
//        } failure:nil];
//    }else{
//        
//        sender.backgroundColor = [UIColor clearColor];
//        sender.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
//        
//        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{
//                                                                                                 @"follow_id" : self.model._id
//                                                                                                 } delegate:self];
//        [request startRequestSuccess:^(FBRequest *request, id result) {
//            if ([result objectForKey:@"success"]) {
//                [SVProgressHUD showSuccessWithStatus:@"取消关注"];
//            }else{
//                [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
//            }
//        } failure:nil];
//    }
    
}

@end
