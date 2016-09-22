#import <UIKit/UIKit.h>
#import "THNUserModelCounter.h"
#import "THNUserModelIdentify.h"

@interface THNUserModelData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSArray * age;
@property (nonatomic, strong) NSString * ageGroup;
@property (nonatomic, strong) NSArray * areas;
@property (nonatomic, strong) NSString * assets;
@property (nonatomic, assign) NSInteger birdCoin;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) THNUserModelCounter * counter;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, assign) NSInteger districtId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * expertInfo;
@property (nonatomic, strong) NSString * expertLabel;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger firstLogin;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, strong) NSString * headPicUrl;
@property (nonatomic, strong) THNUserModelIdentify * identify;
@property (nonatomic, strong) NSString * imQq;
@property (nonatomic, strong) NSArray * interestSceneCate;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, strong) NSString * job;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * mediumAvatarUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger rankId;
@property (nonatomic, strong) NSString * rankTitle;
@property (nonatomic, strong) NSString * realname;
@property (nonatomic, assign) NSInteger sceneCount;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger sightCount;
@property (nonatomic, assign) NSInteger sightLoveCount;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger subscriptionCount;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * trueNickname;
@property (nonatomic, strong) NSString * weixin;
@property (nonatomic, strong) NSString * zip;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end