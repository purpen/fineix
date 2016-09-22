#import <UIKit/UIKit.h>
#import "THNRemindModelReviceUser.h"
#import "THNRemindModelReviceUser.h"
#import "THNRemindModelTargetObj.h"
#import "THNRemindModelCommentObj.h"

@interface THNRemindModelRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) THNRemindModelCommentObj * commentTargetObj;
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
@property (nonatomic, strong) THNRemindModelReviceUser * reviceUser;
@property (nonatomic, assign) NSInteger sUserId;
@property (nonatomic, strong) THNRemindModelReviceUser * sendUser;
@property (nonatomic, strong) THNRemindModelTargetObj * targetObj;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
