//
//  ANInterviewTableViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/12.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANInterviewTableViewController.h"

@interface ANInterviewTableViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    NSString *man,*level,*siteName;
    NSArray *_arrTitle;
    NSArray *_arrBasicInfo;
    NSArray *_arrExistingBasis;
    NSArray *_arrFeedbackInfo;
    
    UITextView *_basicInfo,*_nowInfo,*_targetdelivery,*_problem;
    
    UITextField *_calendar;
    
    NSDictionary *_paraDic;
    
}
@end

@implementation ANInterviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.title=@"网点访谈表";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    siteName = [user stringForKey:@"SiteName"];
    [self loadData];
}

- (void)loadData{
    _arrTitle=@[@"基本信息",@"现有基础信息",@"反馈信息"];
    _arrBasicInfo=@[@"所属分拨 *",@"拜访人 *",@"拜访原因 *",@"网店名称 *",@"网店老板 *",@"网点电话 *"];
    _arrExistingBasis=@[@"货量指标（吨）",@"实际完成",@"指标完成率",@"上月日均完成值",@"本月日均完成值",@"日均差值",@"Mini小包指标",@"Mini小包票数",@"Mini指标完成率"];
    _arrFeedbackInfo=@[@"出货目标值＊",@"改善时间＊",@"网店存在问题＊",@"网点需求＊",@"改善方案＊",@"---"];
    //读出数据action=WriteView SITE:网点名称 ALLOCATE:所属分拨 Date:提交时间 TYPE:访谈状态（已访谈，未访谈）FTTYPE:访谈类型（货量，妥投，系统欠款）TID:编号 Man:登录名称）
    _paraDic=@{@"action":@"WriteView",@"TID":self.TID,@"FTTYPE":@(self.type),@"ALLOCATE":self.ALLOCATE,@"SITE":siteName,@"Man":man,@"Date":@"2016-01-20",@"TYPE":@(self.yesOrNo)};
    [NetWorkRequest getWithExtendUrl:Interview Para:_paraDic Complete:^(BOOL succeed, id Object) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _arrBasicInfo.count;
    } else if (section==1) {
        return _arrExistingBasis.count;
    } else {
        return _arrFeedbackInfo.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%li",(long)indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    for (UIView *views in cell.subviews) {
//        [views removeFromSuperview];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    CGFloat h=40;
    UILabel *infoLab=[self labFrame:CGRectMake(2, 0, WIDTH/3, h) andCell:cell];
    if (indexPath.section==0) {
        infoLab.text=[_arrBasicInfo objectAtIndex:indexPath.row];
        _basicInfo=[self textViewFrame:CGRectMake(WIDTH/3, 5, WIDTH/3*2-10, 30) andCell:cell];
    } else if (indexPath.section==1){
        infoLab.text=[_arrExistingBasis objectAtIndex:indexPath.row];
        _nowInfo=[self textViewFrame:CGRectMake(WIDTH/3, 5, WIDTH/3*2-10, 30) andCell:cell];
    } else {
        if (indexPath.row<=_arrFeedbackInfo.count-2) {
            infoLab.text=[_arrFeedbackInfo objectAtIndex:indexPath.row];
            if (indexPath.row==0) {
                _targetdelivery=[self textViewFrame:CGRectMake(WIDTH/3, 5, WIDTH/3*2-10, 30) andCell:cell];
            } else if (indexPath.row==1) {
                _calendar=[[UITextField alloc] initWithFrame:CGRectMake(WIDTH/3, 5,WIDTH/3*2-10, 30)];
                _calendar.layer.borderColor=[UIColor grayColor].CGColor;
                _calendar.layer.borderWidth=2.0;
                _calendar.font=[UIFont systemFontOfSize:12];
                [cell addSubview:_calendar];
                _calendar.text=[CYTools getNowDate];
                //最右侧加按钮
                UIButton *calendarBtn=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3-35, 2, 30, 26)];
                [calendarBtn setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
                _calendar.rightView=calendarBtn;
                _calendar.rightViewMode = UITextFieldViewModeAlways;
                _calendar.delegate=self;
                [calendarBtn addTarget:self action:@selector(clickCalendar) forControlEvents:UIControlEventTouchUpInside];
            }else{
                _problem=[self branchesTextViewFrame:CGRectMake(10, 30, WIDTH-20, 110) andCell:cell];
            }
        } else if(indexPath.row==_arrFeedbackInfo.count-1) {
            //提交
            UIButton *submitBtn=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH/4, 10, WIDTH/2, 30)];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"bcolor.png"] forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(clickSubmit:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:submitBtn];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//实现协议方法
- (void)sendDate:(NSString *)strDate{
    _calendar.text = strDate;
}
#pragma mark 显示日历
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_calendar becomeFirstResponder];
}
- (void)clickCalendar{
    [_calendar becomeFirstResponder];//弹出键盘
}

#pragma mark 提交网点访谈表
- (void)clickSubmit:(UIButton *)btn event:(UIEvent *)event{
    NSLog(@"提交网点访谈表");
    //获取所有要提交的数据
    NSSet *sets=[event allTouches];
    UITouch *touch=[sets anyObject];//获取对象
    NSIndexPath *index=[self.tableView indexPathForRowAtPoint:[touch locationInView:self.tableView]];
    NSString *basicInfo=_basicInfo.text;
    NSLog(@"basicInfo=%@,nowInfo=%@",basicInfo,_nowInfo.text);
    //提交数据action=InsertView TID:编号 FTTYPE:访谈类型 ALLOCATE:所属分拨 SITE:网点名称 Man:登录名称 Date:反馈日期,提交时间 Filldata:填写数据,各个数据用”|”分开(填写内容及经纬度，地址）
    _paraDic=@{@"action":@"InsertView",@"TID":self.TID,@"FTTYPE":@(self.type),@"ALLOCATE":self.ALLOCATE,@"SITE":siteName,@"Man":man,@"Date":@"2016-01-20",@"Filldata":@""};
    [NetWorkRequest getWithExtendUrl:Interview Para:_paraDic Complete:^(BOOL succeed, id Object) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *views=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    UILabel *titleText=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    titleText.font=[UIFont systemFontOfSize:14];
    titleText.textAlignment=NSTextAlignmentLeft;
    titleText.textColor=[UIColor colorWithRed:219/255.0 green:86/255.0 blue:13/255.0 alpha:1];
    titleText.text=[_arrTitle objectAtIndex:section];
    views.backgroundColor=[UIColor colorWithRed:250/255.0 green:204/255.0 blue:166/255.0 alpha:1];
    [views addSubview:titleText];
    return views;
}
#pragma mark 实现UITextView和UITextField相同效果的水印提示
- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
    {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
    {
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    
    if ([text isEqualToString:@"\n"])//回车事件
    {
        if ([textView.text isEqualToString:@""])//如果直接回车，显示提示内容
        {
            textView.textColor=[UIColor lightGrayColor];
            textView.text=NSLocalizedString(@"请输入不少于20字的描述", nil);
        }
        [textView resignFirstResponder];//隐藏键盘
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=NSLocalizedString(@"请输入不少于20字的描述", nil);
    }
}
-(UITextView *)branchesTextViewFrame:(CGRect)frames andCell:(UITableViewCell *)cell {
    UITextView *textView=[[UITextView alloc] initWithFrame:frames];
    textView.font=[UIFont systemFontOfSize:14];
    textView.textAlignment=NSTextAlignmentLeft;
    textView.layer.borderColor=[UIColor grayColor].CGColor;
    textView.layer.borderWidth=2;
    textView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    textView.text=NSLocalizedString(@"请输入不少于20字的描述", nil);//提示语
    textView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    textView.delegate=self;
    [cell addSubview:textView];
    return textView;
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell{
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:14];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=[UIColor blackColor];
//    lab.backgroundColor=[UIColor redColor];
    [cell.contentView addSubview:lab];
    return lab;
}
//创建textView
-(UITextView *)textViewFrame:(CGRect)frames andCell:(UITableViewCell *)cell {
    UITextView *textView=[[UITextView alloc] initWithFrame:frames];
    textView.font=[UIFont systemFontOfSize:14];
    textView.textAlignment=NSTextAlignmentLeft;
    textView.layer.borderColor=[UIColor grayColor].CGColor;
    textView.layer.borderWidth=2;
    [cell.contentView addSubview:textView];
    return textView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        if (indexPath.row==0 || indexPath.row==1) {
            return 40;
        } else if (indexPath.row==_arrFeedbackInfo.count-1){
            return 50;
        } else{
            return 140;
        }
    } else {
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *filed in self.view.subviews) {
        if (![filed isKindOfClass:[UITextField class]]) {
            [filed resignFirstResponder];
        }
    }
    for (UITextView *views in self.view.subviews) {
        if (![views isKindOfClass:[UITextView class]]) {
            [views resignFirstResponder];
        }
    }
}

@end
