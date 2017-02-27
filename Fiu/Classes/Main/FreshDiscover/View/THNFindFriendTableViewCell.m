//
//  THNFindFriendTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNFindFriendTableViewCell.h"
#import "Fiu.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SVProgressHUD.h"

static NSString *const ShareURlText = @"我在Fiu浮游™寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！来吧，去Fiu一下 >>> https://m.taihuoniao.com/fiu";

@interface THNFindFriendTableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIImageView *touXiang;
@property (nonatomic, strong) UIImageView *weibo;
@property (nonatomic, strong) UIImageView *tongxunlu;
/**  */
@property (nonatomic, strong) UILabel *weixinLabel;
@property (nonatomic, strong) UILabel *weiboLabel;
@property (nonatomic, strong) UILabel *tongxunluLabel;

@end

@implementation THNFindFriendTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        self.imageV.image = [UIImage imageNamed:@"findFriendTop"];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(22*SCREEN_HEIGHT/667.0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10*SCREEN_HEIGHT/667.0);
            make.width.mas_equalTo(526/2);
            make.height.mas_equalTo(135/2);
        }];
        
        self.weibo = [[UIImageView alloc] init];
        self.weibo.image = [UIImage imageNamed:@"weibo_icon"];
        [self.contentView addSubview:self.weibo];
        self.weibo.layer.masksToBounds = YES;
        self.weibo.layer.cornerRadius = 20*SCREEN_HEIGHT/667.0;
        [_weibo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(35*SCREEN_HEIGHT/667.0);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            make.width.height.mas_equalTo(40*SCREEN_HEIGHT/667.0);
        }];
        self.weibo.userInteractionEnabled = YES;
        [self.weibo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiBo)]];
        
        self.weiboLabel = [[UILabel alloc] init];
        self.weiboLabel.text = @"连接微博";
        self.weiboLabel.font = [UIFont systemFontOfSize:12];
        self.weiboLabel.textAlignment = NSTextAlignmentCenter;
        self.weiboLabel.textColor = [UIColor colorWithHexString:@"#727272"];
        [self.contentView addSubview:self.weiboLabel];
        [_weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.weibo.mas_bottom).mas_offset(5*SCREEN_HEIGHT/667.0);
            make.centerX.mas_equalTo(self.weibo.mas_centerX).mas_offset(0);
        }];
        
        self.touXiang = [[UIImageView alloc] init];
        self.touXiang.image = [UIImage imageNamed:@"weixin_icon"];
        [self.contentView addSubview:self.touXiang];
        self.touXiang.layer.masksToBounds = YES;
        self.touXiang.layer.cornerRadius = 20*SCREEN_HEIGHT/667.0;
        [_touXiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.weibo.mas_left).mas_offset(-102/2*SCREEN_HEIGHT/667.0);
            make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(35*SCREEN_HEIGHT/667.0);
            make.width.height.mas_equalTo(40*SCREEN_HEIGHT/667.0);
        }];
        self.touXiang.userInteractionEnabled = YES;
        [self.touXiang addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touXiangTap)]];
        
        self.weixinLabel = [[UILabel alloc] init];
        self.weixinLabel.text = @"邀请微信好友";
        self.weixinLabel.font = [UIFont systemFontOfSize:12];
        self.weixinLabel.textAlignment = NSTextAlignmentCenter;
        self.weixinLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.weixinLabel];
        [_weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.touXiang.mas_bottom).mas_offset(5*SCREEN_HEIGHT/667.0);
            make.centerX.mas_equalTo(self.touXiang.mas_centerX).mas_offset(0);
        }];
        
        self.tongxunlu = [[UIImageView alloc] init];
        self.tongxunlu.image = [UIImage imageNamed:@"tongxunlu"];
        [self.contentView addSubview:self.tongxunlu];
        self.tongxunlu.layer.masksToBounds = YES;
        self.tongxunlu.layer.cornerRadius = 20*SCREEN_HEIGHT/667.0;
        [_tongxunlu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.touXiang.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.weibo.mas_right).mas_offset(102/2*SCREEN_HEIGHT/667.0);
            make.width.height.mas_equalTo(40*SCREEN_HEIGHT/667.0);
        }];
        self.tongxunlu.userInteractionEnabled = YES;
        [self.tongxunlu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tongxunluTap)]];
        
        self.tongxunluLabel = [[UILabel alloc] init];
        self.tongxunluLabel.text = @"连接通讯录";
        self.tongxunluLabel.font = [UIFont systemFontOfSize:12];
        self.tongxunluLabel.textAlignment = NSTextAlignmentCenter;
        self.tongxunluLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.tongxunluLabel];
        [_tongxunluLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tongxunlu.mas_bottom).mas_offset(5*SCREEN_HEIGHT/667.0);
            make.centerX.mas_equalTo(self.tongxunlu.mas_centerX).mas_offset(0);
        }];
    }
    return self;
}

-(void)tongxunluTap{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = ShareURlText;
    //通讯录
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_Sms) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
        }
    }];
}

-(void)touXiangTap{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = ShareURlText;
    //微信
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_WechatSession) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
        }
    }];
}

-(void)weiBo{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = ShareURlText;
    //w微博
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_Sina) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
        }
    }];
}

@end
