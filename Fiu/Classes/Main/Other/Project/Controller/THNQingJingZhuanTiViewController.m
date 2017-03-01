//
//  THNQingJingZhuanTiViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQingJingZhuanTiViewController.h"
#import "HomeSceneListRow.h"
#import "MJExtension.h"
#import "THNOneModel.h"
#import "THNQingJingOneCell.h"
#import "THNXiangGuanQingJingTableViewCell.h"
#import "THNSceneDetalViewController.h"
#import "Fiu.h"

@interface THNQingJingZhuanTiViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *tableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;

@end

@implementation THNQingJingZhuanTiViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[THNQingJingOneCell class] forCellReuseIdentifier:THNQINGJingOneCell];
    [self.tableView registerClass:[THNXiangGuanQingJingTableViewCell class] forCellReuseIdentifier:THNXIANGGuanQingJingTableViewCell];
    // Do any additional setup after loading the view.
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{@"id":self.qingJingZhuanTiID} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.modelAry removeAllObjects];
        NSDictionary *dataDict = result[@"data"];
        self.navViewTitle.text = dataDict[@"title"];
        THNOneModel *modelOne = [THNOneModel mj_objectWithKeyValues:dataDict];
        [self.modelAry addObject:modelOne];
        NSArray *ary = dataDict[@"sights"];
        for (NSDictionary *dict in ary) {
            HomeSceneListRow *model = [[HomeSceneListRow alloc] initWithDictionary:dict];
            [self.modelAry addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.modelAry.count == 0) {
        return 0;
    }
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        THNQingJingOneCell *cell = [tableView dequeueReusableCellWithIdentifier:THNQINGJingOneCell];
        THNOneModel *model = self.modelAry[0];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 1) {
        THNXiangGuanQingJingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:THNXIANGGuanQingJingTableViewCell];
        cell.nav = self.navigationController;
        cell.vc = self;
//        cell.biaoTiLabel.text = @"默认排序";
        NSMutableArray *ary = [NSMutableArray array];
        if (self.modelAry.count > 1) {
            for (int y = 1; y<self.modelAry.count; y++) {
                HomeSceneListRow *model = self.modelAry[y];
                [ary addObject:model];
            }
        }
        [cell haModelAry:ary];
        return cell;
    }
    UITableViewCell *cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HomeSceneListRow *model = self.modelAry[indexPath.row + 1];
        THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
        vc.sceneDetalId = [NSString stringWithFormat:@"%ld",(long)model.idField];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        THNOneModel *model = self.modelAry[0];
        if (model.summary.length == 0) {
            return 422/2;
        }
        CGRect rect = [model.summary boundingRectWithSize:CGSizeMake(300, 999)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                            context:nil];
        return (422)/2+rect.size.height+30*SCREEN_HEIGHT/667.0;
    } else {
        return (1100/2) * (self.modelAry.count - 1);
    }
    return 0;
}

@end
