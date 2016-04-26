//
//  SubscribeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribeViewController.h"
#import "AllSceneCollectionViewCell.h"

@interface SubscribeViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    self.navigationItem.title = @"订阅的情景";
    self.navigationController.navigationBarHidden = NO;
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    //
    [self.view addSubview:self.myCollectionView];
    
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-15)/2, (16/9.0)*(SCREEN_WIDTH-15)/2);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"collectionViewCellId";
    AllSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:id forIndexPath:indexPath];
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
