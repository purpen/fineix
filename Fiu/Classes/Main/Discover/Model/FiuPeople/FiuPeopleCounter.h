//
//	FiuPeopleCounter.h
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FiuPeopleCounter : NSObject

@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger fiuAlertCount;
@property (nonatomic, assign) NSInteger fiuCommentCount;
@property (nonatomic, assign) NSInteger fiuNoticeCount;
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, assign) NSInteger messageTotalCount;
@property (nonatomic, assign) NSInteger orderEvaluate;
@property (nonatomic, assign) NSInteger orderReadyGoods;
@property (nonatomic, assign) NSInteger orderSendedGoods;
@property (nonatomic, assign) NSInteger orderTotalCount;
@property (nonatomic, assign) NSInteger orderWaitPayment;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end