//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"
#import "CreateViewController.h"
#import "HomeViewController.h"
#import "LookSceneViewController.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  from: "SelectAllFSceneViewController.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFiuSceneId:) name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFiuSceneTitle:) name:@"selectFiuSceneTitle" object:nil];
    
    if (self.addView.fiuId.length > 0) {
        self.fSceneId = self.addView.fiuId;
    }
    
    self.tagS = [self.addView.chooseTagIdMarr componentsJoinedByString:@","];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.addView.fiuId = @"";
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
    
    [self setReleaseViewUI];
}

#pragma mark - 网络请求
#pragma mark 发布场景
- (void)networkNewSceneData {
    NSString * title = [self.scenceView.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.scenceView.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addDescription", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || self.tagS.length <=0 || self.fSceneId.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"填写未完成"];

    } else if (title.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
        
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        NSMutableArray * goodsMarr = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < self.goodsId.count; ++ idx) {
            NSDictionary *  goodsDict = @{@"id":self.goodsId[idx],
                                          @"price":self.goodsPrice[idx],
                                          @"title":self.goodsTitle[idx],
                                          @"x":self.goodsX[idx],
                                          @"y":self.goodsY[idx]};
            [goodsMarr addObject:goodsDict];
        }
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:goodsMarr options:0 error:nil];
        NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSData * imageData = UIImageJPEGRepresentation(self.scenceView.imageView.image, 0.7);
        NSString * icon64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * paramDict = @{
                                     @"tmp":icon64Str,
                                     @"title":title,
                                     @"des":des,
                                     @"lng":self.lng,
                                     @"lat":self.lat,
                                     @"address":self.addView.location.text,
                                     @"products":json,
                                     @"tags":self.tagS,
                                     @"scene_id":self.fSceneId,
                                     };
        
        self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
        
        [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
//            NSString * sceneId = [NSString stringWithFormat:@"%@",[[result valueForKey:@"data"] valueForKey:@"id"]];
//            LookSceneViewController * sceneInfoVC = [[LookSceneViewController alloc] init];
//            sceneInfoVC.sceneId = sceneId;
//            [self.navigationController pushViewController:sceneInfoVC animated:YES];
            
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"您的情景发布成功，品味又升级啦"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            }];
        
        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 发布情景
- (void)networkNewFiuSceneData {
    NSString * title = [self.scenceView.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.scenceView.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addFiuSceneDes", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || self.tagS.length <=0) {
        [SVProgressHUD showInfoWithStatus:@"填写未完成"];
    } else if (title.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
        
    } else if (des.length > 140) {
        [SVProgressHUD showInfoWithStatus:@"请输入140字以内的描述"];
        
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        NSData * imageData = UIImageJPEGRepresentation(self.scenceView.imageView.image, 0.7);
        NSString * icon64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * paramDict = @{
                                     @"tmp":icon64Str,
                                     @"title":self.scenceView.title.text,
                                     @"des":self.scenceView.content.text,
                                     @"lng":self.lng,
                                     @"lat":self.lat,
                                     @"address":self.addView.location.text,
                                     @"tags":self.tagS,
                                     };
        self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseFiuScenen requestDictionary:paramDict delegate:self];
        
        [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            //  to #import "AllSceneViewController.h"
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllFSceneList" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"您的地盘发布成功，品味又升级啦"];
            
        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

//  所选情景的iD
- (void)getFiuSceneId:(NSNotification *)fiuSceneId {
    self.fSceneId = [fiuSceneId object];
}

//  所选情景的标题
- (void)getFiuSceneTitle:(NSNotification *)fiuSceneTitle {
    [self.addView changeSceneFrame:[fiuSceneTitle object]];
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    if ([self.createType isEqualToString:@"scene"]) {
        self.addView.addScene.hidden = NO;
    } else if ([self.createType isEqualToString:@"fScene"]) {
        self.addView.addScene.hidden = YES;
    }

    [self.view addSubview:self.scenceView];
    [self.scenceView getCreateType:self.createType];
    
    [self.view addSubview:self.addView];
    
    //  add #import "ScenceAddMoreView.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationArr:) name:@"locationArr" object:nil];
}

- (void)locationArr:(NSNotification *)locationArr {
    self.lat = [locationArr object][0];
    self.lng = [locationArr object][1];
}

#pragma mark - 添加文字信息的视图
- (ScenceMessageView *)scenceView {
    if (!_scenceView) {
        _scenceView = [[ScenceMessageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 236.5)];
        _scenceView.vc = self;
    }
    return _scenceView;
}

#pragma mark - 添加位置／标签／所属情景的视图
- (ScenceAddMoreView *)addView {
    if (!_addView) {
        _addView = [[ScenceAddMoreView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT- 290)];
        _addView.nav = self.navigationController;
        if ([self.locationArr[0] isEqualToString:@"0.000000"]) {
            NSLog(@"照片上没有位置信息");
        } else {
            if (self.locationArr.count > 0) {
                [_addView changeLocationFrame:self.locationArr];
                self.lng = self.locationArr[0];
                self.lat = self.locationArr[1];
            }
        }
        if (self.fSceneId.length > 0) {
            _addView.addSceneBtn.userInteractionEnabled = NO;
            [_addView changeSceneFrame:self.fSceneTitle];
        }
    }
    return _addView;
}



#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"freleaseVcTitle", nil)];
    }

    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认发布场景
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        [self networkNewSceneData];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self networkNewFiuSceneData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationArr" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneTitle" object:nil];
}

@end
