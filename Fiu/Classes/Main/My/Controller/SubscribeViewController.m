//
//  SubscribeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribeViewController.h"
#import "AllSceneCollectionViewCell.h"
#import "UserInfoEntity.h"
#import <SVProgressHUD.h>
#import "FiuSceneViewController.h"
#import "FiuSceneRow.h"

@interface SubscribeViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBRequestDelegate>
{
    NSMutableArray      *   _fiuSceneListData;     //  情景Model
    NSMutableArray      *   _fiuSceneIdData;       //  情景Id
}
@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fiuSceneListData = [NSMutableArray array];
    _fiuSceneIdData = [NSMutableArray array];
    //设置导航
    self.navViewTitle.text = @"订阅的情景";
    //self.navigationItem.title = @"订阅的情景";
    //self.navigationController.navigationBarHidden = NO;
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    //
    [self.view addSubview:self.myCollectionView];
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/favorite" requestDictionary:@{@"page":@1,@"size":@8,@"user_id":entity.userId,@"type":@"scene",@"event":@"subscription"} delegate:self];
    [request startRequest];
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    [SVProgressHUD show];
    if ([result objectForKey:@"success"]) {
        
        [SVProgressHUD dismiss];
    }else{
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-15)/2, (16/9.0)*(SCREEN_WIDTH-15)/2);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _fiuSceneListData.count;;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"collectionViewCellId";
    AllSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:id forIndexPath:indexPath];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
    fiuSceneVC.fiuSceneId = _fiuSceneIdData[indexPath.row];
    [self.navigationController pushViewController:fiuSceneVC animated:YES];
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
