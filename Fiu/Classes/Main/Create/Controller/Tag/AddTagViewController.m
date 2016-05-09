//
//  AddTagViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddTagViewController.h"
#import "ChooseTagsCollectionViewCell.h"
#import "UsedTagCollectionViewCell.h"
#import "TagFlowLayout.h"

static NSString *const URLUserTag = @"/my/my_recent_tags";
static NSString *const URLAllTag = @"/scene_tags/getlist";
static NSInteger const MENUTAG = 235;

@interface AddTagViewController ()

@pro_strong NSMutableArray      *   chooseTagMarr;  //  选择的标签
@pro_strong NSMutableArray      *   userTagMarr;    //  使用过的标签
@pro_strong NSMutableArray      *   hotTagMarr;     //  热门的标签

@end

@implementation AddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self networkTagListData];
    [self networkUsedTagsData];
    
    [self setAddTagVcUI];
}

#pragma mark - 网络请求
#pragma mark 标签列表
- (void)networkTagListData {
    self.tagRequest = [FBAPI getWithUrlString:URLAllTag requestDictionary:@{@"type":@"1"} delegate:self];
    [self.tagRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"一级标签：%@", [[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"title_cn"]);
        NSLog(@"一级下的二级标签：%@", [[[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"children"] valueForKey:@"title_cn"]);
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 热门标签
- (void)networkHotTagData {
    [self.hotTagMarr removeAllObjects];
    
    self.hotTagsRequest = [FBAPI getWithUrlString:URLAllTag requestDictionary:@{@"type":@"1",@"sort":@"3",@"page":@"1",@"size":@"100",@"is_hot":@"1"} delegate:self];
    [self.hotTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * arr = [NSArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"rows"]];
        if (arr.count > 20) {
            for (NSInteger idx = 0; idx < 20; ++ idx) {
                [self.hotTagMarr addObject:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title_cn"][idx]];
            }
        } else {
            for (NSInteger idx = 0; idx < arr.count; ++ idx) {
                [self.hotTagMarr addObject:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title_cn"][idx]];
            }
        }
        if (self.hotTagMarr.count > 0) {
            self.noneView.hidden = YES;
        }
        [self changeFrame];
        
        [self.usedTagView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 使用过的标签
- (void)networkUsedTagsData {
    [self.hotTagMarr removeAllObjects];
    
    self.usedTagsRequest = [FBAPI getWithUrlString:URLUserTag requestDictionary:@{@"type":@"1"} delegate:self];
    [self.usedTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.hotTagMarr = [[[result valueForKey:@"data"] valueForKey:@"tags"] valueForKey:@"title_cn"];
        if (self.hotTagMarr.count == 0) {
            self.noneView.hidden = NO;
        }
        
        [self.usedTagView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma makr - 页面设置
- (void)setAddTagVcUI {
    
    [self.view addSubview:self.chooseTagView];
    
    [self.view addSubview:self.clearTagsBtn];
    
    [self.view addSubview:self.menuView];
    
    [self .view addSubview:self.usedTagView];
    
    [self.view addSubview:self.noneView];
}

#pragma mark -
- (void)changeFrame {
    CGFloat frameW = 0;
    for (NSInteger idx = 0; idx < self.hotTagMarr.count; ++ idx) {
        CGFloat tagW = [self.hotTagMarr[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        frameW += (tagW + 60);
    }
    
    self.usedTagView.frame = CGRectMake(0, 159, SCREEN_WIDTH, (frameW/SCREEN_WIDTH) * 40);
}

#pragma mark - 选中的标签列表
- (UICollectionView *)chooseTagView {
    if (!_chooseTagView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1.0f;
        flowLayout.minimumInteritemSpacing = 1.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _chooseTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH - 44,44) collectionViewLayout:flowLayout];
        _chooseTagView.backgroundColor = [UIColor whiteColor];
        _chooseTagView.delegate = self;
        _chooseTagView.dataSource = self;
        _chooseTagView.showsHorizontalScrollIndicator = NO;
        [_chooseTagView registerClass:[ChooseTagsCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell"];
    }
    return _chooseTagView;
}

#pragma mark － 使用过的标签 & 热门标签
#pragma mark 导航菜单
- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 59)];
        _menuView.backgroundColor = [UIColor whiteColor];
        
        NSArray * titleArr = @[@"使用过的标签", @"热门标签"];
        for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
            UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2 * idx, 0, SCREEN_WIDTH/2, 44)];
            [menuBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateSelected)];
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            menuBtn.tag = MENUTAG + idx;
            if (menuBtn.tag == MENUTAG) {
                menuBtn.selected = YES;
                self.menuBtn = menuBtn;
            }
            [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_menuView addSubview:menuBtn];
            
            [_menuView addSubview:self.menuLine];
            
            UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            bottomLine.backgroundColor = [UIColor colorWithHexString:grayLineColor];
            [_menuView addSubview:bottomLine];
        }
    }
    return _menuView;
}

- (UILabel *)menuLine {
    if (!_menuLine) {
        _menuLine = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, SCREEN_WIDTH/2 - 80, 4)];
        _menuLine.backgroundColor = [UIColor colorWithHexString:fineixColor];
    }
    return _menuLine;
}

#pragma mark 底部选项的点击事件
- (void)menuBtnClick:(UIButton *)button {
    CGRect lineRect = self.menuLine.frame;
    lineRect = CGRectMake(40 + (SCREEN_WIDTH/2 * (button.tag - MENUTAG)), 40, SCREEN_WIDTH/2 - 80, 4);
    [UIView animateWithDuration:.3 animations:^{
        self.menuLine.frame = lineRect;
    }];
    
    self.menuBtn.selected = NO;
    button.selected = YES;
    self.menuBtn = button;
    
    if (button.tag == MENUTAG) {
        [self networkUsedTagsData];
        
    } else if (button.tag == MENUTAG + 1) {
        [self networkHotTagData];
    }
}

- (UICollectionView *)usedTagView {
    if (!_usedTagView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        
        _usedTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 159, SCREEN_WIDTH, 140) collectionViewLayout:flowLayout];
        _usedTagView.delegate = self;
        _usedTagView.dataSource = self;
        _usedTagView.backgroundColor = [UIColor whiteColor];
        _usedTagView.showsVerticalScrollIndicator = NO;
        _usedTagView.scrollEnabled = NO;
        [_usedTagView registerClass:[UsedTagCollectionViewCell class] forCellWithReuseIdentifier:@"UsedTagCollectionViewCell"];
    }
    return _usedTagView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.chooseTagView) {
        return self.chooseTagMarr.count;
   
    } else if (collectionView == self.usedTagView) {
        if (self.hotTagMarr.count > 0) {
            return self.hotTagMarr.count;
        } else {
            return 0;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.chooseTagView) {
        ChooseTagsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTagsCollectionViewCell" forIndexPath:indexPath];
        [cell.tagBtn setTitle:self.chooseTagMarr[indexPath.row] forState:(UIControlStateNormal)];
        return cell;
    
    } else if (collectionView == self.usedTagView) {
        UsedTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UsedTagCollectionViewCell" forIndexPath:indexPath];
        if (self.hotTagMarr.count > 0) {
            cell.tagLab.text = self.hotTagMarr[indexPath.row];
        }
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.chooseTagView) {
        CGFloat tagW = [self.chooseTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        return CGSizeMake(tagW + 30, 35);
    
    } else if (collectionView == self.usedTagView) {
        if (self.hotTagMarr.count > 0) {
            CGFloat tagW = [self.hotTagMarr[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
            return CGSizeMake(tagW + 35, 29);
        }
    }
    
    return CGSizeMake(0, 0);
}

#pragma mark - 选择标签
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.usedTagView) {
        if (![self.chooseTagMarr containsObject:self.hotTagMarr[indexPath.row]]) {
            [self.chooseTagMarr insertObject:self.hotTagMarr[indexPath.row] atIndex:0];
        } else {
            [SVProgressHUD showInfoWithStatus:@"不可选择重复的标签哦～"];
        }
        [self.chooseTagView reloadData];
    
    } else if (collectionView == self.chooseTagView) {
        [self.chooseTagMarr removeObject:self.chooseTagMarr[indexPath.row]];
        [self.chooseTagView reloadData];
    }

}

#pragma mark - 提示
- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] initWithFrame:CGRectMake(0, 159, SCREEN_WIDTH, 130)];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
        lab.text = @"没有使用记录";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
        [_noneView addSubview:lab];
    }
    return _noneView;
}

#pragma mark - 清除全部标签
- (UIButton *)clearTagsBtn {
    if (!_clearTagsBtn) {
        _clearTagsBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 50, 44, 44)];
        [_clearTagsBtn setImage:[UIImage imageNamed:@"clear"] forState:(UIControlStateNormal)];
        _clearTagsBtn.backgroundColor = [UIColor whiteColor];
        [_clearTagsBtn addTarget:self action:@selector(clearTagsBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _clearTagsBtn;
}

- (void)clearTagsBtnClick {
    if (self.chooseTagMarr.count > 0) {
        [self.chooseTagMarr removeAllObjects];
        [self.chooseTagView reloadData];
    }
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"addTagVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self addBackButton:@"icon_back"];
    [self.navView addSubview:self.sureBtn];
}


#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
    }
    return _sureBtn;
}

#pragma mark - 
- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}

- (NSMutableArray *)userTagMarr {
    if (!_userTagMarr) {
        _userTagMarr = [NSMutableArray array];
    }
    return _userTagMarr;
}

- (NSMutableArray *)hotTagMarr {
    if (!_hotTagMarr) {
        _hotTagMarr = [NSMutableArray array];
    }
    return _hotTagMarr;
}

@end
