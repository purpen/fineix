//
//  ChangeSumaryViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChangeSumaryViewController.h"
#import "SVProgressHUD.h"
#import "FBAPI.h"
#import "UserInfoEntity.h"
#import "IdentityTagModel.h"
#import "TagsCollectionViewCell.h"

#define ITEMS_COLLECTIONVIEW_TAG 7
#define SELECTED_COLLECTIONVIEW_TAG 8

@interface ChangeSumaryViewController ()<FBNavigationBarItemsDelegate,FBRequestDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletAllBtn;
@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet UITextField *sumaryTF;
@property(nonatomic,strong) UICollectionView *selectedCollectionView;
@property (nonatomic,strong) UICollectionView *itemsCollectionView;
@property (nonatomic,strong) NSMutableArray *modelAry;
@property(nonatomic ,strong) NSMutableArray *selectedModelAry;

@end

static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation ChangeSumaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    //self.navigationController.navigationBarHidden = NO;
    self.navViewTitle.text = @"个性签名";
    [self addBarItemRightBarButton:@"完成" image:nil isTransparent:NO];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    self.sumaryTF.text = entity.summary;
    self.sumaryTF.delegate = self;
    
    NSArray *tagsAry = [NSArray arrayWithObjects:@"老司机",@"过气网红",@"梦想家",@"先锋派",@"小鲜肉",@"肌肉男",@"路人甲",@"外星人",@"未知生物",@"特殊人物",@"老炮儿",@"特种兵",@"孤独癖",@"夜猫子",@"party animal",@"玻璃心",@"专治不服",@"帅到爆炸",@"德艺双馨",@"少女萌妹子",@"铲屎猫奴",@"素人", nil];
    for (int i = 0; i< tagsAry.count; i++) {
        IdentityTagModel *model = [[IdentityTagModel alloc] init];
        model.tags = tagsAry[i];
        [self.modelAry addObject:model];
    }
    [self.itemsView addSubview:self.itemsCollectionView];
    [self.selectedView addSubview:self.selectedCollectionView];
    self.selectedCollectionView.hidden = YES;
    self.deletAllBtn.hidden = YES;
    [self.deletAllBtn addTarget:self action:@selector(clickDeletAllBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickDeletAllBtn:(UIButton*)sender{
    if (self.selectedModelAry.count) {
        [self.selectedModelAry removeAllObjects];
        [self.selectedCollectionView reloadData];
        sender.hidden = YES;
        self.selectedCollectionView.hidden = YES;
    }
}

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(UICollectionView *)itemsCollectionView{
    if (!_itemsCollectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 2;
        layOut.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.itemsView.frame.size.height) collectionViewLayout:layOut];
        _itemsCollectionView.showsVerticalScrollIndicator = NO;
        _itemsCollectionView.backgroundColor = [UIColor whiteColor];
        _itemsCollectionView.tag = ITEMS_COLLECTIONVIEW_TAG;
        _itemsCollectionView.delegate = self;
        _itemsCollectionView.dataSource = self;
        [_itemsCollectionView registerClass:[TagsCollectionViewCell class] forCellWithReuseIdentifier:@"TagsCollectionViewCell"];
    }
    return _itemsCollectionView;
}


-(UICollectionView *)selectedCollectionView{
    if (!_selectedCollectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 2;
        layOut.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, self.selectedView.frame.size.height) collectionViewLayout:layOut];
        _selectedCollectionView.showsHorizontalScrollIndicator = NO;
        _selectedCollectionView.backgroundColor = [UIColor whiteColor];
        _selectedCollectionView.tag = SELECTED_COLLECTIONVIEW_TAG;
        _selectedCollectionView.delegate = self;
        _selectedCollectionView.dataSource = self;
        [_selectedCollectionView registerClass:[TagsCollectionViewCell class] forCellWithReuseIdentifier:@"TagsCollectionViewCell"];
    }
    return _selectedCollectionView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == ITEMS_COLLECTIONVIEW_TAG) {
        return self.modelAry.count;
    }else{
        return self.selectedModelAry.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == ITEMS_COLLECTIONVIEW_TAG) {
        TagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagsCollectionViewCell" forIndexPath:indexPath];
        IdentityTagModel *model = self.modelAry[indexPath.row];
        [cell.tagBtn setTitle:model.tags forState:UIControlStateNormal];
        cell.tagBtn.tag = indexPath.row;
        [cell.tagBtn addTarget:self action:@selector(clickItemsTagsBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        TagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagsCollectionViewCell" forIndexPath:indexPath];
        IdentityTagModel *model = self.selectedModelAry[indexPath.row];
        [cell.tagBtn setTitle:model.tags forState:UIControlStateNormal];
        cell.tagBtn.tag = indexPath.row;
        [cell.tagBtn addTarget:self action:@selector(clickSelectedTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(void)clickItemsTagsBtn:(UIButton*)sender{
    [self.selectedModelAry removeAllObjects];
    IdentityTagModel *model = self.modelAry[sender.tag];
    [self.selectedModelAry addObject:model];
    [self.selectedCollectionView reloadData];
    self.deletAllBtn.hidden = NO;
    self.selectedCollectionView.hidden = NO;
}

-(void)clickSelectedTagBtn:(UIButton*)sender{
    IdentityTagModel *model = self.selectedModelAry[sender.tag];
    [self.selectedModelAry removeObject:model];
    [self.selectedCollectionView reloadData];
    self.deletAllBtn.hidden = self.selectedModelAry.count == 0;
}

-(NSMutableArray *)selectedModelAry{
    if (!_selectedModelAry) {
        _selectedModelAry = [NSMutableArray array];
    }
    return _selectedModelAry;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == ITEMS_COLLECTIONVIEW_TAG) {
        IdentityTagModel *model = self.modelAry[indexPath.row];
        CGSize size = [model.tags sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        
        return CGSizeMake(size.width+30, 35);
    }else{
        IdentityTagModel *model = self.selectedModelAry[indexPath.row];
        CGSize size = [model.tags sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        
        return CGSizeMake(size.width+30, 35);
    }
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    if (self.sumaryTF.text.length == 0 && self.selectedModelAry.count !=0) {
        [SVProgressHUD showErrorWithStatus:@"内容为空"];
    }else{
        if (self.sumaryTF.text.length == 0) {
        }else if (self.sumaryTF.text.length > 30) {
            [SVProgressHUD showErrorWithStatus:@"个性签名过长"];
        }else{
            //推送
            FBRequest *request = [FBAPI postWithUrlString:UpdateInfoURL requestDictionary:@{@"summary":self.sumaryTF.text} delegate:self];
            [request startRequest];
        }
        
        
        if (self.selectedModelAry.count !=0) {
            NSString *idStr = ((IdentityTagModel*)self.selectedModelAry[0]).tags;
            //上传
            FBRequest *request = [FBAPI postWithUrlString:@"/my/update_profile" requestDictionary:@{
                                                                                                    @"label":idStr
                                                                                                    } delegate:self];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.label = idStr;
            [entity updateUserInfo];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                entity.label = idStr;
                [entity updateUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
            
        }
        
    }
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.summary = self.sumaryTF.text;
        [entity updateUserInfo];
        NSLog(@"边间   %@",entity.summary);
        [SVProgressHUD showSuccessWithStatus:message];
    }else{
        [SVProgressHUD showInfoWithStatus:message];
    }
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
