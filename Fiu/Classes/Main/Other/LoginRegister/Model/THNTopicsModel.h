//
//  THNTopicsModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNTopicsModel : NSObject

/** id */
@property(nonatomic,copy) NSString *_id;
/** 名称 */
@property(nonatomic,copy) NSString *title;
/** 图片地址 */
@property(nonatomic,copy) NSString *back_url;

@end
