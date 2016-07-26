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
#import "AllTagListTableViewCell.h"
#import "LookAllTagBtnTableViewCell.h"
#import "OpenAllTagListTableViewCell.h"
#import "UpLookAllTagBtnTableViewCell.h"

static NSString *const URLUserTag = @"/my/my_recent_tags";
static NSString *const URLAllTag = @"/scene_tags/getlist";
static NSInteger const MENUTAG = 235;
static NSInteger const CATEGORYTAG = 283;

@interface AddTagViewController () {
    BOOL            isOpen;
    NSIndexPath  *  selectIndex;
    CGFloat         frameH;
}

@pro_strong NSMutableArray      *   chooseTagMarr;      //  选择的标签
@pro_strong NSMutableArray      *   chooseTagIdList;    //  选择的标签id
@pro_strong NSMutableArray      *   userTagMarr;        //  使用过的标签
@pro_strong NSMutableArray      *   hotTagMarr;         //  热门的标签
@pro_strong NSMutableArray      *   hotTagIdList;       //  热门标签id
@pro_strong NSMutableArray      *   usedTagMarr;        //  使用过的
@pro_strong NSMutableArray      *   fatherCategory;     //  父类
@pro_strong NSMutableArray      *   category;           //  父类下分类
@pro_strong NSMutableArray      *   categoryList;       //  父类下分类列表
@pro_strong NSMutableArray      *   childCategory;      //  分类下子类
@pro_strong NSMutableArray      *   tagIdList;          //  标签的id
@pro_strong NSMutableArray      *   childCategoryList;  //  分类下子类列表

@end

@implementation AddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self networkTagListData];
    [self networkHotTagData];
}

#pragma mark - 网络请求
#pragma mark 标签列表
- (void)networkTagListData {
    [SVProgressHUD show];
    self.tagRequest = [FBAPI getWithUrlString:URLAllTag requestDictionary:@{@"type":@"1"} delegate:self];
    [self.tagRequest startRequestSuccess:^(FBRequest *request, id result) {
        //  一级标签
        self.fatherCategory = [[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"];
        
        //  一级下的二级标签
        self.category = [[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"children"];
        self.categoryList = [self.category valueForKey:@"title_cn"][0];
        
        //  二级下的子级标签
        self.childCategory = [[[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"children"] valueForKey:@"children"];
        self.childCategoryList = [self.childCategory valueForKey:@"title_cn"][0];
        self.tagIdList = [self.childCategory valueForKey:@"_id"][0];
        
        [self addAllTagListView];
        [self networkUsedTagsData];
        [SVProgressHUD dismiss];
        
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
        for (NSInteger idx = 0; idx < arr.count; ++ idx) {
            [self.userTagMarr addObject:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title_cn"][idx]];
            [self.hotTagIdList addObject:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"][idx]];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 使用过的标签
- (void)networkUsedTagsData {
    [self.hotTagMarr removeAllObjects];
    self.usedTagsRequest = [FBAPI getWithUrlString:URLUserTag requestDictionary:@{@"type":@"1"} delegate:self];
    [self.usedTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.usedTagMarr = [[[result valueForKey:@"data"] valueForKey:@"tags"] valueForKey:@"title_cn"];
        if (self.usedTagMarr.count == 0) {
            self.noneView.hidden = NO;
        } else {
            self.noneView.hidden = YES;
            self.hotTagMarr = self.usedTagMarr;
            [self.usedTagView reloadData];
        }
        
        [self setAddTagVcUI];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma makr - 页面设置
- (UIScrollView *)rollView {
    if (!_rollView) {
        _rollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
        _rollView.showsVerticalScrollIndicator = NO;
    }
    return _rollView;
}

- (void)setAddTagVcUI {
    CGFloat frameW = 0;
    for (NSInteger idx = 0; idx < self.userTagMarr.count; ++ idx) {
        CGFloat tagW = [self.userTagMarr[idx] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        frameW += (tagW + 60);
    }
    
    frameH = (frameW/SCREEN_WIDTH) * 40;
    
    [self.view addSubview:self.chooseTagView];
    
    [self.view addSubview:self.clearTagsBtn];
    
    [self.view addSubview:self.rollView];
    
    [self.rollView addSubview:self.menuView];
    
    [self.rollView addSubview:self.usedTagView];
    
    [self.rollView addSubview:self.noneView];
    
    [self.rollView addSubview:self.centerView];
    
    [self.rollView addSubview:self.tagListTable];
}

- (void)addAllTagListView {
    //  调整视图大小
    self.rollView.contentSize = CGSizeMake(0, self.categoryList.count * 200 + 300);
}

#pragma mark － 使用过的标签 & 热门标签s
#pragma mark 导航菜单
- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
        _menuView.backgroundColor = [UIColor whiteColor];
        
        NSArray * titleArr = @[@"使用过的标签", @"热门标签"];
        for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
            UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2 * idx, 0, SCREEN_WIDTH/2, 44)];
            [menuBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateSelected)];
            menuBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
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

#pragma mark - 分类导航
- (UIView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger idx = 0; idx < self.fatherCategory.count; ++ idx) {
            UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/self.fatherCategory.count * idx, 0, SCREEN_WIDTH/self.fatherCategory.count, 44)];
            [menuBtn setTitle:[self.fatherCategory valueForKey:@"title_cn"][idx] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
            [menuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateSelected)];
            menuBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
            menuBtn.tag = CATEGORYTAG + idx;
            if (menuBtn.tag == CATEGORYTAG) {
                menuBtn.selected = YES;
                self.categoryBtn = menuBtn;
            }
            [menuBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_categoryView addSubview:menuBtn];
            
            [_categoryView addSubview:self.categoryLine];
            
            UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            bottomLine.backgroundColor = [UIColor colorWithHexString:grayLineColor];
            [_categoryView addSubview:bottomLine];
        }
    }
    return _categoryView;
}

- (UILabel *)categoryLine {
    if (!_categoryLine) {
        _categoryLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4/4, 40, SCREEN_WIDTH/4/2, 4)];
        _categoryLine.backgroundColor = [UIColor colorWithHexString:fineixColor];
    }
    return _categoryLine;
}

#pragma mark 使用过的标签&热门标签切换
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
        self.hotTagMarr = self.usedTagMarr;
        [self.usedTagView reloadData];
        
    } else if (button.tag == MENUTAG + 1) {
        self.hotTagMarr = self.userTagMarr;
        [self.usedTagView reloadData];
    }
    
    if (self.hotTagMarr.count > 0) {
        self.noneView.hidden = YES;
    } else if (self.hotTagMarr.count == 0) {
        self.noneView.hidden = NO;
    }
    
}

#pragma mark 全部标签分类导航
- (void)categoryBtnClick:(UIButton *)button {
    CGRect lineRect = self.categoryLine.frame;
    lineRect = CGRectMake(SCREEN_WIDTH/4/4 + (SCREEN_WIDTH/4 * (button.tag - CATEGORYTAG)), 40, SCREEN_WIDTH/4/2, 4);
    [UIView animateWithDuration:.3 animations:^{
        self.categoryLine.frame = lineRect;
    }];
    
    self.categoryBtn.selected = NO;
    button.selected = YES;
    self.categoryBtn = button;
    
    [self reloadAllTagListData:button.tag - CATEGORYTAG];

}

- (void)reloadAllTagListData:(NSInteger)index {
    isOpen = NO;
    self.categoryList = [self.category valueForKey:@"title_cn"][index];
    self.childCategoryList = [self.childCategory valueForKey:@"title_cn"][index];
    self.categoryList = [self.category valueForKey:@"title_cn"][index];
    self.tagIdList = [self.childCategory valueForKey:@"_id"][index];
    
    CGRect tagListRect = self.tagListTable.frame;
    tagListRect.size = CGSizeMake(SCREEN_WIDTH, self.categoryList.count * 200);
    self.tagListTable.frame = tagListRect;
    
    [self.tagListTable reloadData];
    
    self.rollView.contentSize = CGSizeMake(0, self.categoryList.count * 180 + (self.usedTagView.frame.size.height + 230));
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

- (UICollectionView *)usedTagView {
    if (!_usedTagView) {
        TagFlowLayout * flowLayout = [[TagFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        
        _usedTagView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 150) collectionViewLayout:flowLayout];
        _usedTagView.delegate = self;
        _usedTagView.dataSource = self;
        _usedTagView.backgroundColor = [UIColor whiteColor];
        _usedTagView.showsVerticalScrollIndicator = NO;
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
            [self.chooseTagMarr addObject:self.hotTagMarr[indexPath.row]];
            [self.chooseTagIdList addObject:self.hotTagIdList[indexPath.row]];
            [self changContent:self.chooseTagMarr.count];
        } else {
            [SVProgressHUD showInfoWithStatus:@"不可选择重复的标签哦～"];
        }
        [self.chooseTagView reloadData];
    
    } else if (collectionView == self.chooseTagView) {
        [self.chooseTagMarr removeObject:self.chooseTagMarr[indexPath.row]];
        [self.chooseTagIdList removeObject:self.chooseTagIdList[indexPath.row]];
        [self.chooseTagView reloadData];
    }

}

- (void)changContent:(NSInteger )index {
    CGPoint content = self.chooseTagView.contentOffset;
    content.x = 100 * index;
    self.chooseTagView.contentOffset = content;
}

#pragma mark - 提示
- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 130)];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
        lab.text = @"没有使用记录";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        [_noneView addSubview:lab];
    }
    return _noneView;
}

#pragma makr - 中部提示视图
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 45)];
        _centerView.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        
        UILabel * allLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
        allLab.text = @"全部标签";
        allLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        allLab.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:allLab];
        
        for (NSInteger idx = 0; idx < 2; ++ idx) {
            UILabel * li = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 + 50) * idx, 10, (SCREEN_WIDTH - 100) / 2, 1)];
            li.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            [allLab addSubview:li];
        }
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 13)];
        lab.text = @"请在情绪、环境、时间、人物中各选择一个";
        lab.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        lab.textColor = [UIColor colorWithHexString:titleColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:lab];
    }
    return _centerView;
}

#pragma mark - 全部标签列表
- (UITableView *)tagListTable {
    if (!_tagListTable) {
        _tagListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, self.categoryList.count * 250) style:(UITableViewStyleGrouped)];
        _tagListTable.delegate = self;
        _tagListTable.dataSource = self;
        _tagListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tagListTable.scrollEnabled = NO;
        _tagListTable.sectionFooterHeight = 0.01f;
        _tagListTable.sectionHeaderHeight = 0.01f;
        _tagListTable.backgroundColor = [UIColor whiteColor];
        _tagListTable.tableHeaderView = self.categoryView;

    }
    return _tagListTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categoryList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (isOpen && selectIndex.section == indexPath.section) {
            static NSString * openAllTagListTableViewCell = @"OpenAllTagListTableViewCell";
            OpenAllTagListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:openAllTagListTableViewCell];
            if (!cell) {
                cell = [[OpenAllTagListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:openAllTagListTableViewCell];
            }
            [cell setAllTagListData:self.categoryList[indexPath.section] withTagList:self.childCategoryList[indexPath.section] withTagId:self.tagIdList[indexPath.section]];
            cell.getTagDataBlock = ^(NSString * titlt, NSString * ids) {
                if (![self.chooseTagMarr containsObject:titlt]) {
                    [self.chooseTagMarr addObject:titlt];
                    [self.chooseTagIdList addObject:ids];
                    [self changContent:self.chooseTagMarr.count];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"不可选择重复的标签哦～"];
                }
                [self.chooseTagView reloadData];
            };
            return cell;
        
        } else {
            static NSString * allTagListTableViewCellId = @"AllTagListTableViewCellId";
            AllTagListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:allTagListTableViewCellId];
            if (!cell) {
                cell = [[AllTagListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:allTagListTableViewCellId];
            }
            [cell setAllTagListData:self.categoryList[indexPath.section] withTagList:self.childCategoryList[indexPath.section] withTagId:self.tagIdList[indexPath.section]];
            cell.getTagDataBlock = ^(NSString * titlt, NSString * ids) {
                if (![self.chooseTagMarr containsObject:titlt]) {
                    [self.chooseTagMarr addObject:titlt];
                    [self.chooseTagIdList addObject:ids];
                    [self changContent:self.chooseTagMarr.count];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"不可选择重复的标签哦～"];
                }
                [self.chooseTagView reloadData];
            };
            return cell;
        }
        
    } else if (indexPath.row == 1) {
        if (isOpen && selectIndex.section == indexPath.section) {
            static NSString * upLookAllTagBtnTableViewCell = @"UpLookAllTagBtnTableViewCell";
            UpLookAllTagBtnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:upLookAllTagBtnTableViewCell];
            if (!cell) {
                cell = [[UpLookAllTagBtnTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:upLookAllTagBtnTableViewCell];
            }
            return cell;
            
        } else {
            static NSString * lookAllTagBtnTableViewCell = @"LookAllTagBtnTableViewCell";
            LookAllTagBtnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:lookAllTagBtnTableViewCell];
            if (!cell) {
                cell = [[LookAllTagBtnTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:lookAllTagBtnTableViewCell];
            }
            return cell;
        }
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (isOpen && selectIndex.section == indexPath.section) {
            OpenAllTagListTableViewCell * cell = [[OpenAllTagListTableViewCell alloc] init];
            [cell getOpenTagListCellHeight:self.childCategoryList[indexPath.section]];
            return cell.cellHeight;
            
        } else {
            return 110;
        }
    } else if (indexPath.row == 1) {
        return 45;
    }
    return 0;
}

#pragma mark - 展开标签列表页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        OpenAllTagListTableViewCell * cell = [[OpenAllTagListTableViewCell alloc] init];
        [cell getOpenTagListCellHeight:self.childCategoryList[indexPath.section]];
        
        if ([indexPath isEqual:selectIndex]) {
            isOpen = NO;
            selectIndex = nil;
            [self.tagListTable reloadData];
            
            [UIView animateWithDuration:.2 animations:^{
                self.tagListTable.frame = CGRectMake(0, 290, SCREEN_WIDTH, (self.categoryList.count * 220));
                self.rollView.contentSize = CGSizeMake(0, self.categoryList.count * 180 + 380);
            }];
            
        } else {
            isOpen = YES;
            selectIndex = indexPath;
            [self.tagListTable reloadData];
            
            [UIView animateWithDuration:.2 animations:^{
                self.tagListTable.frame = CGRectMake(0, 290, SCREEN_WIDTH, (self.categoryList.count * 220) + cell.cellHeight);
                self.rollView.contentSize = CGSizeMake(0, self.categoryList.count * 180 + 300 + cell.cellHeight);
            }];
        }

    }
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
        [self.chooseTagIdList removeAllObjects];
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
    if ([self.type isEqualToString:@"release"]) {
        [self addBackButton:@"icon_back"];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self addCloseBtn];
    }
    [self.navView addSubview:self.sureBtn];
}


#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_ControllerTitle];
        [self.sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

#pragma makr - 确定选择的标签
- (void)sureBtnClick {
    self.chooseTagsBlock(self.chooseTagMarr, self.chooseTagIdList);
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 
- (NSMutableArray *)chooseTagMarr {
    if (!_chooseTagMarr) {
        _chooseTagMarr = [NSMutableArray array];
    }
    return _chooseTagMarr;
}

- (NSMutableArray *)chooseTagIdList {
    if (!_chooseTagIdList) {
        _chooseTagIdList = [NSMutableArray array];
    }
    return _chooseTagIdList;
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

- (NSMutableArray *)hotTagIdList {
    if (!_hotTagIdList) {
        _hotTagIdList = [NSMutableArray array];
    }
    return _hotTagIdList;
}

- (NSMutableArray *)categoryList {
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}

- (NSMutableArray *)childCategoryList {
    if (!_childCategoryList) {
        _childCategoryList = [NSMutableArray array];
    }
    return _childCategoryList;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

@end
