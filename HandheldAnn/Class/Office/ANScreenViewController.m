//
//  ANScreenViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/5.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANScreenViewController.h"
#import "ANScreenTableViewCell.h"
#import "DatePickerViewController.h"
#import "DatePicker.h"
#import "RadioButton.h"
@interface ANScreenViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,DatePickerDelegate>
{
    CGFloat heightRow;
    UIScrollView *_scrollView;
    UIPickerView *_pickerView;
    UITableView *_tableV;
    NSArray *_headerars;
    NSArray *_cellars;
    UILabel *_startdatelab;
     UILabel *_enddatelab;
    int _index;
    NSMutableArray* buttons;
//    ANScreenTableViewCell *_screenvctl;
}
@property (nonatomic, strong) DatePickerViewController* datePicker;
@end
 static NSString *cellstr=@"cell";
@implementation ANScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    heightRow = 40;
    
    [self loadData];
//    [self loadFrame];
}
#pragma mark-创建tableview
- (void)loadData
{
    // 添加数据
    _headerars=[[NSArray alloc]initWithObjects:@"时间维度",@"层级维度",@"柱状图",@"折线图",@"日报",@"月报", nil];
    _cellars=[[NSArray alloc]initWithObjects:@"开始日期",@"结束日期",@"展示层级",@"网点类型",@"省区",@"大区",@"片区",@"网点", nil];
    _tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_tableV registerNib:[UINib nibWithNibName:@"ANScreenTableViewCell" bundle:nil] forCellReuseIdentifier:cellstr];
    _tableV.delegate=self;
    _tableV.dataSource=self;
//    UIView *headersview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
//    [self createRadiobtn:headersview];
//    headersview.backgroundColor=[UIColor redColor];
//    [_tableV.tableHeaderView addSubview:headersview];
    [self.view addSubview:_tableV];
    
    
    
}
#pragma mark-创建单选按钮
-(void)createRadiobtn:(UIView *)vie
{
    buttons = [NSMutableArray arrayWithCapacity:3];
//    CGRect btnRect = CGRectMake(20, 20, 100, 30);
    
//     NSString* optionTitle in ar
    int totalloc=2;
    CGFloat margin=(vie.frame.size.width-totalloc*100)/(totalloc+1);
    for (int i=0;i<_headerars.count;i++) {
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        CGFloat appviewx=margin+(margin+100)*loc;
        CGFloat appviewy=margin/3+(margin/3+30)*row;
        RadioButton* btn = [[RadioButton alloc] initWithFrame:CGRectMake(appviewx/2, appviewy, 100, 30)];
        if ((i+1)%2==0)
        {
            btn.frame=CGRectMake(appviewx, appviewy, 100, 30);
        }
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [btn setTitle:_headerars[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        btn.tag=i;
        [vie addSubview:btn];
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    
    [buttons[0] setSelected:YES];
// Making the first button initially selected
}
-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        NSLog(@"Selected color: %@", sender.titleLabel.text);
        [buttons[sender.tag] setSelected:YES];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [buttons[sender.tag] setSelected:NO];
    }
}
#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellars.count;

}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [self createRadiobtn:view];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ANScreenTableViewCell *cells=[tableView dequeueReusableCellWithIdentifier:cellstr forIndexPath:indexPath];
    if (cells==nil)
    {
        cells=[[ANScreenTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellstr];
    }
    cells.titleLab.text=_cellars[indexPath.row];
    cells.screenText.text=@"请选择";
    //给lable添加点击事件
    cells.screenText.tag=indexPath.row;
    [cells.screenText addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    cells.screenText.userInteractionEnabled = YES;
    return cells;


}
-(void)labelTap:(UITapGestureRecognizer *)tap
{
    UILabel *tview=(UILabel *)tap.view;
    switch (tview.tag) {
        case 0:
           
            _startdatelab=tview;
            [self presentSemiModalViewController:self.datePicker];
            _index=0;
            break;
        case 1:
            _enddatelab=tview;
            [self presentSemiModalViewController:self.datePicker];
            _index=1;
            break;
            
        default:
            break;
            NSLog(@"%d",_index);
//            _index=itview.tag;
    }
}
#pragma mark - DatePickerDelegate

- (NSUInteger)numberOfHoursInDatePicker:(DatePicker *)picker
{
    return 72;
}

- (NSTimeInterval)minimumDurationInDatePicker:(DatePicker *)picker
{
    return 30 * 60;
}

- (void)datePicker:(DatePicker *)picker didPickDate:(NSDate *)date
{
//    _startdatelab.text=nil;
//    _enddatelab.text=nil;
    [self dismissSemiModalViewController:self.datePicker];
    DatePicker *dat=self.datePicker.datePicker;
    if (_index==0) {
//         dat.titleLabel.text=@"开始时间";
        _startdatelab.text = [NSString stringWithFormat:@"%@", picker.pickedDate];
    }else
    {
        _enddatelab.text=[NSString stringWithFormat:@"%@", picker.pickedDate];
//        dat.titleLabel.text=@"结束时间";
    }
   
    
    
}

- (void)datePickerDidCancelPickDate
{
    [self dismissSemiModalViewController:self.datePicker];
}

#pragma mark - Getters

- (DatePickerViewController *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[DatePickerViewController alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return tableView.bounds.size.height*2.5/10;
}
#pragma mark 加载视图
- (void)loadFrame {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50)];
    _scrollView.contentSize=CGSizeMake(0, 14*heightRow);
    [self.view addSubview:_scrollView];
    btnInfo1 = [self btnFrame:CGRectMake(0, 0, WIDTH/2, heightRow) andTitle:@"时间维度"];
    [btnInfo1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo2 = [self btnFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, heightRow) andTitle:@"层级维度"];
    [btnInfo2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo3 = [self btnFrame:CGRectMake(0, heightRow, WIDTH/2, heightRow) andTitle:@"柱状图"];
    [btnInfo3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo4 = [self btnFrame:CGRectMake(WIDTH/2, heightRow, WIDTH/2, heightRow) andTitle:@"折线图"];
    [btnInfo4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo5 = [self btnFrame:CGRectMake(0, heightRow*2, WIDTH/2, heightRow) andTitle:@"日报"];
    [btnInfo5 addTarget:self action:@selector(clickBtn5:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo6 = [self btnFrame:CGRectMake(WIDTH/2, heightRow*2, WIDTH/2, heightRow) andTitle:@"月报"];
    [btnInfo6 addTarget:self action:@selector(clickBtn6:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo7 = [self btnFrame:CGRectMake(0, heightRow*3, WIDTH, heightRow)];
    [btnInfo7 addTarget:self action:@selector(clickBtn7:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo8 = [self btnFrame:CGRectMake(0, heightRow*4, WIDTH, heightRow)];
    [btnInfo8 addTarget:self action:@selector(clickBtn8:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo9 = [self btnFrame:CGRectMake(0, heightRow*5, WIDTH, heightRow)];
    [btnInfo9 addTarget:self action:@selector(clickBtn9:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo10 = [self btnFrame:CGRectMake(0, heightRow*6, WIDTH, heightRow)];
    [btnInfo10 addTarget:self action:@selector(clickBtn10:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo11 = [self btnFrame:CGRectMake(0, heightRow*7, WIDTH, heightRow)];
    [btnInfo11 addTarget:self action:@selector(clickBtn11:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo12 = [self btnFrame:CGRectMake(0, heightRow*8, WIDTH, heightRow)];
    [btnInfo12 addTarget:self action:@selector(clickBtn12:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo13 = [self btnFrame:CGRectMake(0, heightRow*9, WIDTH, heightRow)];
    [btnInfo13 addTarget:self action:@selector(clickBtn13:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo14 = [self btnFrame:CGRectMake(0, heightRow*10, WIDTH, heightRow)];
    [btnInfo14 addTarget:self action:@selector(clickBtn14:) forControlEvents:UIControlEventTouchUpInside];
    btnInfo15 = [self btnFrame:CGRectMake(0, heightRow*11, WIDTH, heightRow)];
    [btnInfo15 addTarget:self action:@selector(clickBtn15:) forControlEvents:UIControlEventTouchUpInside];
    
    labTitle1 = [self labFrame:CGRectMake(10, heightRow*3, WIDTH/2-10, heightRow) andTitle:@"开始日期"];
    labTitle2 = [self labFrame:CGRectMake(10, heightRow*4, WIDTH/2-10, heightRow) andTitle:@"结束日期"];
    labTitle3 = [self labFrame:CGRectMake(10, heightRow*5, WIDTH/2-10, heightRow) andTitle:@"展示层级"];
    labTitle4 = [self labFrame:CGRectMake(10, heightRow*6, WIDTH/2-10, heightRow) andTitle:@"网点类型"];
    labTitle5 = [self labFrame:CGRectMake(10, heightRow*7, WIDTH/2-10, heightRow) andTitle:@"省区"];
    labTitle6 = [self labFrame:CGRectMake(10, heightRow*8, WIDTH/2-10, heightRow) andTitle:@"大区"];
    labTitle7 = [self labFrame:CGRectMake(10, heightRow*9, WIDTH/2-10, heightRow) andTitle:@"分拨"];
    labTitle8 = [self labFrame:CGRectMake(10, heightRow*10, WIDTH/2-10, heightRow) andTitle:@"片区"];
    labTitle9 = [self labFrame:CGRectMake(10, heightRow*11, WIDTH/2-10, heightRow) andTitle:@"网点"];
    
    labInfo1 = [self textFrame:CGRectMake(WIDTH/2, heightRow*3, WIDTH/2, heightRow) andTitle:[CYTools getYesterdayDate]];
    labInfo2 = [self textFrame:CGRectMake(WIDTH/2, heightRow*4, WIDTH/2, heightRow) andTitle:[CYTools getNowDate]];
    labInfo3 = [self textFrame:CGRectMake(WIDTH/2, heightRow*5, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo4 = [self textFrame:CGRectMake(WIDTH/2, heightRow*6, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo5 = [self textFrame:CGRectMake(WIDTH/2, heightRow*7, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo6 = [self textFrame:CGRectMake(WIDTH/2, heightRow*8, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo7 = [self textFrame:CGRectMake(WIDTH/2, heightRow*9, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo8 = [self textFrame:CGRectMake(WIDTH/2, heightRow*10, WIDTH/2, heightRow) andTitle:@"请选择"];
    labInfo9 = [self textFrame:CGRectMake(WIDTH/2, heightRow*11, WIDTH/2, heightRow) andTitle:@"请选择"];
    
    for (int i=0; i<14; i++) {
        UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, i*heightRow, WIDTH, 1)];
        line.layer.borderColor=[UIColor grayColor].CGColor;
        line.layer.borderWidth=0.5;
        [_scrollView addSubview:line];
    }
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT-100, WIDTH, 100)];
    labInfo4.inputView=_pickerView;
    labInfo5.inputView=_pickerView;
    labInfo6.inputView=_pickerView;
    labInfo7.inputView=_pickerView;
    labInfo8.inputView=_pickerView;
    labInfo9.inputView=_pickerView;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
}

- (void)clickBtn1:(UIButton *)btn {
    labTitle3.frame = CGRectMake(WIDTH, heightRow*5, WIDTH/2, heightRow);
    labTitle4.frame = CGRectMake(10, heightRow*5, WIDTH/2-10, heightRow);
    labTitle5.frame = CGRectMake(10, heightRow*6, WIDTH/2-10, heightRow);
    labTitle6.frame = CGRectMake(10, heightRow*7, WIDTH/2-10, heightRow);
    labTitle7.frame = CGRectMake(10, heightRow*8, WIDTH/2-10, heightRow);
    labTitle8.frame = CGRectMake(10, heightRow*9, WIDTH/2-10, heightRow);
    labTitle9.frame = CGRectMake(10, heightRow*10, WIDTH/2-10, heightRow);
    labInfo3.frame = CGRectMake(WIDTH, heightRow*5, WIDTH/2, heightRow);
    labInfo4.frame = CGRectMake(WIDTH/2, heightRow*5, WIDTH/2, heightRow);
    labInfo5.frame = CGRectMake(WIDTH/2, heightRow*6, WIDTH/2, heightRow);
    labInfo6.frame = CGRectMake(WIDTH/2, heightRow*7, WIDTH/2, heightRow);
    labInfo7.frame = CGRectMake(WIDTH/2, heightRow*8, WIDTH/2, heightRow);
    labInfo8.frame = CGRectMake(WIDTH/2, heightRow*9, WIDTH/2, heightRow);
    labInfo9.frame = CGRectMake(WIDTH/2, heightRow*10, WIDTH/2, heightRow);
}
- (void)clickBtn2:(UIButton *)btn {
    labTitle3.frame = CGRectMake(10, heightRow*5, WIDTH/2, heightRow);
    labTitle4.frame = CGRectMake(10, heightRow*6, WIDTH/2-10, heightRow);
    labTitle5.frame = CGRectMake(10, heightRow*7, WIDTH/2-10, heightRow);
    labTitle6.frame = CGRectMake(10, heightRow*8, WIDTH/2-10, heightRow);
    labTitle7.frame = CGRectMake(10, heightRow*9, WIDTH/2-10, heightRow);
    labTitle8.frame = CGRectMake(10, heightRow*10, WIDTH/2-10, heightRow);
    labTitle9.frame = CGRectMake(10, heightRow*11, WIDTH/2-10, heightRow);
    labInfo3.frame = CGRectMake(WIDTH/2, heightRow*5, WIDTH/2, heightRow);
    labInfo4.frame = CGRectMake(WIDTH/2, heightRow*6, WIDTH/2, heightRow);
    labInfo5.frame = CGRectMake(WIDTH/2, heightRow*7, WIDTH/2, heightRow);
    labInfo6.frame = CGRectMake(WIDTH/2, heightRow*8, WIDTH/2, heightRow);
    labInfo7.frame = CGRectMake(WIDTH/2, heightRow*9, WIDTH/2, heightRow);
    labInfo8.frame = CGRectMake(WIDTH/2, heightRow*10, WIDTH/2, heightRow);
    labInfo9.frame = CGRectMake(WIDTH/2, heightRow*11, WIDTH/2, heightRow);
}
- (void)clickBtn3:(UIButton *)btn {
    
}
- (void)clickBtn4:(UIButton *)btn {
    
}
- (void)clickBtn5:(UIButton *)btn {
    
}
- (void)clickBtn6:(UIButton *)btn {
    
}
- (void)clickBtn7:(UIButton *)btn {
    [labInfo1 becomeFirstResponder];
    
}
- (void)clickBtn8:(UIButton *)btn {
    [labInfo2 becomeFirstResponder];
}
- (void)clickBtn9:(UIButton *)btn {
    [labInfo3 becomeFirstResponder];
}
- (void)clickBtn10:(UIButton *)btn {
   [labInfo4 becomeFirstResponder];
}
- (void)clickBtn11:(UIButton *)btn {
   [labInfo5 becomeFirstResponder];
}
- (void)clickBtn12:(UIButton *)btn {
   [labInfo6 becomeFirstResponder];
}
- (void)clickBtn13:(UIButton *)btn {
   [labInfo7 becomeFirstResponder];
}
- (void)clickBtn14:(UIButton *)btn {
   [labInfo8 becomeFirstResponder];
}
- (void)clickBtn15:(UIButton *)btn {
   [labInfo9 becomeFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"123";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    labInfo4.text = @"123";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 创建按钮 */
- (UIButton *)btnFrame:(CGRect)frame andTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [_scrollView addSubview:btn ];
    return btn;
}
- (UIButton *)btnFrame:(CGRect)frame {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [_scrollView addSubview:btn ];
    return btn;
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andTitle:(NSString *)title
{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:14.0];
    lab.text=title;
    lab.textColor=[UIColor blackColor];
    lab.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:lab];
    return lab;
}

-(UITextField *)textFrame:(CGRect)frames andTitle:(NSString *)title
{
    UITextField *lab=[[UITextField alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:14.0];
    lab.text=title;
    lab.textColor=[UIColor blackColor];
    lab.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:lab];
    return lab;
}
@end
