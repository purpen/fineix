//
//  MessagesssViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MessagesssViewController.h"
#import "CommentsTableViewCell.h"
#import "SVProgressHUD.h"
#import "UserInfoEntity.h"

@interface MessagesssViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
    int _totalePage;
}
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@end

@implementation MessagesssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"私信";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 65;
    
    //进行网络请求
    [self networkRequestData];
}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/message" requestDictionary:@{@"page":@(_page),@"size":@15,@"from_user_id":entity.userId,@"type":@0} delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"result  %@",result);
//        NSDictionary *dataDict = [result objectForKey:@"data"];
//        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
//        for (NSDictionary *rowsDict in rowsAry) {
//            NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
//            UserInfo *model = [[UserInfo alloc] init];
//            
//            model.userId = followsDict[@"user_id"];
//            NSLog(@"userid             %@",model.userId);
//            model.summary = followsDict[@"summary"];
//            model.nickname = followsDict[@"nickname"];
//            model.mediumAvatarUrl = followsDict[@"avatar_url"];
//            [_modelAry addObject:model];
//        }
//        if (_modelAry.count == 0) {
//            [self.view addSubview:self.tipLabel];
//            _tipLabel.text = @"快去关注别人吧";
//            [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(200, 30));
//                make.centerX.mas_equalTo(self.view.mas_centerX);
//                make.top.mas_equalTo(self.view.mas_top).with.offset(200);
//            }];
//        }else{
//            [self.tipLabel removeFromSuperview];
//        }
//        
//        [self.mytableView reloadData];
//        _page = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
//        _totalePage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
//        if (_totalePage > 1) {
//            [self addMJRefresh:self.mytableView];
//            [self requestIsLastData:self.mytableView currentPage:_page withTotalPage:_totalePage];
//        }
//        [SVProgressHUD dismiss];
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setUI];
    cell.iconImageView.hidden = YES;
    cell.focusBtn.hidden = YES;
    return cell;
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
