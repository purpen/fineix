//
//  ShareStyleView.h
//  Fiu
//
//  Created by FLYang on 16/5/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface ShareStyleView : UIView

@pro_strong UIImageView         *   sceneImg;

@pro_strong UIImageView         *   userHeader;
@pro_strong UILabel             *   userName;
@pro_strong UILabel             *   userAbout;
@pro_strong UILabel             *   address;
@pro_strong UIView              *   userView;

@pro_strong UILabel             *   title;

@pro_strong UILabel             *   describe;
@pro_strong UIButton            *   describeIcon;
@pro_strong UIButton            *   sloganIcon;
@pro_strong UILabel             *   fiuSlogan;
@pro_strong UIView              *   describeView;

@pro_strong UIImageView         *   qrCode;
@pro_strong UIButton            *   fiuLogo;

- (void)setShareSceneData:(NSDictionary *)model;

@end
