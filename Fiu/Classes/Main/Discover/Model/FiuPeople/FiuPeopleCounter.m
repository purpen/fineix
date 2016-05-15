//
//	FiuPeopleCounter.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuPeopleCounter.h"

@interface FiuPeopleCounter ()
@end
@implementation FiuPeopleCounter




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"fans_count"] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[@"fans_count"] integerValue];
	}

	if(![dictionary[@"fiu_alert_count"] isKindOfClass:[NSNull class]]){
		self.fiuAlertCount = [dictionary[@"fiu_alert_count"] integerValue];
	}

	if(![dictionary[@"fiu_comment_count"] isKindOfClass:[NSNull class]]){
		self.fiuCommentCount = [dictionary[@"fiu_comment_count"] integerValue];
	}

	if(![dictionary[@"fiu_notice_count"] isKindOfClass:[NSNull class]]){
		self.fiuNoticeCount = [dictionary[@"fiu_notice_count"] integerValue];
	}

	if(![dictionary[@"message_count"] isKindOfClass:[NSNull class]]){
		self.messageCount = [dictionary[@"message_count"] integerValue];
	}

	if(![dictionary[@"message_total_count"] isKindOfClass:[NSNull class]]){
		self.messageTotalCount = [dictionary[@"message_total_count"] integerValue];
	}

	if(![dictionary[@"order_evaluate"] isKindOfClass:[NSNull class]]){
		self.orderEvaluate = [dictionary[@"order_evaluate"] integerValue];
	}

	if(![dictionary[@"order_ready_goods"] isKindOfClass:[NSNull class]]){
		self.orderReadyGoods = [dictionary[@"order_ready_goods"] integerValue];
	}

	if(![dictionary[@"order_sended_goods"] isKindOfClass:[NSNull class]]){
		self.orderSendedGoods = [dictionary[@"order_sended_goods"] integerValue];
	}

	if(![dictionary[@"order_total_count"] isKindOfClass:[NSNull class]]){
		self.orderTotalCount = [dictionary[@"order_total_count"] integerValue];
	}

	if(![dictionary[@"order_wait_payment"] isKindOfClass:[NSNull class]]){
		self.orderWaitPayment = [dictionary[@"order_wait_payment"] integerValue];
	}

	return self;
}
@end