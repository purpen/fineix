//
//  THNScenarioViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNScenarioViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <MJExtension.h>
#import "THNTopicsModel.h"
#import "THNTopicView.h"
#import "UIView+FSExtension.h"
#import "UIColor+Extension.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <SVProgressHUD.h>
#import "UserInfoEntity.h"
#import "THNFocusViewController.h"

@interface THNScenarioViewController ()

/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *btnAry;
/**  */
@property (nonatomic, strong) NSMutableArray *viewAry;
/**  */
@property (nonatomic, strong) UIButton *subscribeBtn;
/**  */
@property (nonatomic, strong) NSMutableArray *idAry;

@end

static NSString *getList = @"/category/getlist";

@implementation THNScenarioViewController

-(NSMutableArray *)btnAry{
    if (!_btnAry) {
        _btnAry = [NSMutableArray array];
    }
    return _btnAry;
}

-(NSMutableArray *)idAry{
    if (!_idAry) {
        _idAry = [NSMutableArray array];
    }
    return _idAry;
}

-(NSMutableArray *)viewAry{
    if (!_viewAry) {
        _viewAry = [NSMutableArray array];
    }
    return _viewAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBRequest *request = [FBAPI postWithUrlString:getList requestDictionary:@{
                                                                              @"domain" : @13
                                                                              } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rowsAry = result[@"data"][@"rows"];
        self.modelAry = [THNTopicsModel mj_objectArrayWithKeyValuesArray:rowsAry];
        for (int i = 1; i <= self.modelAry.count; i ++) {
            
            float w = ([UIScreen mainScreen].bounds.size.width - 40 -10) * 0.5;
            float h = 0.092 * [UIScreen mainScreen].bounds.size.height;
            float x = 20 + (i % 2) * (w + 10);
            float y = 175 + (i % 5) * (h + 10);
            
            THNTopicView *view = [THNTopicView viewFromXib];
            view.frame = CGRectMake(x, y,w , h);
            view.model = self.modelAry[i - 1];
            [self.view addSubview:view];
            
            [view.tipBtn addTarget:self action:@selector(tipClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnAry addObject:view.tipBtn];
            [self.viewAry addObject:view];
            
            if (i == self.modelAry.count) {
                self.subscribeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 70 * 0.5, 175 + 4 * (h + 10) + h + 15, 70, 24);
                [self.view addSubview:self.subscribeBtn];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(UIButton *)subscribeBtn{
    if (!_subscribeBtn) {
        _subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subscribeBtn setTitle:@"订阅全部" forState:UIControlStateNormal];
        _subscribeBtn.layer.masksToBounds = YES;
        _subscribeBtn.layer.cornerRadius = 3;
        _subscribeBtn.layer.borderWidth = 1;
        _subscribeBtn.layer.borderColor = [UIColor colorWithHexString:@"#7A7A7A"].CGColor;
        [_subscribeBtn setTitleColor:[UIColor colorWithHexString:@"#7A7A7A"] forState:UIControlStateNormal];
        [_subscribeBtn addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
        _subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subscribeBtn;
}

-(void)subscribe{
    for (UIButton *btn in self.btnAry) {
        btn.selected = YES;
        ((THNTopicView*)self.viewAry[[self.btnAry indexOfObject:btn]]).layerView.backgroundColor = [UIColor colorWithHexString:@"#70510B" alpha:0.4];
        [self.idAry addObject:((THNTopicView*)self.viewAry[[self.btnAry indexOfObject:btn]]).model._id];
    }
}

-(void)tipClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    ((THNTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).layerView.backgroundColor = sender.selected ? [UIColor colorWithHexString:@"#70510B" alpha:0.4] : [UIColor colorWithHexString:@"#525252" alpha:0.4];
    if (sender.selected) {
        [self.idAry addObject:((THNTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).model._id];
    }else{
        [self.idAry removeObject:((THNTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).model._id];
    }
}


- (IBAction)next:(id)sender {
    THNFocusViewController *vc = [[THNFocusViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSMutableString *str = [NSMutableString string];
//    for (int i = 0; i < self.idAry.count; i ++) {
//        [str appendString:self.idAry[i]];
//        if (i == self.idAry.count - 1) {
//            break;
//        }
//        [str appendString:@","];
//    }
//    
//    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    //开始传送数据
//    NSDictionary *params = @{
//                             @"interest_scene_cate":str
//                             };
//    FBRequest *request = [FBAPI postWithUrlString:@"/my/update_profile" requestDictionary:params delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSString * message = [result objectForKey:@"message"];
//        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
//            [SVProgressHUD showSuccessWithStatus:message];
//            THNFocusViewController *vc = [[THNFocusViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        } else {
//            [SVProgressHUD showInfoWithStatus:message];
//        }
//    } failure:^(FBRequest *request, NSError *error) {
//        
//    }];
}

@end
