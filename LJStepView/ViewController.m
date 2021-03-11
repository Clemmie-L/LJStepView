//
//  ViewController.m
//  LJStepView
//
//  Created by IMS_Mac on 2021/3/11.
//

#import "ViewController.h"
#import "LJStepView.h"
#import <WMPageController/WMPageController.h>
#import <Masonry/Masonry.h>
#import "testViewController.h"

@interface ViewController ()<LJStepViewDelegate,WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) LJStepView *stepView;
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.stepView];
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIApplication sharedApplication].statusBarFrame.size.height + 10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepView.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    
}

#pragma mark - WMPageControllerDelegate and WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}
- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    testViewController *vc = [[testViewController alloc]init];
    vc.label.text = [NSString stringWithFormat:@"%zd",index];
    return vc;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @"";
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    [self.stepView layoutIfNeeded];
    CGFloat height = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.stepView.frame) - 15 - 30;
    return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectZero;
}

#pragma mark - RAStepViewDelegate
- (void)stepView:(LJStepView *)stepView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
    self.pageController.selectIndex = (int)index;
}

- (LJStepView *)stepView {
    if (_stepView == nil) {
        _stepView = [LJStepView stepView:@[@"Step 1",@"Step 2",@"Step 3"]];
        _stepView.itemMargin = 2;
        _stepView.delegate = self;
        _stepView.normalBgColor = [UIColor blackColor];
        _stepView.highlightBgColor = [UIColor redColor];
        _stepView.textColor = [UIColor whiteColor];
        _stepView.textFont = [UIFont systemFontOfSize:14];
    }
    return _stepView;
}

- (WMPageController *)pageController {
    if (_pageController == nil) {
        _pageController = [[WMPageController alloc] init];
        _pageController.pageAnimatable = YES;
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.view.backgroundColor = [UIColor whiteColor];
        _pageController.scrollEnable = NO;
        _pageController.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    }
    return _pageController;
}


@end
