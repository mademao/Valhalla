//
//  FormTableViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/21.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "FormTableViewController.h"
#import "FormTableView.h"
#import "Player.h"

@interface FormTableViewController () <FormTableViewDataSource, FormTableViewDelegate>

@property (nonatomic, strong) NSMutableArray<Player *> *dataArray;
@property (nonatomic, strong) FormTableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@end

@implementation FormTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [self setUpUI];
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://www.wanplus.com/api.php?_param=454a43c7bf07e0d54b3e9b5d4c29bad3%7Cios%7C13%7C1.2%7C1.0%7C1464244275%7C126727%7CwPUgtOSuPnrgbU7%2BmDz9muqYUPW/%2ByHBI8Ji0lCisJq1soW%2BlPCFEycyhoxsS/c%7C2&c=App_Stats&gm=lol&m=playerStats&sig=8ece001b47bbf36cbf099bd3f4449bc2&c=App_Stats&gm=lol&m=playerStats"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [session finishTasksAndInvalidate];
            if (data) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *tempArray = responseObject[@"data"][@"statsList"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in tempArray) {
                    Player *player = [[Player alloc] init];
                    [player setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:player];
                }
                [self.tableView reloadData];
            } else {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"Fetch Data Fail", nil);
            }
        });
    }];
    [dataTask resume];
}

- (void)setUpUI
{
    self.titleArray = @[@"局数", @"KDA", @"参团率", @"场均击杀", @"单场最高击杀", @"场均死亡", @"单场最高死亡", @"场均助攻", @"单场最高助攻", @"GPM", @"CSPM", @"每分钟输出", @"输出占比", @"每分钟承受伤害", @"承受伤害占比", @"每分钟排眼数"];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.tableView = [[FormTableView alloc] initWithFrame:CGRectMake(0, PltNavigationBarHeight, bounds.size.width, bounds.size.height - PltNavigationBarHeight) delegate:self dataSource:self];
    [self.view addSubview:self.tableView];
}

#pragma mark - FormTableViewDelegate & FormTableViewDataSource
- (NSUInteger)numberOfRowsInFormTableView:(FormTableView *)formTableView
{
    return self.dataArray.count;
}
- (NSUInteger)numberOfColumnsInFormTableView:(FormTableView *)formTableView
{
    return self.titleArray.count;
}
- (NSString *)titleForLeftColumnInFormTableView:(FormTableView *)formTableView
{
    return @"选手";
}
- (NSString *)formTableView:(FormTableView *)formTableView titleForColumnAtIndex:(NSUInteger)column
{
    return self.titleArray[column];
}
- (NSString *)formTableView:(FormTableView *)formTableView titleForLeftBlockAtIndex:(NSUInteger)row
{
    return self.dataArray[row].playername;
}
- (NSString *)formTableView:(FormTableView *)formTableView titleForRightBlockAtRow:(NSUInteger)row column:(NSUInteger)column
{
    Player *player = self.dataArray[row];
    switch (column) {
        case 0:{
            return [player.appearedtimes stringValue];
            break;
        }
        case 1:{
            return [player.kda stringValue];
            break;
        }
        case 2:{
            return [NSString stringWithFormat:@"%.1f%%", player.killsparticipant.floatValue * 100];
            break;
        }
        case 3:{
            return [player.killspermatch stringValue];
            break;
        }
        case 4:{
            return [player.highestkills stringValue];
            break;
        }
        case 5:{
            return [player.deathspermatch stringValue];
            break;
        }
        case 6:{
            return [player.highestdeaths stringValue];
            break;
        }
        case 7:{
            return [player.assistspermatch stringValue];
            break;
        }
        case 8:{
            return [player.highestassists stringValue];
            break;
        }
        case 9:{
            return [player.goldpermin stringValue];
            break;
        }
        case 10:{
            return [NSString stringWithFormat:@"%.2f", player.lasthitpermin.floatValue];
            break;
        }
        case 11:{
            return [player.damagetoheropermin stringValue];
            break;
        }
        case 12:{
            return [NSString stringWithFormat:@"%.1f%%", player.damagetoheropercentage.floatValue * 100];
            break;
        }
        case 13:{
            return [player.damagetakenpermin stringValue];
            break;
        }
        case 14:{
            return [NSString stringWithFormat:@"%.1f%%", player.damagetakenpercentage.floatValue * 100];
            break;
        }
        case 15:{
            return [NSString stringWithFormat:@"%.2f", player.wardskilledpermin.floatValue];
            break;
        }
        default:
            return @"";
            break;
    }
}

- (CGFloat)formTableView:(FormTableView *)formTableView widthForRightAtColumn:(NSUInteger)column
{
    return 110;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
