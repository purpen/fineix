//
//  THNRemindViewController.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemindViewController.h"
#import "THNRemindTableViewCell.h"
#import "THNRemindModelRow.h"
#import "CommentNViewController.h"
#import "THNSceneDetalViewController.h"

static NSString *const URLRemind = @"/remind/getlist";
static NSString *const remindTableCellId = @"RemindTableCellId";

@interface THNRemindViewController ()

@end

@implementation THNRemindViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkReminData];
    [self thn_setRemindVcUI];
    
}

#pragma mark - 网络请求
- (void)thn_networkReminData {
    [SVProgressHUD show];
    self.remindRequest = [FBAPI getWithUrlString:URLRemind requestDictionary:@{@"page":@"1", @"size":@"100000"} delegate:self];
    [self.remindRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDic in dataArr) {
            THNRemindModelRow *model = [[THNRemindModelRow alloc] initWithDictionary:dataDic];
            [self.remindMarr addObject:model];
            [self.remindTypeMarr addObject:[NSString stringWithFormat:@"%zi", model.kind]];
            if (model.kind == 3) {
                [self.remindIdMarr addObject:[NSString stringWithFormat:@"%zi", model.commentTargetObj.idField]];
            } else {
                [self.remindIdMarr addObject:[NSString stringWithFormat:@"%zi", model.targetObj.idField]];
            }
            [self.sceneUserIdMarr addObject:[NSString stringWithFormat:@"%zi", model.userId]];
        }
        [self.remindTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图
- (void)thn_setRemindVcUI {
    [self.view addSubview:self.remindTable];
}

#pragma mark - 提醒列表
- (UITableView *)remindTable {
    if (!_remindTable) {
        _remindTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _remindTable.delegate = self;
        _remindTable.dataSource = self;
        _remindTable.tableFooterView = [UIView new];
    }
    return _remindTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remindMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:remindTableCellId];
    cell = [[THNRemindTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:remindTableCellId];
    if (self.remindMarr.count) {
        [cell thn_setRemindData:self.remindMarr[indexPath.row]];
        cell.nav = self.navigationController;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger openType = [self.remindTypeMarr[indexPath.row] integerValue];
    if (openType == 3) {
        CommentNViewController * commentVC = [[CommentNViewController alloc] init];
        commentVC.targetId = self.remindIdMarr[indexPath.row];
        commentVC.sceneUserId = self.sceneUserIdMarr[indexPath.row];
        [self.navigationController pushViewController:commentVC animated:YES];
    } else {
        THNSceneDetalViewController *sceneVC = [[THNSceneDetalViewController alloc] init];
        sceneVC.sceneDetalId = self.remindIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.remindTable;
    self.navViewTitle.text = NSLocalizedString(@"remindVC", nil);
}

#pragma mark - 
- (NSMutableArray *)remindMarr {
    if (!_remindMarr) {
        _remindMarr = [NSMutableArray array];
    }
    return _remindMarr;
}

- (NSMutableArray *)remindTypeMarr {
    if (!_remindTypeMarr) {
        _remindTypeMarr = [NSMutableArray array];
    }
    return _remindTypeMarr;
}

- (NSMutableArray *)remindIdMarr {
    if (!_remindIdMarr) {
        _remindIdMarr = [NSMutableArray array];
    }
    return _remindIdMarr;
}

- (NSMutableArray *)sceneUserIdMarr {
    if (!_sceneUserIdMarr) {
        _sceneUserIdMarr = [NSMutableArray array];
    }
    return _sceneUserIdMarr;
}

@end
