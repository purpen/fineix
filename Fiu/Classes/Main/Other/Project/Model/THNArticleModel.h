//
//  THNArticleModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNArticleModel : NSObject

/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *cover_url;
/**  */
@property(nonatomic,copy) NSString *title;
/**  */
@property(nonatomic,copy) NSString *attend_count;
/**  */
@property(nonatomic,copy) NSString *publish;
/**  */
@property (nonatomic, assign) NSInteger evt;
/**  */
@property(nonatomic,copy) NSString *begin_time;
/**  */
@property(nonatomic,copy) NSString *end_time;
/**  */
@property (nonatomic, strong) NSMutableArray *goodsAry;

@end
