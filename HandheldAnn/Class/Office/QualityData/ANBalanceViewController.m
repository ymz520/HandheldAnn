//
//  ANBalanceViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/16.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANBalanceViewController.h"
#import "UIParameter.h"
#import"PNChart.h"

@interface ANBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *man,*level,*siteName;
    
    UILabel *lab1,*lab2,*lab3;
    UILabel *_labIndicators;//当月累计欠款金额
    UILabel *_labCompletion;//欠款占比
    UILabel *_labGrowth;//欠款网点数
    NSDictionary *_dicData;
    NSMutableArray *_arrayTitle;
    NSMutableArray *_arrayData;
    NSDictionary *dicInfo;
    
    UILabel *dateorPro,*lastArrears,*theArrearsLab,*arrearZB;
    CGFloat txtH;
    UILabel *_labprovinces;//
    UILabel *_lablastMonthI;//
    UILabel *_labmonthI;
    UILabel *_labTTL;
    
    UITableView *_tableView;
}
@end

@implementation ANBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    level = [user stringForKey:@"Level"];
    siteName = [user stringForKey:@"SiteName"];
    
    _dicData=[[NSDictionary alloc] init];
    _arrayData=[[NSMutableArray alloc] initWithCapacity:0];
    [self loadData];
    [self loadFrame];
    
}
- (void)loadData{
    NSDictionary *paraDic1 = @{@"action":@"getTitle", @"man":man,@"Level":level,@"StartDate":@"2016-3-28"};
    [NetWorkRequest postWithExtendUrl:Debt Para:paraDic1 success:^(id data) {
        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayTitle=[data objectForKey:@"returninfo"];
            _labIndicators.text=[NSString stringWithFormat:@"%@",[[_arrayTitle objectAtIndex:0] objectForKey:@"DEBT"]];
            if ([_labIndicators.text isEqualToString:@"<null>"]) {
                _labIndicators.text=@"0";
            }
            _labCompletion.text=[NSString stringWithFormat:@"%.2f％",[[[_arrayTitle objectAtIndex:0] objectForKey:@"RATE"] floatValue]*100];
            _labGrowth.text=[NSString stringWithFormat:@"%@",[[_arrayTitle objectAtIndex:0] objectForKey:@"NUM"]];
        }
    }];
//    时间维度： getDate,StartDate，EndDate，Level，Man，SiteName，Where
    NSDictionary *paraDic2 = @{@"action":@"getDate",@"SiteName":@"总部",@"Man":@"05449",@"Level":@"0",@"StartDate":@"2016-03-10",@"EndDate":@"2016-04-10"};
//    层级维度：getSite,LL，StartDate，Level，Man，SiteName，Where
//    NSDictionary *paraDic2 = @{@"action":@"getSite",@"SiteName":@"总部",@"LL":@"1", @"Man":@"05449",@"Level":@"0",@"StartDate":@"2016-03-10"};
    [NetWorkRequest postWithExtendUrl:Debt Para:paraDic2 success:^(id data) {
        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"state"]] isEqualToString:@"1"]) {
            _arrayData=[data objectForKey:@"returninfo"];
            NSLog(@"===arr%@,%li",_arrayData,_arrayData.count);
            [self createPNChart];
            [_tableView reloadData];
        }
    }];
}
- (void)loadFrame{
    [self createSomeLab];
    [self createtableMessage];
    [self createTable];
}

- (void)createSomeLab{
    //当月累计欠款金额
    lab1=[self labFrame:CGRectMake(10, 10, (WIDTH-30)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab1.text=@"当月累计欠款金额";
    _labIndicators=[self labFrame:CGRectMake(10, 30, (WIDTH-30)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
    
    //欠款占比
    lab2=[self labFrame:CGRectMake(15+(WIDTH-30)/3, 10, (WIDTH-30)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab2.text=@"欠款占比";
    _labCompletion=[self labFrame:CGRectMake(15+(WIDTH-30)/3, 30, (WIDTH-30)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
    
    //欠款网点数
    lab3=[self labFrame:CGRectMake(20+(WIDTH-30)/3*2, 10, (WIDTH-30)/3, 20) andFont:12 andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andIndex:1];
    lab3.text=@"欠款网点数";
    _labGrowth=[self labFrame:CGRectMake(20+(WIDTH-30)/3*2, 30, (WIDTH-30)/3, 30) andFont:15 andTextColor:[UIColor blackColor] andBackgroundColor:[UIColor whiteColor] andIndex:2];
}
- (void)createPNChart{
    if (_arrayData.count==0) {
        return;
    }
    NSLog(@"====%li",_arrayData.count);
    //X轴数据
    NSMutableArray *dataXArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_arrayData.count; i++) {
        if ([self.action isEqualToString:@"getSite"]) {
            //截取省区
            NSString *provinces=[[_arrayData objectAtIndex:i ] objectForKey:@"SITE"];
            if ( [[provinces stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0) {
                NSRange range = [provinces rangeOfString:@"省区"];
                NSString *province=[provinces substringToIndex:range.location];//截取掉省区
                NSLog(@"截取的值为：%@",province);
                [dataXArray addObject:province];
            } else {
                [dataXArray addObject:provinces];
            }
        } else {
            //截取日期
            NSString * strtime = [NSString stringWithFormat:@"%@",[[_arrayData objectAtIndex:i ] objectForKey:@"IDATE"]];
            NSString * time = [CYTools substringDate:strtime andDM:1];
            [dataXArray addObject:time];
        }
    }
    //Y轴数据
    NSMutableArray *dataYArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_arrayData.count; i++) {
        //        NSString *rate=[[_arrayData objectAtIndex:i ] objectForKey:@"RATE"];
        NSString *rate=[NSString stringWithFormat:@"%.2f％",[[[_arrayData objectAtIndex:i] objectForKey:@"RATE"] floatValue]*100];
        [dataYArray addObject:rate];
    }
    if (self.chartStyle==2) {
        #pragma mark 柱状图
        PNBarChart * barChart = [[PNBarChart alloc]initWithFrame:CGRectMake(0, 70,SCREEN_WIDTH, HEIGHT/2-20)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.yChartLabelWidth = 20.0;
        barChart.chartMarginLeft = 25.0;
        barChart.chartMarginRight = 0.0;
        barChart.chartMarginTop = 5.0;
        barChart.chartMarginBottom = 10.0;
        barChart.labelMarginTop = 0.0;
        barChart.showChartBorder = YES;
        
        //X轴数据
        [barChart setXLabels:dataXArray];
        [barChart setYValues:dataYArray];
        [barChart strokeChart];
        //加载在视图上
        [self.view addSubview:barChart];
    } else {
        #pragma mark 折线图
        PNLineChart * lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 70,SCREEN_WIDTH, HEIGHT/2-20)];
        [lineChart setXLabels:dataXArray];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNHealYellow;
        data01.itemCount = lineChart.xLabels.count;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [[NSString stringWithFormat:@"%f％",[[[_arrayData objectAtIndex:index ] objectForKey:@"RATE"] floatValue]*100] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lineChart.chartData = @[data01];
        [lineChart strokeChart];
        [self.view addSubview:lineChart];
    }
}

- (void)createtableMessage{
    //线
    UIImageView *lineImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, HEIGHT/2-1, WIDTH-10, 1)];
    lineImg.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineImg];
    //日期＝＝省区
    dateorPro=[self labFrame:CGRectMake(0, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    dateorPro.text=@"日期";
    //上月欠款
    lastArrears=[self labFrame:CGRectMake(labW, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    lastArrears.text=@"当日欠款";
    //本月累计欠款
    theArrearsLab=[self labFrame:CGRectMake(labW*2, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    theArrearsLab.text=@"收入";
    //欠款占比
    arrearZB=[self labFrame:CGRectMake(labW*3, HEIGHT/2, labW, 25) andFont:12 andTextColor:[UIColor colorWithRed:22/255.0 green:165/255.0 blue:63/255.0 alpha:1] andBackgroundColor:[UIColor whiteColor] andIndex:1];
    arrearZB.text=@"欠款占比";
}

- (void)createTable{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT/2+25, WIDTH, HEIGHT/2-25-64-PageBtn)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"balanceCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"balanceCell" forIndexPath:indexPath];
    cell.backgroundColor=indexPath.row%2==0?[UIColor colorWithRed:229/255.0 green:236/255.0 blue:245/255.0 alpha:1]:[UIColor whiteColor] ;
    for (UIView *views in cell.subviews) {
        [views removeFromSuperview];
    }
    dicInfo=[_arrayData objectAtIndex:indexPath.row ];
    //日期＝＝省区
    _labprovinces=[self labFrame:CGRectMake(0, 0, labW, cell.frame.size.height)andCell:cell];
    _labprovinces.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"IDATE"]];
    //当日欠款
    _lablastMonthI=[self labFrame:CGRectMake(labW, 0, labW, cell.frame.size.height)andCell:cell];
    _lablastMonthI.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"DEBT"]];
    //收入
    _labmonthI=[self labFrame:CGRectMake(labW*2, 0, labW, cell.frame.size.height)andCell:cell];
    _labmonthI.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"SR"] ];
    //欠款占比
    _labTTL=[self labFrame:CGRectMake(labW*3, 0, labW, cell.frame.size.height)andCell:cell];
    _labTTL.text=[NSString stringWithFormat:@"%.2f％",[[dicInfo objectForKey:@"RATE"] floatValue]*100];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andFont:(CGFloat)size andTextColor:(UIColor *)textColor  andBackgroundColor:(UIColor *)color andIndex:(int)index
{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:size];
    lab.backgroundColor=color;
    lab.textColor=textColor;
    lab.textAlignment=NSTextAlignmentCenter;
    if (index==2) {
        lab.layer.borderWidth=1;
        lab.layer.borderColor=[UIColor colorWithRed:131/255.0 green:194/255.0 blue:213/255.0 alpha:1].CGColor;
    }
    [self.view addSubview:lab];
    return lab;
}
- (UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:10];
    lab.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:lab];
    return lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
