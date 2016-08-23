//
//  THNCuXiaoDetalModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNCuXiaoDetalModel : NSObject

/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *cover_url;
/**  */
@property(nonatomic,copy) NSString *title;
/**  */
@property (nonatomic, strong) NSArray *products;
/** 浏览次数 */
@property(nonatomic,copy) NSString *view_count;
/**  */
@property(nonatomic,copy) NSString *comment_count;
/**  */
@property(nonatomic,copy) NSString *share_count;

@end
