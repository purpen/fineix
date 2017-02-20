#import <UIKit/UIKit.h>

@interface UserModelRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger assetType;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSObject * coverId;
@property (nonatomic, strong) NSString * createdOn;
@property (nonatomic, strong) NSString * expertInfo;
@property (nonatomic, strong) NSString * expertLabel;
@property (nonatomic, strong) NSString * highContent;
@property (nonatomic, strong) NSString * highTitle;
@property (nonatomic, assign) NSInteger isExport;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * kindName;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * oid;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSObject * tid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updatedOn;
@property (nonatomic, strong) NSString * userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end