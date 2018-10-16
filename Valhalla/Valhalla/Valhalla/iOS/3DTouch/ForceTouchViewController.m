//
//  ForceTouchViewController.m
//  Valhalla
//
//  Created by mademao on 2018/10/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "ForceTouchViewController.h"
#import "ForceTouchDetailViewController.h"

@interface ForceTouchViewController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ForceTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if ([self is3DTouchAvailiable]) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

///检测3D Touch是否可用
-(BOOL)is3DTouchAvailiable {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
        return YES;
    return NO;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell plt_cellReuseIdentifier] forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ForceTouchDetailViewController *vc = [[ForceTouchDetailViewController alloc] init];
    vc.message = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(location.x, location.y - PltNavigationBarHeight)];
    if(indexPath)
    {
        ForceTouchDetailViewController *vc = [[ForceTouchDetailViewController alloc] init];
        vc.message = [NSString stringWithFormat:@"%@", @(indexPath.row)];
        __weak typeof(self) wkSelf=self;
        
        //------------上拉时的菜单-------------------
        //置顶及 其点击逻辑
        UIPreviewAction *topAction=[UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *action, UIViewController *previewViewController) {
            [wkSelf showAlert:@"提示" body:@"已置顶"];
        }];
        //删除及其点击逻辑
        UIPreviewAction *deleteAction=[UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction *action, UIViewController *previewViewController) {
            [wkSelf showAlert:@"警告" body:@"已删除"];
        }];
        //传递上拉菜单项给detail
        vc.actions= @[topAction,deleteAction];
        
        return vc;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}


#pragma mark - CustomMethods

- (void)showAlert:(NSString *)title body:(NSString *)body {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell plt_cellReuseIdentifier]];
    }
    return _tableView;
}

@end
