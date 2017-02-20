//
//	HotUserListCounter.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotUserListCounter.h"

NSString *const kHotUserListCounterFansCount = @"fans_count";
NSString *const kHotUserListCounterFiuAlertCount = @"fiu_alert_count";
NSString *const kHotUserListCounterFiuCommentCount = @"fiu_comment_count";
NSString *const kHotUserListCounterFiuNoticeCount = @"fiu_notice_count";
NSString *const kHotUserListCounterMessageCount = @"message_count";
NSString *const kHotUserListCounterMessageTotalCount = @"message_total_count";
NSString *const kHotUserListCounterOrderEvaluate = @"order_evaluate";
NSString *const kHotUserListCounterOrderReadyGoods = @"order_ready_goods";
NSString *const kHotUserListCounterOrderSendedGoods = @"order_sended_goods";
NSString *const kHotUserListCounterOrderTotalCount = @"order_total_count";
NSString *const kHotUserListCounterOrderWaitPayment = @"order_wait_payment";

@interface HotUserListCounter ()
@end
@implementation HotUserListCounter




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHotUserListCounterFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kHotUserListCounterFansCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterFiuAlertCount] isKindOfClass:[NSNull class]]){
		self.fiuAlertCount = [dictionary[kHotUserListCounterFiuAlertCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterFiuCommentCount] isKindOfClass:[NSNull class]]){
		self.fiuCommentCount = [dictionary[kHotUserListCounterFiuCommentCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterFiuNoticeCount] isKindOfClass:[NSNull class]]){
		self.fiuNoticeCount = [dictionary[kHotUserListCounterFiuNoticeCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterMessageCount] isKindOfClass:[NSNull class]]){
		self.messageCount = [dictionary[kHotUserListCounterMessageCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterMessageTotalCount] isKindOfClass:[NSNull class]]){
		self.messageTotalCount = [dictionary[kHotUserListCounterMessageTotalCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterOrderEvaluate] isKindOfClass:[NSNull class]]){
		self.orderEvaluate = [dictionary[kHotUserListCounterOrderEvaluate] integerValue];
	}

	if(![dictionary[kHotUserListCounterOrderReadyGoods] isKindOfClass:[NSNull class]]){
		self.orderReadyGoods = [dictionary[kHotUserListCounterOrderReadyGoods] integerValue];
	}

	if(![dictionary[kHotUserListCounterOrderSendedGoods] isKindOfClass:[NSNull class]]){
		self.orderSendedGoods = [dictionary[kHotUserListCounterOrderSendedGoods] integerValue];
	}

	if(![dictionary[kHotUserListCounterOrderTotalCount] isKindOfClass:[NSNull class]]){
		self.orderTotalCount = [dictionary[kHotUserListCounterOrderTotalCount] integerValue];
	}

	if(![dictionary[kHotUserListCounterOrderWaitPayment] isKindOfClass:[NSNull class]]){
		self.orderWaitPayment = [dictionary[kHotUserListCounterOrderWaitPayment] integerValue];
	}

	return self;
}
@end