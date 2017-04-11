//
//  THNSenceModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THNUserData;

@interface THNSenceModel : NSObject

/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *cover_url;
/**  */
@property(nonatomic,copy) NSString *title;
/**  */
@property (nonatomic, strong) THNUserData *user_info;
/**  */
@property (nonatomic, strong) NSNumber *is_love;

@end
