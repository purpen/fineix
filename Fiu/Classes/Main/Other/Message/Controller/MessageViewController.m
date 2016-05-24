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
#import "UserInfoEntity.h"
#import "NSObject+MJKeyValue.h"

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
@property (nonatomic,strong) TipNumberView *alertTipviewNum;
@property (nonatomic,strong) TipNumberView *fiu_notice_countTipviewNum;
@property (nonatomic,strong) TipNumberView *fiu_comment_countTipviewNum;
@property (nonatomic,strong) TipNumberView *message_countTipviewNum;
@property (nonatomic,strong) TipNumberView *alert_countTipviewNum;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"消息";
}

-(TipNumberView *)fiu_comment_countTipviewNum{
    if (!_fiu_comment_countTipviewNum) {
        _fiu_comment_countTipviewNum = [TipNumberView getTipNumView];
    }
    return _fiu_comment_countTipviewNum;
}

-(TipNumberView *)message_countTipviewNum{
    if (!_message_countTipviewNum) {
        _message_countTipviewNum = [TipNumberView getTipNumView];
    }
    return _message_countTipviewNum;
}

-(TipNumberView *)fiu_notice_countTipviewNum{
    if (!_fiu_notice_countTipviewNum) {
        _fiu_notice_countTipviewNum = [TipNumberView getTipNumView];
    }
    return _fiu_notice_countTipviewNum;
}

-(TipNumberView *)alertTipviewNum{
    if (!_alertTipviewNum) {
        _alertTipviewNum = [TipNumberView getTipNumView];
    }
    return _alertTipviewNum;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self netGetData];
}

-(void)netGetData{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":entity.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"&&&&&&&&result %@",result);
        NSDictionary *dataDict = result[@"data"];
        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
        self.countModel = [CounterModel mj_objectWithKeyValues:counterDict];
        //-----------------------------------------------------
        if ([self.countModel.fiu_alert_count intValue] == 0) {
            [self.alertTipviewNum removeFromSuperview];
        }else{
            [self.remindView addSubview:self.alertTipviewNum];
            self.alertTipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.fiu_alert_count];
            CGSize size = [self.alertTipviewNum.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [self.alertTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(self.remindView.mas_right).with.offset(-30);
                make.centerY.mas_equalTo(self.remindView.mas_centerY);
            }];
        }
        
        if ([self.countModel.fiu_notice_count intValue] == 0) {
            [self.fiu_notice_countTipviewNum removeFromSuperview];
        }else{
            [self.noticeView addSubview:self.fiu_notice_countTipviewNum];
            self.fiu_notice_countTipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.fiu_notice_count];
            CGSize size = [self.fiu_notice_countTipviewNum.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [self.fiu_notice_countTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(self.noticeView.mas_right).with.offset(-30);
                make.centerY.mas_equalTo(self.noticeView.mas_centerY);
            }];
        }
        
        
        if ([self.countModel.fiu_comment_count intValue] == 0) {
            [self.fiu_comment_countTipviewNum removeFromSuperview];
        }else{
            [self.commentView addSubview:self.fiu_comment_countTipviewNum];
            self.fiu_comment_countTipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.fiu_comment_count];
            CGSize size = [self.fiu_comment_countTipviewNum.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [self.fiu_comment_countTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(self.commentView.mas_right).with.offset(-30);
                make.centerY.mas_equalTo(self.commentView.mas_centerY);
            }];
        }
        
        NSLog(@"私信数量  %@",self.countModel.message_count);
        
        
        
        if ([self.countModel.message_count intValue] == 0) {
            [self.message_countTipviewNum removeFromSuperview];
        }else{
            [self.messageView addSubview:self.message_countTipviewNum];
            self.message_countTipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.message_count];
            CGSize size = [self.message_countTipviewNum.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [self.message_countTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(self.messageView.mas_right).with.offset(-30);
                make.centerY.mas_equalTo(self.messageView.mas_centerY);
            }];
        }
        
        
        
        
        if ([self.countModel.alert_count intValue] == 0) {
            [self.alert_countTipviewNum removeFromSuperview];
        }else{
            [self.remindView addSubview:self.alert_countTipviewNum];
            self.alert_countTipviewNum.tipNumLabel.text = [NSString stringWithFormat:@"%@",self.countModel.alert_count];
            CGSize size = [self.alert_countTipviewNum.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
            [self.alert_countTipviewNum mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
                }else{
                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }
                make.right.mas_equalTo(self.remindView.mas_right).with.offset(-30);
                make.centerY.mas_equalTo(self.remindView.mas_centerY);
            }];
        }
        //------------------------------------------------------
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


- (IBAction)systemSendBtn:(UIButton *)sender {
    SystemInformsViewController *vc = [[SystemInformsViewController alloc] init];
    vc.num = [self.countModel.fiu_notice_count integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)commentsBtn:(UIButton *)sender {
    CommentsViewController *vc = [[CommentsViewController alloc] init];
    vc.num = [self.countModel.fiu_comment_count integerValue];
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
