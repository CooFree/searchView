//
//  ViewController.m
//  searchView
//
//  Created by yssj on 2016/12/27.
//  Copyright © 2016年 CooFree. All rights reserved.
//

#import "ViewController.h"
#import "PYSearchViewController.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong,nonatomic)UIButton *cancelBtn;
@property (strong, nonatomic) PYSearchViewController *searchController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationView];
    
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.searchBar];
    

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
    titlelable.text = @"获得额度明细";
//    titlelable.font = [UIFont systemFontOfSize:ZOOM(57)];
//    titlelable.textColor=kMainTitleColor;
    titlelable.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:titlelable];
    
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headview.frame.size.height, kScreenWidth, 0.5)];
//    line.backgroundColor = kNavLineColor;
//    [headview addSubview:line];
    
}
@end
