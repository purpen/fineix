//
//  THNSenecCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSenecCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "THNSenceModel.h"
#import "UserInfo.h"
#import <Masonry.h>
#import "FBRequest.h"
#import "FBAPI.h"
#import <SVProgressHUD.h>

@interface THNSenecCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbael;
@property (weak, nonatomic) IBOutlet UIButton *prasiedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;

@end

@implementation THNSenecCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.head.layer.masksToBounds = YES;
    self.head.layer.cornerRadius = 21 * 0.5;
}

- (IBAction)prasied:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:@"/favorite/ajax_cancel_love" requestDictionary:@{
                                                                                                        @"id" : self.model._id,
                                                                                                        @"type" : @12
                                                                                                        } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            if (result[@"success"]) {
                sender.selected = NO;
                self.model.is_love = @0;
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        FBRequest *request = [FBAPI postWithUrlString:@"/favorite/ajax_love" requestDictionary:@{
                                                                                                        @"id" : self.model._id,
                                                                                                        @"type" : @12
                                                                                                        } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            if (result[@"success"]) {
                sender.selected = YES;
                self.model.is_love = @1;
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

-(void)setModel:(THNSenceModel *)model{
    
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"my_senece_bg"]];
    NSString *strUrl = [model.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self titleTextStyle:strUrl];
    [self.head sd_setImageWithURL:[NSURL URLWithString:model.user_info.avatar_url] placeholderImage:[UIImage imageNamed:@"Circle + User"]];
    self.prasiedBtn.selected = [model.is_love integerValue];
    self.nickNameLbael.text = model.user_info.nickname;
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    
    if (title.length == 0) {
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"  %@ ",title];
    
    
    if (str.length <= 13) {
        NSString *a = [str substringWithRange:NSMakeRange(0, str.length)];
        self.titleTwoLabel.text = a;
        self.tittleLabel.text = @"";
    }else if (str.length > 13){
        NSString *a = [str substringWithRange:NSMakeRange(0, 12)];
        NSString *b = [NSString stringWithFormat:@"%@ ",a];
        self.tittleLabel.text = b;
        NSString *c = [str substringWithRange:NSMakeRange(12, str.length - 12)];
        NSString *d = [NSString stringWithFormat:@"  %@",c];
        self.titleTwoLabel.text = d;
    }
}

@end
