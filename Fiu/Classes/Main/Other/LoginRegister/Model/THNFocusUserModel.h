//
//  THNFocusUserModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNFocusUserModel : NSObject

/** id */
@property(nonatomic,copy) NSString *_id;
/** 头像URL */
@property(nonatomic,copy) NSString *medium_avatar_url;
/**  */
@property(nonatomic,copy) NSString *nickname;
/**认证标签  */
@property(nonatomic,copy) NSString *expert_label;
/** 认证信息 */
@property(nonatomic,copy) NSString *expert_info;

@property(nonatomic, assign) BOOL flag;


@end
