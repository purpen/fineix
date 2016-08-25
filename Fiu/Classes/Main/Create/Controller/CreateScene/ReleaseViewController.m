//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"
#import "HomeViewController.h"
#import "LookSceneViewController.h"
#import "IQKeyboardManager.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";
static NSString *const URLGetUserDesTags = @"/gateway/fetch_chinese_word";

@interface ReleaseViewController () {

}

@end

@implementation ReleaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setReleaseViewUI];
}

#pragma mark - 网络请求
#pragma mark 获取用户填写描述的标签
//- (void)networkGetUserDesTags:(NSString *)title withDes:(NSString *)des {
//    self.getUserDesTagsRequest = [FBAPI postWithUrlString:URLGetUserDesTags requestDictionary:@{@"title":title, @"content":des} delegate:self];
//    [self.getUserDesTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSArray * tagsArr = [[result valueForKey:@"data"] valueForKey:@"word"];
//        NSLog(@"－－－－ 用户的标签 %@", tagsArr);
//        
//    } failure:^(FBRequest *request, NSError *error) {
//        NSLog(@"%@", error);
//    }];
//}

#pragma mark 发布场景
- (void)networkNewSceneData {
    NSString *title = [self.addContent.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.addContent.content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        self.addContent.content.text = @"";
    }
    NSString *des = self.addContent.content.text;
    NSString *address = self.addLocaiton.locationLab.text;
    NSString *city = self.addLocaiton.cityLab.text;
    NSString *lng = self.addLocaiton.longitude;
    NSString *lat = self.addLocaiton.latitude;
    NSString *tags = [self.addContent.userAddTags componentsJoinedByString:@","];
    NSString * json;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if (self.goodsId.count) {
        NSMutableArray * goodsMarr = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < self.goodsId.count; ++ idx) {
            NSDictionary * goodsDict = @{@"id":self.goodsId[idx],
                                         @"title":self.goodsTitle[idx],
                                         @"x":self.goodsX[idx],
                                         @"y":self.goodsY[idx],
                                         @"loc":self.goodsLoc[idx],
                                         @"type":self.goodsType[idx]};
            [goodsMarr addObject:goodsDict];
        }
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:goodsMarr options:0 error:nil];
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if (lng.length == 0) {
        lng = @"";
    }
    if (lat.length == 0) {
        lat = @"";
    }
    if (address.length == 0) {
        address = @"";
    }
    if (city.length == 0) {
        city = @"";
    }
    if (tags.length == 0) {
        tags = @"";
    }
    if (title.length == 0) {
        title = @"";
    }
    if (des.length == 0) {
        des = @"";
    }
    if (json.length == 0) {
        json = @"";
    }
    
    NSData * imageData = UIImageJPEGRepresentation(self.bgImg, 0.7);
    NSString * icon64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * paramDict = @{
                                 @"tmp":icon64Str,
                                 @"title":title,
                                 @"des":des,
                                 @"lng":lng,
                                 @"lat":lat,
                                 @"address":address,
                                 @"city":city,
                                 @"products":json,
                                 @"tags":tags,
                                 };
    
    self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
    
    [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    [self.view addSubview:self.addContent];
    [_addContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH+88));
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(45);
    }];
    
    [self.view addSubview:self.addLocaiton];
    [_addLocaiton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(_addContent.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
}

#pragma mark - 添加内容视图
- (AddContentView *)addContent {
    if (!_addContent) {
        _addContent = [[AddContentView alloc] init];
        _addContent.vc = self;
        _addContent.sceneImgView.image = self.bgImg;
    }
    return _addContent;
}

#pragma mark - 添加地点
- (AddLocationView *)addLocaiton {
    if (!_addLocaiton) {
        _addLocaiton = [[AddLocationView alloc] init];
        _addLocaiton.vc = self;
    }
    return _addLocaiton;
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    self.navTitle.textColor = [UIColor whiteColor];
    [self.cancelDoneBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:(UIControlStateNormal)];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认发布场景
- (void)releaseScene {
    [self networkNewSceneData];
}

@end
