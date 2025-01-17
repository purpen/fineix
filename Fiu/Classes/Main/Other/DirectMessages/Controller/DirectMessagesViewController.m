//
//  DirectMessagesViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DirectMessagesViewController.h"
#import "AXModel.h"
#import "ChatTableViewCell.h"
#import "FBAPI.h"
#import "THNUserData.h"
#import "Fiu.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DirectMessagesViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,FBRequestDelegate,UITableViewDataSource>
{
    int _n;
}
@property (nonatomic, strong) NSArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *myTableVuew;
@property (weak, nonatomic) IBOutlet UITextField *msgTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceing;
@property (weak, nonatomic) IBOutlet UIView *bottomToolView;

@end

@implementation DirectMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = self.nickName;
    self.myTableVuew.delegate = self;
    self.myTableVuew.dataSource = self;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 3;
    
    
    //设置文本框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    self.msgTF.leftView = view;
    self.msgTF.leftViewMode = UITextFieldViewModeAlways;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyBoardWillChangeFrame:(NSNotification*)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.bottomSpaceing.constant = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    if (self.messages.count == 0) {
        
    }else{
//        __block float heights = 0;
//        [self.messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            AXModel *message = obj;
//            heights += message.cellHeight;
//        }];
//        [self.myTableVuew setContentOffset:CGPointMake(0, heights) animated:NO];
        [self.myTableVuew setContentOffset:CGPointMake(0, self.messages.count*200) animated:NO];
    }
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self networkRequestData];
    
}

#pragma mark - 网络请求
- (void)networkRequestData {
    //进行情景的网络请求
    FBRequest *request = [FBAPI postWithUrlString:@"/message/view" requestDictionary:@{@"to_user_id":self.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * fiuSceneArr = [[result valueForKey:@"data"] valueForKey:@"mailbox"];
        // 字典数组 -> 模型数组
        NSMutableArray *messageArray = [NSMutableArray array];
        // 用来记录上一条消息模型
        AXModel *lastMessage = nil;
        for (NSDictionary * fiuSceneDic in fiuSceneArr) {
            
            AXModel *message = [AXModel messageWithDict:fiuSceneDic];
//            AXModel *message = [[AXModel alloc] init];
            //加载数据时，判断哪个时间值相等。
            message.hideTime = [message.created_at isEqualToString:lastMessage.created_at];
            [messageArray addObject:message];
            message.userId = self.userId;
            lastMessage = message;
            _n = (int)fiuSceneArr.count;
        }
        self.messages = messageArray;
        if (self.messages.count == 0) {
           
        }else{
            [self.myTableVuew setContentOffset:CGPointMake(0, self.messages.count*200) animated:NO];
        }
        [self.myTableVuew reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (NSArray *)messages
{
    if (_messages == nil) {
        _messages = [NSArray array];
    }
    return _messages;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    cell.cellNavi = self.navigationController;
    cell.message = self.messages[indexPath.row];
    [cell.otherIconImageView sd_setImageWithURL:[NSURL URLWithString:self.otherIconImageUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXModel *message = self.messages[indexPath.row];
    return message.cellHeight;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (IBAction)sendBtn:(UIButton *)sender {
    FBRequest *request = [FBAPI postWithUrlString:@"/message/ajax_message" requestDictionary:@{
                                                                                               @"to_user_id":self.userId,
                                                                                               @"content":self.msgTF.text
                                                                                               } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self networkRequestData];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    self.msgTF.text = @"";
    
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
