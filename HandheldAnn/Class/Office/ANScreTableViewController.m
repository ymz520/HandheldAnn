//
//  ANScreTableViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/26.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANScreTableViewController.h"
#import "ANScreenHeadView.h"
#import "ANScreenTableViewCell.h"
#import "PickerChoiceView.h"

@interface ANScreTableViewController ()<TFPickerDelegate>
{
  
    ANScreenHeadView *_headView;
    NSMutableArray *dataArray;
    UIView *mainViews;
    UIPickerView *_pickView;
    UIView *_cancelDone;
    UIButton *cancelBtn,*doneBtn;
    UILabel *_screenTitle;
    NSInteger selectIndex;
    
    
    //展示界面数据
    NSArray *_array;
    NSMutableArray *_arrConditions;
    NSMutableDictionary *_dics1,*_dics2,*_dics3,*_dics4,*_dics5,*_dics6,*_dics7,*_dics8,*_dics9,*_dics10;
    
    
    NSMutableArray *_arrayData;
    NSDictionary *paraDic;

}

@property (nonatomic,strong)NSMutableArray *mutArray;

@end

@implementation ANScreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavgationBar];
    [self loadData];
    
    
    _arrayData=[[NSMutableArray alloc] initWithCapacity:0];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (UIButton *)btnFrame:(CGRect)frame andTitle:(NSString *)title{
    UIButton *btn=[[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_cancelDone addSubview:btn];
    return btn;
}
#pragma mark - 设置导航条
- (void)setUpNavgationBar
{
    // 右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    //设置头视图
    _headView=[ANScreenHeadView getMineHeadView];
    self.tableView.tableHeaderView=_headView;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ANScreenTableViewCell" bundle:nil] forCellReuseIdentifier:@"setupCell"];
}
- (void)done{
    
}
#pragma mark 加载数据源
- (void)loadData{
    _array=@[@"开始时间",@"结束时间",@"展示属性",@"网点类型",@"省区",@"大区",@"分拨",@"片区",@"网点",@"门店"];
    _arrConditions=[[NSMutableArray alloc]initWithCapacity:0];
    _dics1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics4=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics5=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics6=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics7=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics8=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics9=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _dics10=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"请选择",@"key", nil];
    _arrConditions=[[NSMutableArray alloc]initWithObjects:_dics1,_dics2,_dics3,_dics4,_dics5,_dics6,_dics7,_dics8,_dics9,_dics10, nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ANScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setupCell" forIndexPath:indexPath];
    cell.titleLab.text=_array[indexPath.row];
    cell.screenText.text=[_arrConditions[indexPath.row] objectForKey:@"key"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    selectIndex = indexPath.row;
    picker.selectStr = [_array objectAtIndex:indexPath.row ];
    picker.delegate = self;
    if (indexPath.row == 0) {
        
        picker.arrayType = StartTimeArray;
        
    }else if (indexPath.row == 1) {
        
        picker.arrayType = EndTimeArray;
        
    }else if (indexPath.row == 2) {
        
        picker.arrayType = ShowArray;
        
    }else if (indexPath.row == 3) {
        
        picker.arrayType = WangDianArray;
        
    }else if (indexPath.row == 4) {
        picker.arrayType = ProvinceArray;
    }else {
        NSString *superStr1 = [[_arrConditions objectAtIndex:selectIndex-1] objectForKey:@"key"];
        if (indexPath.row == 5) {
            picker.superiorStr1 = superStr1;
            picker.arrayType = RegionalArray;
        }else {
             NSString *superStr2 = [[_arrConditions objectAtIndex:selectIndex-2] objectForKey:@"key"];
            if (indexPath.row == 6) {
                picker.superiorStr1 = superStr1;
                picker.superiorStr2 = superStr2;
                picker.arrayType = Distribution;
            }else {
                NSString *superStr3 = [[_arrConditions objectAtIndex:selectIndex-3] objectForKey:@"key"];
                if (indexPath.row == 7) {
                    picker.superiorStr1 = superStr1;
                    picker.superiorStr2 = superStr2;
                    picker.superiorStr3 = superStr3;
                    picker.arrayType = AreaArray;
                } else {
                    NSString *superStr4 = [[_arrConditions objectAtIndex:selectIndex-4] objectForKey:@"key"];
                    if (indexPath.row == 8) {
                        picker.superiorStr1 = superStr1;
                        picker.superiorStr2 = superStr2;
                        picker.superiorStr3 = superStr3;
                        picker.superiorStr4 = superStr4;
                        picker.arrayType = BranchesArray;
                    }if (indexPath.row == 9) {
                        NSString *superStr5 = [[_arrConditions objectAtIndex:selectIndex-5] objectForKey:@"key"];
                        picker.superiorStr1 = superStr1;
                        picker.superiorStr2 = superStr2;
                        picker.superiorStr3 = superStr3;
                        picker.superiorStr4 = superStr4;
                        picker.superiorStr5 = superStr5;
                        picker.arrayType = StoresArray;
                    }
                }
            }
        }
    }
    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str{
    NSLog(@"____   %@",str);
    NSDictionary *dict = [_arrConditions objectAtIndex:selectIndex];
   
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [muDict setObject:str forKey:@"key"];
    //替换所选KEY
    [_arrConditions replaceObjectAtIndex:selectIndex withObject:muDict];
    
    [self.tableView reloadData];
    
}
//设置端距，这里表示separator离左边和右边均0像素
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
