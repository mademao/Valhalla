//
//  CreatePDFViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/21.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "CreatePDFViewController.h"

@interface CreatePDFViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CreatePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell plt_cellReuseIdentifier]];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell plt_cellReuseIdentifier] forIndexPath:indexPath];
    cell.textLabel.text = [@(indexPath.row) stringValue];
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *data = [self createPDFfromUIScrollView:self.tableView];
        [data writeToFile:[PltDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [[NSDate date] plt_StringWithDate:nil]]] atomically:YES];
    });
}


-(NSMutableData*)createPDFfromUIScrollView:(UIScrollView*)scrollView {
    
    //存储ScrollView的初始位置及父视图
    CGRect origRect = scrollView.frame;
    UIView *origSuperView = scrollView.superview;
    
    //此处可以做一些子视图的处理，比如忽略ScrollView上一些图片的打印，需要将该图片视图进行适时的隐藏
    
    //创建一个新的用来显示的pdf的大小，这里为内容上下各预留了20的偏移
    //A4纸像素尺寸595*842
    CGRect rootRect = CGRectMake(0, 0, 595, scrollView.contentSize.height + 40);
    //重新计算scrollview的frame，新frame处于背景的中间，同时，为了能打印所有内容，将size设置为contentsize
    CGRect newScrollRect = CGRectMake((595 - scrollView.contentSize.width) / 2., 20, scrollView.contentSize.width, scrollView.contentSize.height);
    //重新为scrollview设置frame，并从原父视图移除
    [scrollView removeFromSuperview];
    scrollView.frame = newScrollRect;
    
    //设置背景图，这里的背景图宽度为A4的宽度595
    UIView *rootView = [[UIView alloc] initWithFrame:rootRect];
    rootView.backgroundColor = [UIColor whiteColor];
    //将需要打印的内容放置在新的背景图上
    [rootView addSubview:scrollView];
    
    //声明存储打印数据的数据结构
    NSMutableData *pdfData = [NSMutableData data];
    //设置要打印出来的文件的宽高
    UIGraphicsBeginPDFContextToData(pdfData, rootRect, nil);
    //开始打印
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [rootView.layer renderInContext:pdfContext];
    //结束打印
    UIGraphicsEndPDFContext();
    
    //将scrollview的frame与父视图设置为初始状态
    scrollView.frame = origRect;
    [origSuperView addSubview:scrollView];
    
    //此处对可以进行对子视图的恢复，比如说图片视图的恢复显示
    
    //输出打印数据，根据需要进行数据的存储或传输
    return pdfData;
}

@end
