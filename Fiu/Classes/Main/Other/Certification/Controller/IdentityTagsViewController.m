//
//  IdentityTagsViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "IdentityTagsViewController.h"
#import "IdentityTagModel.h"
#import "TagsCollectionViewCell.h"
#import "TheOfficialCertificationViewController.h"

#define ITEMS_COLLECTIONVIEW_TAG 7
#define SELECTED_COLLECTIONVIEW_TAG 8

@interface IdentityTagsViewController ()<FBNavigationBarItemsDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *deletAllBtn;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property(nonatomic,strong) UICollectionView *selectedCollectionView;
@property (nonatomic,strong) UICollectionView *itemsCollectionView;
@property (nonatomic,strong) NSMutableArray *modelAry;
@property(nonatomic ,strong) NSMutableArray *selectedModelAry;

@end

@implementation IdentityTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"身份标签";
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 3;
    
    self.titleTextField.delegate = self;
    
    NSArray *tagsAry = [NSArray arrayWithObjects:@"老司机",@"过气网红",@"梦想家",@"先锋派",@"小鲜肉",@"肌肉男",@"路人甲",@"外星人",@"未知生物",@"特殊人物",@"老炮儿",@"特种兵",@"孤独癖",@"夜猫子",@"party animal",@"玻璃心",@"专治不服",@"帅到爆炸",@"德艺双馨",@"少女萌妹子",@"铲屎猫奴",@"素人", nil];
    for (int i = 0; i< tagsAry.count; i++) {
        IdentityTagModel *model = [[IdentityTagModel alloc] init];
        model.tags = tagsAry[i];
        [self.modelAry addObject:model];
    }
    
    [self.view addSubview:self.itemsCollectionView];
    [self.view addSubview:self.selectedCollectionView];
    self.selectedCollectionView.hidden = YES;
    
    self.deletAllBtn.hidden = YES;
    [self.deletAllBtn addTarget:self action:@selector(clickDeletAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn addTarget:self action:@selector(clickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickApplyBtn:(UIButton*)sender{
    TheOfficialCertificationViewController *vc = [[TheOfficialCertificationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickDeletAllBtn:(UIButton*)sender{
    if (self.selectedModelAry.count) {
        [self.selectedModelAry removeAllObjects];
        [self.selectedCollectionView reloadData];
        sender.hidden = YES;
        self.selectedCollectionView.hidden = YES;
    }
    if (self.titleTextField.text.length) {
        self.titleTextField.text = @"";
    }
    if (self.titleTextField.isEditing) {
        
    }else{
        sender.hidden = YES;
        self.tipLabel.hidden = NO;
        self.itemsCollectionView.userInteractionEnabled = YES;
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
        _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.selectedView.frame.origin.y+self.selectedView.frame.size.height+3, SCREEN_WIDTH, 300/667.0*SCREEN_HEIGHT) collectionViewLayout:layOut];
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
        _selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.selectedView.frame.origin.y, SCREEN_WIDTH-40, self.selectedView.frame.size.height) collectionViewLayout:layOut];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tipLabel.hidden = YES;
    self.deletAllBtn.hidden = NO;
    self.itemsCollectionView.userInteractionEnabled = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.tipLabel.hidden = NO;
        self.deletAllBtn.hidden = YES;
        self.itemsCollectionView.userInteractionEnabled = YES;
    }else{
        self.tipLabel.hidden = YES;
        self.deletAllBtn.hidden = NO;
        self.itemsCollectionView.userInteractionEnabled = NO;
    }
}

-(void)leftBarItemSelected{
    if (self.selectedModelAry.count !=0 || self.titleTextField.text.length !=0) {
        NSString *idStr;
        if (self.titleTextField.text.length == 0) {
            idStr = ((IdentityTagModel*)self.selectedModelAry[0]).tags;
        }else{
            idStr = self.titleTextField.text;
        }
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
        } failure:^(FBRequest *request, NSError *error) {
            
        }];

    }
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
