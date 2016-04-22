//
//  AccountView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AccountView.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AccountView

+(instancetype)getAccountView{
    AccountView *view = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][7];
    view.iconUrl.layer.masksToBounds = YES;
    view.iconUrl.layer.cornerRadius = 15;
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    //更新头像
    [view.iconUrl sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Circle + User"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    view.nickName.text = entity.nickname;
    view.adress.text = entity.address;
    switch ([entity.sex intValue]) {
        case 0:
            view.sex.text = @"保密";
            break;
        case 1:
            view.sex.text = @"男";
            break;
        case 3:
            view.sex.text = @"女";
            break;
            
        default:
            break;
    }
    view.birthday.text = entity.birthday;
    return view;
}
@end
