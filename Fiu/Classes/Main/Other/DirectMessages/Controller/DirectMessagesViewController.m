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
#import "UserInfoEntity.h"
#import "Fiu.h"

@interface DirectMessagesViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextView *chatTFV;
@property (weak, nonatomic) IBOutlet UIButton *expressionBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic,strong) NSMutableArray *modelAry;
@property(nonatomic,strong) ChatTableViewCell *cell;

@end

@implementation DirectMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = self.nickName;
    
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 2;
    self.chatTFV.layer.masksToBounds = YES;
    self.chatTFV.layer.cornerRadius = 2;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.chatTFV.delegate = self;
    //获取数据
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/message" requestDictionary:@{@"page":@1,@"size":@10,@"from_user_id":entity.userId,@"type":@0} delegate:self];
    [request startRequest];
    
    
}


-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([result objectForKey:@"success"]) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *mailboxAry = [dataDict objectForKey:@"mailbox"];
        for (NSDictionary *mailboxDict in mailboxAry) {
            AXModel *model = [[AXModel alloc] init];
            model.type = AXModelTypeMe;
            model.content = mailboxDict[@"content"];
            model.created_at = mailboxDict[@"created_at"];
            [_modelAry addObject:model];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"myCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setUIWithModel:[_modelAry objectAtIndex:indexPath.row]];
    self.cell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cell.frame.size.height;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (IBAction)clickExpressionBtn:(UIButton *)sender {
}
- (IBAction)clickSendBtn:(UIButton *)sender {
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
