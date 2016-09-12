//
//  THNProductModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNProductModel : NSObject

/**  */
@property(nonatomic,copy) NSString *_id;
/**  */
@property(nonatomic,copy) NSString *is_favorite;
/**  */
@property(nonatomic,copy) NSString *banner_url;
/**  */
@property(nonatomic,copy) NSString *market_price;
/**  */
@property(nonatomic,copy) NSString *sale_price;
/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property(nonatomic,copy) NSString *title;
/**  */
@property (nonatomic, assign) CGFloat cellHeight;

@end
