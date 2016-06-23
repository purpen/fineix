//
//  CollectionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CollectionViewController.h"
#import "GoodsRow.h"
#import "SVProgressHUD.h"
#import "GoodsTableViewCell.h"
#import "FBRefresh.h"
#import "UserInfoEntity.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 收藏的商品数组 */
@property (nonatomic, strong) NSMutableArray *goodsList;
/** 收藏的商品id数组 */
@property (nonatomic, strong) NSMutableArray *goodsIdList;
@property (weak, nonatomic) IBOutlet UITableView *collectionGoodsTableView;
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPageNum;
/** 总页数 */
@property (nonatomic, assign) NSInteger totalPageNum;
@end

static NSString *GoodsTableViewCellId = @"GoodsTableViewCellId";
static NSString *const URLFiuGoods = @"/favorite/get_new_list";

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [_collectionGoodsTableView registerClass:[GoodsTableViewCell class] forCellReuseIdentifier:GoodsTableViewCellId];
    [self headerAndFooter];
}

#pragma mark - 上拉  &  下拉
-(void)headerAndFooter{
    _collectionGoodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    _collectionGoodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNum < _totalPageNum) {
            [self loadMoreData];
        }else{
            [_collectionGoodsTableView.mj_footer endRefreshing];
            _collectionGoodsTableView.mj_footer.hidden = YES;
        }
    }];
}

#pragma mark -上拉加载更多
-(void)loadMoreData{
    _currentPageNum ++;
    [self getCollectionGoodsFromeNet];
    [_collectionGoodsTableView.mj_footer endRefreshing];
}

#pragma mark - 下拉刷新
-(void)loadNewData{
    _currentPageNum = 0;
    [_goodsIdList removeAllObjects];
    [_goodsList removeAllObjects];
    [self getCollectionGoodsFromeNet];
    [_collectionGoodsTableView.mj_header endRefreshing];
}

#pragma mark - 根据页码进行头尾的处理
-(void)dealWithHeaderAndFooterAccordingToTheNumWithResult:(id)result{
    _currentPageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
    _totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
    if (_totalPageNum==0 || _currentPageNum==_totalPageNum) {
        _collectionGoodsTableView.mj_footer.state = MJRefreshStateNoMoreData;
        _collectionGoodsTableView.mj_footer.hidden = YES;
    }
    
}

#pragma mark - 收藏的商品数组
-(NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

#pragma mark - 收藏的商品id数组
-(NSMutableArray *)goodsIdList{
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCollectionGoodsFromeNet];
}


#pragma mark - 从网络获取收藏的商品数据
-(void)getCollectionGoodsFromeNet{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:URLFiuGoods requestDictionary:@{
                                                                                  @"size":@"8",
                                                                                  @"page":@(_currentPageNum+1),
                                                                                  @"sort":@"2",
                                                                                  @"type":@"10",
                                                                                  @"event":@"1",
                                                                                  @"user_id":entity.userId
                                                                          } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
            [_collectionGoodsTableView reloadData];
            [self dealWithHeaderAndFooterAccordingToTheNumWithResult:result];
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark - 导航条设置
-(void)setNavi{
    self.navViewTitle.text = @"收藏";
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsTableViewCellId];
    cell.nav = self.navigationController;
    [cell setGoodsData:self.goodsList[indexPath.row]];
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
