//
//  ViewController.m
//  searchView
//
//  Created by yssj on 2016/12/27.
//  Copyright © 2016年 CooFree. All rights reserved.
//

#import "SearchTypeViewController.h"
#import "PYSearchViewController.h"
#import "WaterFLayout.h"
#import "CFWaterFLayout.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ReusableView : UICollectionReusableView

@property(nonatomic,strong)UILabel *nameLabel;

- (void)receiveWithNames:(NSString *)name;

@end

@implementation ReusableView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor=[UIColor whiteColor];
        _nameLabel.frame = CGRectMake(0, 10, SCREEN_WIDTH, 45);
//        _nameLabel.font = [UIFont systemFontOfSize:ZOOM(50)];
//        _nameLabel.textColor=
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)receiveWithNames:(NSString *)name{
    self.nameLabel.text=[NSString stringWithFormat:@"———  %@  ———",name];
}
@end

@interface SearchCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
- (void)receiveName:(NSString *)name;
@end
@implementation SearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-40)];
        _imageV.contentMode=UIViewContentModeScaleAspectFit;
        _imageV.backgroundColor=[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

//        imageV.layer.masksToBounds = YES;
//        imageV.layer.cornerRadius = ZOOM6(70)*0.5;
        [self.contentView addSubview:_imageV];
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
//        _nameLabel.font
//        _nameLabel.textColor=
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}
- (void)receiveName:(NSString *)name {
    self.nameLabel.text=name;
}

@end

@interface SearchTypeViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PYSearchViewControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong,nonatomic)UIButton *cancelBtn;
@property (strong, nonatomic) PYSearchViewController *searchController;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

static NSString * const reuseIdentifier = @"Cell";
static NSString *headerID = @"headerID";

@implementation SearchTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationView];
    
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.collectionView];
    
    self.searchController.hotSearches=@[@"1234",@"5678"];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self addChildViewController:self.searchController];

    [UIView animateWithDuration:0.5 animations:^{
        self.searchBar.frame=CGRectMake(0, 64, SCREEN_WIDTH-50, 40);
        self.cancelBtn.frame=CGRectMake(SCREEN_WIDTH-50, 64, 40, 40);
    }];
    self.searchController.baseSearchTableView.frame=CGRectMake(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40);

    [self.view addSubview:self.searchController.baseSearchTableView];
    [self.searchController didMoveToParentViewController:self];

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController saveSearchCacheAndRefreshView:searchBar];
}

- (void)leftBtnClick {
    [self addChildViewController:self.searchController];
    [self.view addSubview:self.searchController.view];
    [self.searchController didMoveToParentViewController:self];
    
//    self.searchController.searchBar.frame=CGRectMake(0, 20, 0, 44);
//    self.searchController.baseSearchTableView.alpha=0;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.searchController.searchBar.frame=CGRectMake(0, 20, SCREEN_WIDTH-40, 44);
//        self.searchController.baseSearchTableView.alpha=1;
//    }];
}
- (void)cancelBtnClick1 {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchController willMoveToParentViewController:nil];
        [self.searchController.view removeFromSuperview];
        [self.searchController removeFromParentViewController];
    }completion:^(BOOL finished) {
        
    }];
}
- (void)cancelBtnClick {
    [UIView animateWithDuration:0.5 animations:^{
        
        self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//        self.cancelBtn.frame=CGRectMake(SCREEN_WIDTH, 64, 40, 40);
        [self.searchBar endEditing:YES];
        self.searchBar.text=nil;
        
        [self.searchController willMoveToParentViewController:nil];
        [self.searchController.baseSearchTableView removeFromSuperview];
        [self.searchController removeFromParentViewController];
    }completion:^(BOOL finished) {
      

    }];
}
#pragma mark - PYSearchViewController
- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    [self cancelBtnClick1];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(section == 0)
    {
        return 3;
    }
    return arc4random()%8+4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell receiveName:[NSString stringWithFormat:@"%zd",indexPath.row]];
    
    return cell;
}

#pragma mark UICollectionView---section
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind != WaterFallSectionHeader)
        return nil;
//    if(indexPath.section == 0)
    {
//        _headerView =(CollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        _headerView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//        return _headerView;
//        return nil;
//    }else{
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        [header receiveWithNames:[NSString stringWithFormat:@"%zd",indexPath.section]];
        return header;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
//    if(section == 0)
//    {
//        return  60;
//    }
    return  55;
}
#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark item 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgH = 110;
    CGFloat imgW = 70;
    
    CGFloat W = (self.view.frame.size.width-18)/2.0;
    CGFloat H = imgH*W/imgW;
    
    CGSize size = CGSizeMake(W, H+5);
    return size;
}
#pragma mark - 懒加载

- (PYSearchViewController *)searchController {
    if (!_searchController) {
        
        // 1.创建热门搜索
        NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
        // 2. 创建控制器
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // 开始搜索执行以下代码
            // 如：跳转到指定控制器
//            [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
        }];
        // 3. 设置风格
        
        searchViewController.hotSearchStyle = 0; // 热门搜索风格根据选择
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag; // 搜索历史风格为default
        searchViewController.searchResultShowMode=PYSearchResultShowModePush;
        // 4. 设置代理
        searchViewController.delegate=self;
        _searchController=searchViewController;
        
    }
    return _searchController;
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        CFWaterFLayout *flowLayout=[[CFWaterFLayout alloc]init];
        flowLayout.naviHeight=0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        flowLayout.minimumColumnSpacing=15;
        flowLayout.minimumInteritemSpacing=5;
        flowLayout.columnCount=4;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-64-40)collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        // Register cell classes
        [_collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader  withReuseIdentifier:headerID];
//        [_collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"HeaderView"];
    }
    return _collectionView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        UITextField *searchField=[_searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _searchBar.barTintColor=[UIColor whiteColor];
        [_searchBar.layer setBorderWidth:0.5f];
        [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _searchBar;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame=CGRectMake(SCREEN_WIDTH-50, 64, 40, 40);
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _cancelBtn.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    return  _cancelBtn;
}
- (void)setNavgationView {
    //导航条
    UIImageView *headview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63)];
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    headview.userInteractionEnabled=YES;
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(0, 20, 46, 46);
    [backbtn setImage:[UIImage imageNamed:@"返回按钮_正常"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:backbtn];
    
    UILabel *titlelable=[[UILabel alloc]init];
    titlelable.frame=CGRectMake(0, 0, 300, 40);
    titlelable.center=CGPointMake(SCREEN_WIDTH/2, headview.frame.size.height/2+10);
    titlelable.text = @"全部分类";
//    titlelable.font = [UIFont systemFontOfSize:ZOOM(57)];
//    titlelable.textColor=kMainTitleColor;
    titlelable.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:titlelable];
    
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headview.frame.size.height, kScreenWidth, 0.5)];
//    line.backgroundColor = kNavLineColor;
//    [headview addSubview:line];
    
}
@end
