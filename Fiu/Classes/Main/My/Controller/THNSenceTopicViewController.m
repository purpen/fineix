//
//  THNSenceTopicViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSenceTopicViewController.h"
#import <MJExtension.h>
#import "THNTopicsModel.h"
#import "THNSenceTopicView.h"
#import "UIView+FSExtension.h"
#import "UIColor+Extension.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <SVProgressHUD.h>
#import "UserInfoEntity.h"
#import "UserInfo.h"

@interface THNSenceTopicViewController ()
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *btnAry;
/**  */
@property (nonatomic, strong) NSMutableArray *viewAry;
@end

static NSString *getList = @"/category/getlist";

@implementation THNSenceTopicViewController


-(NSMutableArray *)btnAry{
    if (!_btnAry) {
        _btnAry = [NSMutableArray array];
    }
    return _btnAry;
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        
        NSLog(@"result  %@",result);
        
        NSArray *rowsAry = result[@"data"][@"rows"];
        self.modelAry = [THNTopicsModel mj_objectArrayWithKeyValuesArray:rowsAry];
        for (int i = 1; i <= self.modelAry.count; i ++) {
            
            float w = ([UIScreen mainScreen].bounds.size.width - 40 -10) * 0.5;
            float h = 0.092 * [UIScreen mainScreen].bounds.size.height;
            float x = 20 + ((i - 1) % 2) * (w + 10);
            float y = 175 + ((i - 1) / 2) * (h + 10);
            
            THNSenceTopicView *view = [THNSenceTopicView viewFromXib];
            view.frame = CGRectMake(x, y,w , h);
            view.model = self.modelAry[i - 1];
            [self.view addSubview:view];
            view.tipBtn.tag = i - 1;
            [view.tipBtn addTarget:self action:@selector(tipClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnAry addObject:view.tipBtn];
            [self.viewAry addObject:view];
            
        }
        
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        NSLog(@"五 %@",entity.interest_scene_cate);
        for (int i = 0; i < self.modelAry.count; i ++) {
            THNTopicsModel *model = self.modelAry[i];
            if ([entity.interest_scene_cate rangeOfString:model._id].location != NSNotFound) {
                ((THNSenceTopicView*)self.viewAry[i]).tipBtn.selected = YES;
                ((THNSenceTopicView*)self.viewAry[i]).layerView.backgroundColor = [UIColor colorWithHexString:@"#70510B" alpha:0.4];
                ((THNSenceTopicView*)self.viewAry[i]).textImagView.image = [UIImage imageNamed:@"l_topic_s"];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)update{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
        NSArray *ary = [result objectForKey:@"data"][@"interest_scene_cate"];
        NSLog(@"用户  %@",result);
        NSMutableString *str = [NSMutableString string];
        for (int i = 0; i < ary.count; i ++) {
            [str appendString:[NSString stringWithFormat:@"%@",ary[i]]];
            if (i == ary.count - 1) {
                break;
            }
            [str appendString:@","];
        }
        userInfo.interest_scene_cate = str;
        
        userInfo.head_pic_url = [result objectForKey:@"data"][@"head_pic_url"];
        NSArray *areasAry = [NSArray arrayWithArray:dataDict[@"areas"]];
        if (areasAry.count) {
            userInfo.prin = areasAry[0];
            userInfo.city = areasAry[1];
        }
        userInfo.is_expert = [result objectForKey:@"data"][@"identify"][@"is_expert"];
        [userInfo saveOrUpdate];
        [userInfo updateUserInfoEntity];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)tipClick:(UIButton*)sender{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:@"/my/remove_interest_scene_id" requestDictionary:@{
                                                                                                       @"id" : ((THNTopicsModel*)self.modelAry[sender.tag])._id
                                                                                                       } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            if (result[@"success"]) {
                [self update];
                sender.selected = NO;
                ((THNSenceTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).textImagView.image = [UIImage imageNamed:@"l_topic_u"];
                ((THNSenceTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).layerView.backgroundColor = sender.selected ? [UIColor colorWithHexString:@"#70510B" alpha:0.4] : [UIColor colorWithHexString:@"#525252" alpha:0.4];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        FBRequest *request = [FBAPI postWithUrlString:@"/my/add_interest_scene_id" requestDictionary:@{
                                                                                                       @"id" : ((THNTopicsModel*)self.modelAry[sender.tag])._id
                                                                                                       } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            if (result[@"success"]) {
                [self update];
                sender.selected = YES;
                ((THNSenceTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).textImagView.image = [UIImage imageNamed:@"l_topic_s"];
                ((THNSenceTopicView*)self.viewAry[[self.btnAry indexOfObject:sender]]).layerView.backgroundColor = sender.selected ? [UIColor colorWithHexString:@"#70510B" alpha:0.4] : [UIColor colorWithHexString:@"#525252" alpha:0.4];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    
}

@end
