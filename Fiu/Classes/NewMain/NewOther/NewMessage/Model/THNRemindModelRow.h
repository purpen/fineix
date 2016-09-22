#import <UIKit/UIKit.h>
#import "THNRemindModelSUser.h"
#import "THNRemindModelTarget.h"
#import "THNRemindModelSUser.h"

@interface THNRemindModelRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSObject * commentTypeStr;
@property (nonatomic, strong) NSObject * content;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger evt;
@property (nonatomic, assign) NSInteger fromTo;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * kindStr;
@property (nonatomic, strong) NSString * parentRelatedId;
@property (nonatomic, assign) NSInteger readed;
@property (nonatomic, assign) NSInteger relatedId;
@property (nonatomic, strong) THNRemindModelSUser * sUser;
@property (nonatomic, assign) NSInteger sUserId;
@property (nonatomic, strong) THNRemindModelTarget * target;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, strong) THNRemindModelSUser * user;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end