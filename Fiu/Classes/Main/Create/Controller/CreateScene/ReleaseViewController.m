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
- (void)networkGetUserDesTags:(NSString *)title withDes:(NSString *)des {
    self.getUserDesTagsRequest = [FBAPI postWithUrlString:URLGetUserDesTags requestDictionary:@{@"title":title, @"content":des} delegate:self];
    [self.getUserDesTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * tagsArr = [[result valueForKey:@"data"] valueForKey:@"word"];
        NSMutableArray * tagsMarr = [NSMutableArray array];
        if (tagsArr.count > 10) {
            for (NSUInteger idx = 0; idx < 10; ++ idx) {
                [tagsMarr addObject:tagsArr[idx]];
            }
        } else {
            tagsMarr = [NSMutableArray arrayWithArray:tagsArr];
        }
        
        if (tagsArr.count > 0) {
            [self.addView getRecommendTagS:tagsMarr];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 发布场景
- (void)networkNewSceneData {
    NSString * title = [self.scenceView.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.scenceView.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * tags =  [self.addView.chooseTagMarr componentsJoinedByString:@","];

    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addDescription", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || tags.length <=0 || self.fSceneId.length <= 0) {
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
                                     @"tags":tags,
                                     @"scene_id":self.fSceneId,
                                     };
        
        self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
        
        [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSString * sceneId = [NSString stringWithFormat:@"%@",[[result valueForKey:@"data"] valueForKey:@"id"]];
            LookSceneViewController * sceneInfoVC = [[LookSceneViewController alloc] init];
            sceneInfoVC.sceneId = sceneId;
            [self.navigationController pushViewController:sceneInfoVC animated:YES];

            [SVProgressHUD dismiss];

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
    NSString * tags =  [self.addView.chooseTagMarr componentsJoinedByString:@","];
    
    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addFiuSceneDes", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || tags.length <=0) {
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
                                     @"tags":tags,
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

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    [self.view addSubview:self.bgImgView];
    [self.view bringSubviewToFront:self.navView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.addContentBtn];
    [self.view addSubview:self.addContent];
}

#pragma mark - 情景背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImg;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        effectView.alpha = 1.0f;
        [_bgImgView addSubview:effectView];
    }
    return _bgImgView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 88)];
        
        [_topView addSubview:self.addLocaiton];
        [_topView addSubview:self.addCategory];
    }
    return _topView;
}

#pragma mark - 添加地点
- (AddLocationView *)addLocaiton {
    if (!_addLocaiton) {
        _addLocaiton = [[AddLocationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _addLocaiton.vc = self;
    }
    return _addLocaiton;
}

#pragma mark - 添加分类
- (AddCategoryView *)addCategory {
    if (!_addCategory) {
        _addCategory = [[AddCategoryView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
        _addCategory.vc = self;
    }
    return _addCategory;
}

#pragma mark - 添加内容按钮
- (UIButton *)addContentBtn {
    if (!_addContentBtn) {
        _addContentBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 100, SCREEN_WIDTH - 15, 44)];
        [_addContentBtn setTitle:NSLocalizedString(@"addContent", nil) forState:(UIControlStateNormal)];
        _addContentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addContentBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.8] forState:(UIControlStateNormal)];
        _addContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addContentBtn addTarget:self action:@selector(addContentBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH - 15, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
        [_addContentBtn addSubview:lineLab];
    }
    return _addContentBtn;
}

#pragma mark - 改变视图位置，弹出内容输入框
- (void)addContentBtnClick {
    CGRect topRect = CGRectMake(0, -100, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:.3 animations:^{
        self.topView.frame = topRect;
        self.addContentBtn.alpha = 0;
    }];

    CGRect contentRect = CGRectMake(0, 100, SCREEN_WIDTH, 200);
    [UIView animateWithDuration:0.3 animations:^{
        self.addContent.frame = contentRect;
    }];
}

#pragma mark - 内容视图
- (AddContentView *)addContent {
    if (!_addContent) {
        _addContent = [[AddContentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        _addContent.vc = self;
    }
    return _addContent;
}

#pragma mark - 添加文字信息的视图
- (ScenceMessageView *)scenceView {
    if (!_scenceView) {
        _scenceView = [[ScenceMessageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 236.5)];
        _scenceView.vc = self;
        _scenceView.delegate = self;
    }
    return _scenceView;
}

- (void)EditDoneGoGetTags:(NSString *)des {
    [self networkGetUserDesTags:_scenceView.title.text withDes:des];
}

#pragma mark - 添加位置／标签／所属情景的视图
- (ScenceAddMoreView *)addView {
    if (!_addView) {
        _addView = [[ScenceAddMoreView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT- 290)];
        _addView.nav = self.navigationController;
        _addView.vc = self;
        
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"freleaseVcTitle", nil)];
    }

    self.navTitle.textColor = [UIColor whiteColor];
    [self.cancelDoneBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
    [self addCancelDoneButton];
    [self addDoneButton];
    self.line.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:0.3];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"a" object:nil];
}

@end
