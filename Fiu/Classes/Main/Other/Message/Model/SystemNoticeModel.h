//
//  SystemNoticeModel.h
//  Fiu
//
//  Created by THN-Dong on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNoticeModel : NSObject

@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *cover_url;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,strong) NSNumber *kind;
@property(nonatomic,strong) NSNumber *evt;
@property(nonatomic,copy) NSString *url;

@end
