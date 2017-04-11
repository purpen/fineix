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
#import "THNUserData.h"
#import "IdentityTagModel.h"
#import "TagsCollectionViewCell.h"
#import "UIView+FSExtension.h"

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
@property(nonatomic,copy) NSString *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsHeghitConstent;
@end

static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation ChangeSumaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    //self.navigationController.navigationBarHidden = NO;
    self.navViewTitle.text = NSLocalizedString(@"individualitySignature", nil);
    [self addBarItemRightBarButton:NSLocalizedString(@"save", nil) image:nil isTransparent:NO];
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    self.sumaryTF.text = userdata.summary;
    self.sumaryTF.delegate = self;
    
    NSArray *tagsAry1 = [NSArray arrayWithObjects:@"创业先锋",@"IT互联网",@"设计师",@"女神",@"公务员",@"职场新人",@"女强人",@"白领",@"学生",@"买手",@"程序猿",@"BOSS",@"直男",@"驴友",@"吃货",@"单身",@"文艺范", nil];
    for (int i = 0; i< tagsAry1.count; i++) {
        IdentityTagModel *model = [[IdentityTagModel alloc] init];
        model.tags = tagsAry1[i];
        [self.modelAry addObject:model];
    }
    [self.itemsView addSubview:self.itemsCollectionView];
    switch ((int)SCREEN_HEIGHT) {
        case 736:
            self.itemsHeghitConstent.constant = 130;
            break;
        case 667:
            self.itemsHeghitConstent.constant = 160;
            break;
        case 568:
            self.itemsHeghitConstent.constant = 180;
            break;
            
        default:
            break;
    }
    
    [self.view layoutIfNeeded];
    [self.selectedView addSubview:self.selectedCollectionView];
    self.selectedCollectionView.hidden = YES;
    self.deletAllBtn.hidden = YES;
    [self.deletAllBtn addTarget:self action:@selector(clickDeletAllBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.selectedModelAry removeAllObjects];
    IdentityTagModel *model = [[IdentityTagModel alloc] init];
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if (userdata.label.length == 0) {
        
    }else{
        model.tags = userdata.label;
        [self.selectedModelAry addObject:model];
        [self.selectedCollectionView reloadData];
        self.deletAllBtn.hidden = NO;
        self.selectedCollectionView.hidden = NO;
    }
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
        layOut.minimumInteritemSpacing = 0;
        layOut.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        switch ((int)SCREEN_HEIGHT) {
            case 736:
                _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) collectionViewLayout:layOut];
                break;
            case 667:
                _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) collectionViewLayout:layOut];
                break;
            case 568:
                _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) collectionViewLayout:layOut];
                break;
                
            default:
                break;
        }
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
        CGSize size = [model.tags sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        
        return CGSizeMake(size.width+30, 35);
    }else{
        IdentityTagModel *model = self.selectedModelAry[indexPath.row];
        CGSize size = [model.tags sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        
        return CGSizeMake(size.width+30, 35);
    }
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    if (self.sumaryTF.text.length == 0 && self.selectedModelAry.count !=0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Content is empty", nil)];
    }else{
        if (self.sumaryTF.text.length == 0) {
        }else if (self.sumaryTF.text.length > 30) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Individuality signature is too long", nil)];
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
            [request startRequestSuccess:^(FBRequest *request, id result) {
                THNUserData *userdata = [[THNUserData findAll] lastObject];
                userdata.label = idStr;
                [userdata saveOrUpdate];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
    }
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        THNUserData *userdata = [[THNUserData findAll] lastObject];
        userdata.summary = self.sumaryTF.text;
        [userdata saveOrUpdate];
        [SVProgressHUD showSuccessWithStatus:message];
    }else{
        [SVProgressHUD showInfoWithStatus:message];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
