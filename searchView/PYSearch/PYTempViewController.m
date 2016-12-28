//
// //
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYTempViewController.h"
#import "PYSearchConst.h"
@interface PYTempViewController ()

@end

@implementation PYTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=YES;
    self.title = @"SearchResultViewController";
    self.view.backgroundColor = PYSEARCH_RANDOM_COLOR;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
}
- (void)viewDidDisappear:(BOOL)animated {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
