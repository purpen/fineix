//
//  EditViewController.m
//  Fiu
//
//  Created by FLYang on 16/6/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditViewController.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
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
    NSLog(@"%@", self.data);
    [self setReleaseViewUI];
}

#pragma mark - 网络请求
#pragma mark 编辑场景
- (void)networkNewSceneData {
    NSString * title = [self.scenceView.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.scenceView.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addDescription", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || self.tagS.length <=0 || self.fSceneId.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"填写未完成"];
        
    } else if (title.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
        
    } else {
        NSDictionary * paramDict = @{
                                     @"id":self.ids,
                                     @"title":title,
                                     @"des":des,
                                     @"lng":self.lng,
                                     @"lat":self.lat,
                                     @"address":self.addView.location.text,
                                     @"tags":self.tagS,
                                     @"scene_id":self.fSceneId,
                                     };
        
        self.editSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
        
        [self.editSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.editDone();
            }];
            
        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 编辑情景
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
        NSDictionary * paramDict = @{
                                     @"id":self.ids,
                                     @"title":title,
                                     @"des":des,
                                     @"lng":self.lng,
                                     @"lat":self.lat,
                                     @"address":self.addView.location.text,
                                     @"tags":self.tagS,
                                     };
        self.editSceneRequest = [FBAPI postWithUrlString:URLReleaseFiuScenen requestDictionary:paramDict delegate:self];
        
        [self.editSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.editDone();
            }];
            
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
        _scenceView.title.text = [self.data valueForKey:@"title"];
        _scenceView.content.text = [self.data valueForKey:@"des"];
        [_scenceView.imageView downloadImage:[self.data valueForKey:@"cover_url"] place:[UIImage imageNamed:@""]];
    }
    return _scenceView;
}

#pragma mark - 添加位置／标签／所属情景的视图
- (EditSceneAddMoreView *)addView {
    if (!_addView) {
        _addView = [[EditSceneAddMoreView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT- 290)];
        _addView.vc = self;
        //  地址
        _addView.location.text = [self.data valueForKey:@"address"];
        _addView.addLoacationBtn.hidden = YES;
        _addView.locationView.hidden = NO;
        self.lng = [NSString stringWithFormat:@"%@", [[self.data valueForKey:@"location"] valueForKey:@"coordinates"][0]];
        self.lat = [NSString stringWithFormat:@"%@", [[self.data valueForKey:@"location"] valueForKey:@"coordinates"][1]];
        //  标签
        [_addView changeTagFrame];
        _addView.chooseTagMarr = [self.data valueForKey:@"tag_titles"];
        _addView.chooseTagIdMarr = [self.data valueForKey:@"tags"];
        self.tagS = [[self.data valueForKey:@"tags"] componentsJoinedByString:@","];
        //  所属情景
        self.fSceneId = [NSString stringWithFormat:@"%@", [self.data valueForKey:@"scene_id"]];
        [_addView changeSceneFrame:[self.data valueForKey:@"scene_title"]];
    }
    return _addView;
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"editScene", nil)];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"editFiuScene", nil)];
    }
    
    self.navTitle.textColor = [UIColor blackColor];
    [self addCloseBtn];
    [self addDoneButton];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认修改
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        [self networkNewSceneData];
        
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self networkNewFiuSceneData];
    }
}

@end
