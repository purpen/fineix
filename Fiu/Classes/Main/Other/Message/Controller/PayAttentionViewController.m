//
//  PayAttentionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PayAttentionViewController.h"
#import "CommentsTableViewCell.h"
#import "MyFansActionSheetViewController.h"

@interface PayAttentionViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;

@end

@implementation PayAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"关注我的";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    self.myTbaleView.rowHeight = 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setUI];
    cell.iconImageView.hidden = YES;
    cell.msgLabel.text = @"关注了你";
    [cell.focusBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.focusBtn.tag = indexPath.row;
    return cell;
}

-(void)clickFocusBtn:(UIButton*)sender{
    
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        [sheetVC setUI];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:sheetVC animated:NO completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        sender.selected = !sender.selected;
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    CommentsTableViewCell *cell = [self.myTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.focusBtn.selected = NO;
//    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":@(sender.tag)} delegate:self];
//    request.flag = @"/follow/ajax_cancel_follow";
//    [request startRequest];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
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
