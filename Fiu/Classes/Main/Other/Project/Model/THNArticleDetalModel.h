//
//  THNArticleDetalModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THNProductModel;

@interface THNArticleDetalModel : NSObject

/**  */
@property(nonatomic,copy) NSString *content_view_url;
/**  */
@property(nonatomic,copy) NSString *share_view_url;
/**  */
@property(nonatomic,copy) NSString *share_desc;
/**  */
@property(nonatomic,copy) NSString *view_count;
/**  */
@property(nonatomic,copy) NSString *attend_count;
/**  */
@property(nonatomic,copy) NSString *favorite_count;
/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *user_id;
/**  */
@property(nonatomic,copy) NSString *cover_url;
/**  */
@property (nonatomic, strong) THNProductModel *product;
/**  */
@property(nonatomic,copy) NSString *share_count;
/**  */
@property(nonatomic,copy) NSString *title;
/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property(nonatomic,copy) NSString *comment_count;

@end
