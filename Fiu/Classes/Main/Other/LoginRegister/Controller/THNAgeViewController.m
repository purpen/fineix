//
//  THNAgeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAgeViewController.h"
#import "THNAgeBtn.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <SVProgressHUD.h>
#import "UserInfoEntity.h"
#import "THNScenarioViewController.h"

@interface THNAgeViewController ()
/**  */
@property (nonatomic, strong) NSArray *ageAry;
/**  */
@property (nonatomic, strong) NSArray *labelAry;
/**  */
@property (nonatomic, strong) NSMutableArray *ageBtnAry;
/**  */
@property (nonatomic, strong) NSMutableArray *labelBtnAry;
/**  */
@property (nonatomic, strong) NSArray *contrastAry;
/**  */
@property(nonatomic,copy) NSString *age_group;
/**  */
@property(nonatomic,copy) NSString *assets;
@end

static NSString *updatInfo = @"/my/update_profile";

@implementation THNAgeViewController

-(NSArray *)ageAry{
    if (!_ageAry) {
        _ageAry = [NSArray arrayWithObjects:@"00后",@"90后",@"80后",@"70后",@"60后", nil];
    }
    return _ageAry;
}

-(NSArray *)contrastAry{
    if (!_contrastAry) {
        _contrastAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E", nil];
    }
    return _contrastAry;
}

-(NSMutableArray *)ageBtnAry{
    if (!_ageBtnAry) {
        _ageBtnAry = [NSMutableArray array];
    }
    return _ageBtnAry;
}

-(NSMutableArray *)labelBtnAry{
    if (!_labelBtnAry) {
        _labelBtnAry = [NSMutableArray array];
    }
    return _labelBtnAry;
}

-(NSArray *)labelAry{
    if (!_labelAry) {
        _labelAry = [NSArray arrayWithObjects:@"月光族",@"小资",@"新中产",@"土豪",@"大亨", nil];
    }
    return _ageAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < self.ageAry.count; i ++) {
        
        float w = 50;
        float h = 30;
        int x = [UIScreen mainScreen].bounds.size.width * 0.5 - w * 0.5;
        int y = 165 + i * h;
        
        THNAgeBtn *btn = [[THNAgeBtn alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [btn setTitle:_ageAry[i] forState:UIControlStateNormal];
        [self.ageBtnAry addObject:btn];
        [btn addTarget:self action:@selector(ageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
    
    for (int i = 0; i < self.labelAry.count; i ++) {
        
        float w = 50;
        float h = 33;
        int x = [UIScreen mainScreen].bounds.size.width * 0.5 - w * 0.5;
        int y = 333 + i * h;
        
        THNAgeBtn *btn = [[THNAgeBtn alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [btn setTitle:_labelAry[i] forState:UIControlStateNormal];
        [self.labelBtnAry addObject:btn];
        [btn addTarget:self action:@selector(labelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    }
    
    [self ageClick:self.ageBtnAry[0]];
    [self labelClick:self.labelBtnAry[0]];

}

-(void)ageClick:(UIButton*)sender{
    for (UIButton *btn  in self.ageBtnAry) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.age_group = self.contrastAry[self.ageBtnAry.count - 1 - [self.ageBtnAry indexOfObject:sender]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)labelClick:(UIButton*)sender{
    for (UIButton *btn  in self.labelBtnAry) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.assets = self.contrastAry[[self.labelBtnAry indexOfObject:sender]];
}

- (IBAction)next:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //开始传送数据
    NSDictionary *params = @{
                             @"age_group":self.age_group,
                             @"assets":self.assets,
                             };
    FBRequest *request = [FBAPI postWithUrlString:updatInfo requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            UserInfoEntity *entiey = [UserInfoEntity defaultUserInfoEntity];
            entiey.age_group = [result objectForKey:@"data"][@"age_group"];
            entiey.assets = [result objectForKey:@"data"][@"assets"];
            THNScenarioViewController *vc = [[THNScenarioViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
