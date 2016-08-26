//
//  THNCuXiaoDetalModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

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
/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property (nonatomic, assign) CGFloat viewHeight;
/**  */
@property(nonatomic,copy) NSString *share_view_url;
/**  */
@property(nonatomic,copy) NSString *share_desc;
/**  */
@property(nonatomic,copy) NSString *banner_url;
/**  */
@property(nonatomic,copy) NSString *user_id;
/**  */
@property(nonatomic,copy) NSString *begin_time_at;
/**  */
@property(nonatomic,copy) NSString *end_time_at;
/**  */
@property(nonatomic,copy) NSString *short_title;

@end
