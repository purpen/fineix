//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"
#import "IQKeyboardManager.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";

@interface ReleaseViewController () {
    NSString *_sceneId;
}

@end

@implementation ReleaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.domainId.length == 0) {
        self.domainId = @"";
    }
    [self setReleaseViewUI];
}

- (void)thn_releaseTheSceneType:(NSInteger)type withSceneId:(NSString *)sceneId withSceneData:(HomeSceneListRow *)model {
    [self setNavViewUiType:type];
    if (type == 1) {
        _sceneId = sceneId;
        
        [self.addContent.sceneImgView downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
        [self.addContent thn_setSceneTitle:model.title];
        [self.addContent getContentWithTags:model.des];
        [self.addLocaiton setEditSceneLocationLat:[NSString stringWithFormat:@"%f", [model.location.coordinates[1] floatValue]]
                                              lng:[NSString stringWithFormat:@"%f", [model.location.coordinates[0] floatValue]]
                                             city:model.city
                                          address:model.address];
    }
}

#pragma mark - 网络请求
#pragma mark 发布情境
- (void)networkNewSceneData:(NSString *)sceneId {
    NSString *title = self.addContent.title.text;
//    NSString *subTitle = self.addContent.suTitle.text;
//    if (subTitle.length == 0) {
//        subTitle = @"";
//    }
    if (title.length == 0) {
        title = @"";
    }
//    NSString *title = [NSString stringWithFormat:@"%@%@", firTitle, subTitle];
    
    if ([self.addContent.content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        self.addContent.content.text = @"";
    }
    
    NSString *des = self.addContent.content.text;
    NSString *address = self.addLocaiton.locationLab.text;
    NSString *city = self.addLocaiton.cityLab.text;
    NSString *lng = self.addLocaiton.longitude;
    NSString *lat = self.addLocaiton.latitude;
    NSString *tags = [self.addContent.userAddTags componentsJoinedByString:@","];
    NSString *json;
    NSString *img64Str;
    
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
    if (self.addContent.actionId.length > 0) {
         self.actionId = self.addContent.actionId;
    }
    if (self.actionId.length == 0) {
        self.actionId = @"";
    }
    if (sceneId.length) {
        img64Str = @"";
    } else {
        NSData * imageData = UIImageJPEGRepresentation(self.bgImg, 1);
        img64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }

    NSDictionary * paramDict = @{
                                 @"scene_id":self.domainId,
                                 @"id":sceneId,
                                 @"tmp":img64Str,
                                 @"title":title,
                                 @"des":des,
                                 @"lng":lng,
                                 @"lat":lat,
                                 @"address":address,
                                 @"city":city,
                                 @"products":json,
                                 @"tags":tags,
                                 @"subject_ids":self.actionId
                                 };
    
    self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            if (sceneId.length) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
                }];
                
            } else {
                self.sharePopView.sceneId = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"id"] integerValue]];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self showShareView];
                }];
            }
        }
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    CGFloat navTopHeight = Is_iPhoneX ? 88 : 45;
    
    [self.view addSubview:self.addContent];
    [_addContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH+88));
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(navTopHeight);
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
        if (self.actionId.length) {
            [_addContent thn_getActionDataTitle:self.activeTitle];
        }
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

#pragma mark - 发布完成，提示分享
- (FBPopupView *)sharePopView {
    if (!_sharePopView) {
        _sharePopView = [[FBPopupView alloc] init];
    }
    return _sharePopView;
}

- (void)showShareView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSceneList" object:nil];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self.sharePopView showPopupViewOnWindowStyleOne:NSLocalizedString(@"releaseSceneDone", nil)];
    [window addSubview:self.sharePopView];
}

#pragma mark -  设置导航栏
/**
 设置视图样式
 
 @param releaseType 发布类型：0:创建新情境／1:编辑情境
 */
- (void)setNavViewUiType:(NSInteger)releaseType {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.navTitle.textColor = [UIColor whiteColor];
    
    if (releaseType == 0) {
        [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
        [self.cancelDoneBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:(UIControlStateNormal)];
        [self addCancelDoneButton];
        [self addDoneButton];
        [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
        //  发情境参与活动id
        if (self.actionId.length == 0) {
            self.actionId = @"";
        }
        
    } else if (releaseType == 1) {
        [self addNavViewTitle:NSLocalizedString(@"editScene", nil)];
        [self addCloseBtn:@"icon_cancel"];
        [self addDoneButton];
        [self.doneBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [self.doneBtn addTarget:self action:@selector(editScene) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

#pragma mark 发布新情境
- (void)releaseScene {
    [self networkNewSceneData:@""];
}

#pragma mark 编辑情境
- (void)editScene {
    if (_sceneId.length) {
        [self networkNewSceneData:_sceneId];
    }
}

@end
