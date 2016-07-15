//
//  TheOfficialCertificationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TheOfficialCertificationViewController.h"
#import "Fiu.h"
#import "CertIdView.h"
#import "IdentityTagModel.h"
#import "TagsCollectionViewCell.h"
#import "UIImage+Helper.h"
#import "UIImagePickerController+Flag.h"
#import "SVProgressHUD.h"
#import "AccountManagementViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ITEMS_COLLECTIONVIEW_TAG 9
#define SELECTED_COLLECTIONVIEW_TAG 10

@interface TheOfficialCertificationViewController ()<FBNavigationBarItemsDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FBRequestDelegate>
{
    NSString *_idIcon64Str;
    NSString *_cardIcon64Str;
}

@property(nonatomic,strong) UIScrollView *myScrollView;
@property(nonatomic,strong) UICollectionView *itemsCollectionView;
@property(nonatomic,strong) CertIdView *certView;
@property(nonatomic,strong) NSMutableArray *modelAry;
@property(nonatomic,strong) UICollectionView *selectedCollectionView;
@property(nonatomic ,strong) NSMutableArray *selectedModelAry;

@property(nonatomic,copy) NSString *expert_label;
@property(nonatomic,copy) NSString *info;
@property(nonatomic,copy) NSString *contact;
@property(nonatomic,copy) NSString *id_card_cover_url;
@property(nonatomic,copy) NSString *business_card_cover_url;
@property(nonatomic,copy) NSString *idd;

/** 标志 */
@property (nonatomic, strong) NSNumber *verified;

@end

@implementation TheOfficialCertificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"官方认证";
    
    [self.view addSubview:self.myScrollView];
    self.myScrollView.contentSize = CGSizeMake(0, self.certView.frame.origin.y+self.certView.frame.size.height);
    
    NSArray *tagsAry1 = [NSArray arrayWithObjects:@"大咖",@"行家",@"媒体",@"摄影师",@"匠人",@"CEO",@"设计狮",@"红人",@"诗人", nil];
    for (int i = 0; i< tagsAry1.count; i++) {
        IdentityTagModel *model = [[IdentityTagModel alloc] init];
        model.tags = tagsAry1[i];
        [self.modelAry addObject:model];
    }
    
    [self.certView.itemView addSubview:self.itemsCollectionView];
    [self.certView.selectedView addSubview:self.selectedCollectionView];
    self.selectedCollectionView.hidden = YES;
    self.certView.deleAllBtn.hidden = YES;
    [self.certView.deleAllBtn addTarget:self action:@selector(clickDeletAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.certView.subBtn addTarget:self action:@selector(clickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/my/fetch_talent" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        self.verified = [dataDict objectForKey:@"verified"];
        if ([[result objectForKey:@"verified"] isEqual:@(-1)]) {
            //第一次，要提交
            
        }else{
            //不是第一次，要编辑
            
            //获取数据------
            if (![dataDict[@"_id"] isKindOfClass:[NSNull class]]) {
                self.idd = dataDict[@"_id"];
            }
            if (![dataDict[@"label"] isKindOfClass:[NSNull class]]) {
                self.expert_label = dataDict[@"label"];
            }
            if (![dataDict[@"info"] isKindOfClass:[NSNull class]]) {
                self.info = dataDict[@"info"];
            }
            if (![dataDict[@"contact"] isKindOfClass:[NSNull class]]) {
                self.contact = dataDict[@"contact"];
            }
            if (![dataDict[@"id_card_cover_url"] isKindOfClass:[NSNull class]]) {
                self.id_card_cover_url = dataDict[@"id_card_cover_url"];
            }
            if (![dataDict[@"business_card_cover_url"] isKindOfClass:[NSNull class]]) {
                self.business_card_cover_url = dataDict[@"business_card_cover_url"];
            }
            //-----------
            
            //展示---------
            if (self.expert_label.length != 0) {
                IdentityTagModel *model = [[IdentityTagModel alloc] init];
                model.tags = self.expert_label;
                [self.selectedModelAry addObject:model];
                [self.selectedCollectionView reloadData];
                self.selectedCollectionView.hidden = NO;
                self.certView.deleAllBtn.hidden = self.selectedModelAry.count == 0;
            }
            if (self.info.length != 0) {
                self.certView.informationTF.text = self.info;
            }
            if (self.contact.length != 0) {
                self.certView.phoneTF.text = self.contact;
            }
            if (self.id_card_cover_url.length != 0) {
                [self.certView.idImageView sd_setImageWithURL:[NSURL URLWithString:self.id_card_cover_url]];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.id_card_cover_url]];
                NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:[UIImage imageWithData:data]] , 0.5);
                _idIcon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            if (self.business_card_cover_url.length != 0) {
                [self.certView.cardImageView sd_setImageWithURL:[NSURL URLWithString:self.business_card_cover_url]];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.business_card_cover_url]];
                NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:[UIImage imageWithData:data]] , 0.5);
                _cardIcon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            //----------
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)clickApplyBtn:(UIButton*)sender{
    if (self.certView.informationTF.text.length == 0 || self.selectedModelAry.count == 0 || self.certView.phoneTF.text.length==0 || _idIcon64Str.length==0 || _cardIcon64Str.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请完善信息"];
    }else{
        //提交
        NSString *idStr;
        idStr = ((IdentityTagModel*)self.selectedModelAry[0]).tags;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if ([self.verified isEqual:@(-1)]) {
            FBRequest *requset = [FBAPI postWithUrlString:@"/my/talent_save" requestDictionary:@{
                                                                                                 @"info":self.certView.informationTF.text,
                                                                                                 @"label":idStr,
                                                                                                 @"contact":self.certView.phoneTF.text,
                                                                                                 @"id_card_a_tmp":_idIcon64Str,
                                                                                                 @"business_card_tmp":_cardIcon64Str
                                                                                                 } delegate:self];
            [requset startRequestSuccess:^(FBRequest *request, id result) {
                if ([result objectForKey:@"success"]) {
                    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                    //                AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
                    //                [self.navigationController popToViewController:vc animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
            } failure:^(FBRequest *request, NSError *error) {
            }];
        }else{
            FBRequest *requset = [FBAPI postWithUrlString:@"/my/talent_save" requestDictionary:@{
                                                                                                 @"id":self.idd,
                                                                                                 @"info":self.certView.informationTF.text,
                                                                                                 @"label":idStr,
                                                                                                 @"contact":self.certView.phoneTF.text,
                                                                                                 @"id_card_a_tmp":_idIcon64Str,
                                                                                                 @"business_card_tmp":_cardIcon64Str
                                                                                                 } delegate:self];
            [requset startRequestSuccess:^(FBRequest *request, id result) {
                if ([result objectForKey:@"success"]) {
                    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                    //                AccountManagementViewController *vc = [[AccountManagementViewController alloc] init];
                    //                [self.navigationController popToViewController:vc animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
            } failure:^(FBRequest *request, NSError *error) {
            }];
        }
    }
}

-(void)clickDeletAllBtn:(UIButton*)sender{
    [self.selectedModelAry removeAllObjects];
    [self.selectedCollectionView reloadData];
    sender.hidden = YES;
    self.selectedCollectionView.hidden = YES;
}

-(UICollectionView *)itemsCollectionView{
    if (!_itemsCollectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 2;
        layOut.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.certView.itemView.frame.size.height) collectionViewLayout:layOut];
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
        _selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, self.certView.selectedView.frame.size.height) collectionViewLayout:layOut];
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
    self.certView.deleAllBtn.hidden = NO;
    self.selectedCollectionView.hidden = NO;
}

-(void)clickSelectedTagBtn:(UIButton*)sender{
    IdentityTagModel *model = self.selectedModelAry[sender.tag];
    [self.selectedModelAry removeObject:model];
    [self.selectedCollectionView reloadData];
    self.certView.deleAllBtn.hidden = self.selectedModelAry.count == 0;
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


-(NSMutableArray *)selectedModelAry{
    if (!_selectedModelAry) {
        _selectedModelAry = [NSMutableArray array];
    }
    return _selectedModelAry;
}


-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _myScrollView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _myScrollView.showsVerticalScrollIndicator = NO;
        [_myScrollView addSubview:self.certView];
    }
    return _myScrollView;
}

-(CertIdView *)certView{
    if (!_certView) {
        _certView = [CertIdView getCertView];
        _certView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 800);
        [_certView.idBtn addTarget:self action:@selector(clickIdBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_certView.cardBtn addTarget:self action:@selector(clickCardBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certView;
}


-(void)clickCardBtn:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传名片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.flag = @1;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.flag = @1;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([picker.flag isEqualToNumber:@1]) {
        self.certView.cardImageView.image = editedImg;
        [self.certView.cardBtn setTitle:nil forState:UIControlStateNormal];
        NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
        _cardIcon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else if ([picker.flag isEqualToNumber:@0]){
        self.certView.idImageView.image = [UIImage fixOrientation:editedImg];
        [self.certView.idBtn setTitle:nil forState:UIControlStateNormal];
        NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
        _idIcon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
//    [self uploadIconWithData:iconData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//上传
- (void)uploadIconWithData:(NSData *)iconData
{
//    NSString * icon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSDictionary * params = @{@"type": @3, @"tmp": icon64Str};
//    FBRequest * request = [FBAPI postWithUrlString:IconURL requestDictionary:params delegate:self];
//    request.flag = IconURL;
//    [request startRequest];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}


-(void)clickIdBtn:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传身份证" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.flag = @0;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.flag = @0;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.certView.tipLabel.hidden = YES;
    self.certView.deleAllBtn.hidden = NO;
    self.itemsCollectionView.userInteractionEnabled = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.certView.titleTextFied.text.length == 0) {
        self.certView.tipLabel.hidden = NO;
        self.certView.deleAllBtn.hidden = YES;
        self.itemsCollectionView.userInteractionEnabled = YES;
    }else{
        self.certView.tipLabel.hidden = YES;
        self.certView.deleAllBtn.hidden = NO;
        self.itemsCollectionView.userInteractionEnabled = NO;
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
