//
//  THNCuXiaoDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoDetalViewController.h"
#import "THNCuXiaoDetalModel.h"
#import "THNCuXiaoDetalTopView.h"
#import "UIView+FSExtension.h"
#import "THNCuXiaoDetalContentTableViewCell.h"
#import <MJExtension.h>
#import "THNProductModel.h"

@interface THNCuXiaoDetalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITableView *contenView;
/**  */
@property (nonatomic, strong) THNCuXiaoDetalModel *model;
/**  */
@property (nonatomic, strong) THNCuXiaoDetalTopView *topView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;

@end

static NSString *const cellId = @"THNCuXiaoDetalContentTableViewCell";

@implementation THNCuXiaoDetalViewController

-(THNCuXiaoDetalTopView *)topView{
    if (!_topView) {
        _topView = [THNCuXiaoDetalTopView viewFromXib];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 211);
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navViewTitle.text = @"促销详情";
    
    self.contenView.tableHeaderView = self.topView;
    
    [self.contenView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.id
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"促销详情 %@",result);
            self.model = [THNCuXiaoDetalModel mj_objectWithKeyValues:result[@"data"]];
            self.topView.model = self.model;
            [self.contenView reloadData];
        }
    } failure:nil];

}

- (IBAction)share:(id)sender {
}

- (IBAction)comment:(id)sender {
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    THNCuXiaoDetalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    self.modelAry = [THNProductModel mj_objectArrayWithKeyValuesArray:self.model.products];
    cell.model = self.modelAry[indexPat.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((THNProductModel*)self.modelAry[indexPath.row]).cellHeight;
}

@end
