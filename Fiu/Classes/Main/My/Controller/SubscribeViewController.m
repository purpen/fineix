//
//  SubscribeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribeViewController.h"
#import "FiuSceneCollectionViewCell.h"

@interface SubscribeViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    self.navigationItem.title = @"订阅的情景";
    self.navigationController.navigationBarHidden = NO;
    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    //
    [self.view addSubview:self.myCollectionView];
    //
    [self.view addSubview:self.myTableView];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(360*0.5/667.0*SCREEN_HEIGHT, 640*0.5/667.0*SCREEN_HEIGHT);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 0, -10);
        flowLayout.minimumInteritemSpacing = 3.0;
        flowLayout.minimumLineSpacing = 2.5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[FiuSceneCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"collectionViewCellId";
    FiuSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:id forIndexPath:indexPath];
    [cell setUI];
    return cell;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
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
