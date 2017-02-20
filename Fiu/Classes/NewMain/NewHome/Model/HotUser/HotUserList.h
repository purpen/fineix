#import <UIKit/UIKit.h>
#import "HotUserListData.h"

@interface HotUserList : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) HotUserListData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end