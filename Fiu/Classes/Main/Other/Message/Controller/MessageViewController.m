//
//  MessageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemInformsViewController.h"
#import "CommentsViewController.h"
#import "MessagesssViewController.h"
#import "TipNumberView.h"
#import "CounterModel.h"
#import "SVProgressHUD.h"
#import "MentionedViewController.h"

@interface MessageViewController ()<FBNavigationBarItemsDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
    int _totalePage;
}

@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *remindView;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"消息";
    if ([self.countModel.fiu_notice_count intValue] == 0) {
        
    }else{
        TipNumberView *tipviewNum = [TipNumberView getTipNumView];
        [self.noticeView addSubview:tipviewNum];
        tipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.fiu_notice_count];
        [tipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.right.mas_equalTo(self.noticeView.mas_right).with.offset(-30);
            make.centerY.mas_equalTo(self.noticeView.mas_centerY);
        }];
    }
    if ([self.countModel.fiu_comment_count intValue] == 0) {
        
    }else{
        TipNumberView *tipviewNum = [TipNumberView getTipNumView];
        [self.commentView addSubview:tipviewNum];
        tipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.fiu_comment_count];
        [tipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.right.mas_equalTo(self.commentView.mas_right).with.offset(-30);
            make.centerY.mas_equalTo(self.commentView.mas_centerY);
        }];
    }
    
    NSLog(@"私信数量  %@",self.countModel.message_count);
    if ([self.countModel.message_count intValue] == 0) {
        
    }else{
        TipNumberView *tipviewNum = [TipNumberView getTipNumView];
        [self.messageView addSubview:tipviewNum];
        tipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.message_count];
        [tipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.right.mas_equalTo(self.messageView.mas_right).with.offset(-30);
            make.centerY.mas_equalTo(self.messageView.mas_centerY);
        }];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进行网络请求
    //[self networkRequestData];
}

//#pragma mark - 网络请求
//- (void)networkRequestData {
//    [SVProgressHUD show];
//    FBRequest *request = [FBAPI postWithUrlString:@"/notice" requestDictionary:@{@"page":@(_page),@"size":@15} delegate:self];
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
//    
//}


- (IBAction)systemSendBtn:(UIButton *)sender {
    SystemInformsViewController *vc = [[SystemInformsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)commentsBtn:(UIButton *)sender {
    CommentsViewController *vc = [[CommentsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)directMessagesBtn:(UIButton *)sender {
    MessagesssViewController *vc = [[MessagesssViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)remindBtn:(UIButton *)sender {
    MentionedViewController *vc = [[MentionedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
