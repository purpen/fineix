//
//  GreatPeopleViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GreatPeopleViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "NSObject+MJKeyValue.h"
#import "SubscribePeopleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GreatPeopleViewController ()<FBRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_modelAry;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@end
static NSString *const subscribePeople = @"/favorite";

@implementation GreatPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订阅的人";
    //定制导航条返回按钮
    [self.navigationItem setHidesBackButton:YES];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(16,33, 10, 13);
    [backBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    //获取数据
    NSDictionary *params = @{@"id":self.scenarioID,
                             @"type":@"sight",
                             @"event":@"love"
                             };
    FBRequest *request = [FBAPI postWithUrlString:subscribePeople requestDictionary:params delegate:self];
    request.flag = subscribePeople;
    [request startRequest];
    //点击哪个cell，对应的model传到下一个界面
    
    
}

//请求数据成功后
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:subscribePeople]) {
        //获取到用户信息
        //数据转成模型
        UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"user"]];
        userinfo.whetherFocusOn = NO;
        //模型存进数组
        [_modelAry addObject:userinfo];
        //tabbleView刷新
        [_mytableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubscribePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SubscribePeopleTableViewCell getId]];
    if (cell == nil) {
        cell = [SubscribePeopleTableViewCell getSubscribePeopleTableViewCell];
    }
    cell.headImageView.layer.masksToBounds = YES;
    cell.headImageView.layer.cornerRadius = 21;
    UserInfo *model = _modelAry[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Dina Alexander"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    cell.nickNameLabel.text = model.nickname;
    cell.summaryLabel.text = model.summary;
    cell.focusedImageView.hidden = !model.whetherFocusOn;
    cell.focusOnImageView.hidden = model.whetherFocusOn;
    cell.focusBtn.tag = indexPath.row;
    [cell.focusBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)clickBtn:(UIButton*)sender{
    //跳转到他人的个人主页
    //将信息传过去
//    UserInfo *model = _modelAry[sender.tag];
    
}

-(void)clickFocusBtn:(UIButton*)sender{
    UserInfo *model = _modelAry[sender.tag];
    model.whetherFocusOn = !model.whetherFocusOn;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)clickbackBtn:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
