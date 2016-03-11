//
//  FBLoadPhoto.m
//  fineix
//
//  Created by FLYang on 16/2/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//
#import <Photos/Photos.h>
#import "FBLoadPhoto.h"

@interface FBLoadPhoto()

@property (nonatomic, strong) NSMutableArray    *   allPhotos;          //  相片数组
@property (nonatomic, strong) ALAssetsLibrary   *   assetLibrary;
@property (nonatomic, strong) NSMutableArray    *   locationMarr;       //  照片的经纬度
@property (readwrite, copy, nonatomic) void(^loadBlock)(NSArray * photos, NSArray * location, NSError * error);

@end

@implementation FBLoadPhoto

#pragma mark - 获取相片

//  单例
+ (FBLoadPhoto *)shareLoad {
    static FBLoadPhoto * load;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        load = [[FBLoadPhoto alloc] init];
    });
    return load;
}

- (NSMutableArray *)allPhotos {
    if (!_allPhotos) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}


- (NSMutableArray *)locationMarr {
    if (!_locationMarr) {
        _locationMarr = [NSMutableArray array];
    }
    return _locationMarr;
}

- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

//  加载相片
+ (void)loadAllPhotos:(void (^)(NSArray *, NSArray *, NSError *))completion {
    [[FBLoadPhoto shareLoad].allPhotos removeAllObjects];
    [[FBLoadPhoto shareLoad].locationMarr removeAllObjects];
    [[FBLoadPhoto shareLoad] setLoadBlock:completion];
    [[FBLoadPhoto shareLoad] startLoading];
}

//  开始加载所有相片
- (void)startLoading {
    //  获取相片对象
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset * result, NSUInteger index, BOOL * stop) {
        if (result) {
            NSDictionary * imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:result.defaultRepresentation.metadata];
            NSDictionary * gpsDict = [imageMetadata objectForKey:@"{GPS}"];
            
            FBPhoto * photo = [[FBPhoto alloc] init];
            photo.asset = result;
            NSArray * locationArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",[[gpsDict valueForKey:@"Longitude"] floatValue]],
                                                              [NSString stringWithFormat:@"%f",[[gpsDict valueForKey:@"Latitude"] floatValue]], nil];
//            NSLog(@"照片的GPS信息：经纬度%@", locationArr);
            [self.locationMarr addObject:locationArr];
            [self.allPhotos insertObject:photo atIndex:index];
        }
    };
    
    //  获取相册
    ALAssetsLibraryGroupsEnumerationResultsBlock  listGroupBlock = ^(ALAssetsGroup * group, BOOL * stop) {
        ALAssetsFilter * onlyPhotoFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotoFilter];
        
        if ([group numberOfAssets] > 0) {

            NSLog(@"＝＝＝＝相薄的名字： %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            NSLog(@"＝＝＝＝图片的数量： %zi", [group numberOfAssets]);
            CGImageRef albumImg = [group posterImage];
            UIImage * img = [UIImage imageWithCGImage:albumImg];
            NSLog(@"＝＝＝＝相册的封面： %@", img);
            
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            self.loadBlock(self.allPhotos, self.locationMarr, nil);
        }
        
    };
    
    [self.assetLibrary enumerateGroupsWithTypes:(ALAssetsGroupAll) usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        self.loadBlock(nil,nil, error);
        
    }];
}


@end
