//
//	THNUserModelCounter.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNUserModelCounter.h"

NSString *const kTHNUserModelCounterFansCount = @"fans_count";
NSString *const kTHNUserModelCounterFiuAlertCount = @"fiu_alert_count";
NSString *const kTHNUserModelCounterFiuCommentCount = @"fiu_comment_count";
NSString *const kTHNUserModelCounterFiuNoticeCount = @"fiu_notice_count";
NSString *const kTHNUserModelCounterMessageCount = @"message_count";
NSString *const kTHNUserModelCounterMessageTotalCount = @"message_total_count";
NSString *const kTHNUserModelCounterOrderEvaluate = @"order_evaluate";
NSString *const kTHNUserModelCounterOrderReadyGoods = @"order_ready_goods";
NSString *const kTHNUserModelCounterOrderSendedGoods = @"order_sended_goods";
NSString *const kTHNUserModelCounterOrderTotalCount = @"order_total_count";
NSString *const kTHNUserModelCounterOrderWaitPayment = @"order_wait_payment";

@interface THNUserModelCounter ()
@end
@implementation THNUserModelCounter




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNUserModelCounterFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNUserModelCounterFansCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterFiuAlertCount] isKindOfClass:[NSNull class]]){
		self.fiuAlertCount = [dictionary[kTHNUserModelCounterFiuAlertCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterFiuCommentCount] isKindOfClass:[NSNull class]]){
		self.fiuCommentCount = [dictionary[kTHNUserModelCounterFiuCommentCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterFiuNoticeCount] isKindOfClass:[NSNull class]]){
		self.fiuNoticeCount = [dictionary[kTHNUserModelCounterFiuNoticeCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterMessageCount] isKindOfClass:[NSNull class]]){
		self.messageCount = [dictionary[kTHNUserModelCounterMessageCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterMessageTotalCount] isKindOfClass:[NSNull class]]){
		self.messageTotalCount = [dictionary[kTHNUserModelCounterMessageTotalCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterOrderEvaluate] isKindOfClass:[NSNull class]]){
		self.orderEvaluate = [dictionary[kTHNUserModelCounterOrderEvaluate] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterOrderReadyGoods] isKindOfClass:[NSNull class]]){
		self.orderReadyGoods = [dictionary[kTHNUserModelCounterOrderReadyGoods] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterOrderSendedGoods] isKindOfClass:[NSNull class]]){
		self.orderSendedGoods = [dictionary[kTHNUserModelCounterOrderSendedGoods] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterOrderTotalCount] isKindOfClass:[NSNull class]]){
		self.orderTotalCount = [dictionary[kTHNUserModelCounterOrderTotalCount] integerValue];
	}

	if(![dictionary[kTHNUserModelCounterOrderWaitPayment] isKindOfClass:[NSNull class]]){
		self.orderWaitPayment = [dictionary[kTHNUserModelCounterOrderWaitPayment] integerValue];
	}

	return self;
}
@end