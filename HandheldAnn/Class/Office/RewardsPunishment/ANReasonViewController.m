//
//  ANFinalRPViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANReasonViewController.h"
#import "MyDatePicker.h"

@interface ANReasonViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,MyDatePickerDelegate>
{
    NSString *man,*level,*siteName;
    UITableView *_tableView1,*_tableView2;
    NSArray *_arr1,*_arr2;
    UITextView *_feedback;
    UITextField *_shipmentTime;
    UIButton *submitBtn;
    
    NSDictionary *dicInfo;
    NSDictionary *paraDic;
    
    UIScrollView *_scrollView;
    MyDatePicker *_dpv;
}
@end

@implementation ANReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dicInfo=[NSDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    level = [user stringForKey:@"Level"];
    siteName = [user stringForKey:@"SiteName"];
    
    [self loadData];
    [self loadFrame];
}

- (void)loadData{
    _arr1=@[@"日期",@"省区",@"大区",@"所属分拨",@"所属片区",@"网点层级",@"网店编号",@"网店名称"];
    _arr2=@[@"本月完成货量",@"未出货原因反馈",@"预计出货时间"];
    //①查询接口 action=getListNo Man= Level= SiteName=
    paraDic = @{@"action":@"getListNo",@"Man":man,@"SiteName":@"重庆科园路", @"Level":level};
    [NetWorkRequest getWithExtendUrl:RP Para:paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
            dicInfo=[Object objectForKey:@"returninfo"];
            [_tableView1 reloadData];
            [_tableView2 reloadData];
        } else {
            
        }
    }];
}

- (void)loadFrame{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50)];
    _scrollView.contentSize=CGSizeMake(0, (_arr1.count+_arr2.count-1)*25+130);
    [self.view addSubview:_scrollView];
    _tableView1=[self tableFrame:CGRectMake(10, 10, WIDTH-20, 25*_arr1.count)];
    _tableView2=[self tableFrame:CGRectMake(10, 25*_arr1.count+20, WIDTH-20, 25*(_arr2.count-1)+100)];
    [self createSubmitBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView1) {
        return _arr1.count;
    } else {
        return _arr2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cargowarnCell" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    UILabel *labs=[self labFrame:CGRectMake(0, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
    labs.backgroundColor=[UIColor colorWithRed:212/255.0 green:234/255.0 blue:240/255.0 alpha:1];
    if (tableView==_tableView1) {
        labs.text=[_arr1 objectAtIndex:indexPath.row];
        UILabel *labsInfo=[self labFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
        NSArray *keys=@[@"IDATE",@"REGION",@"PROVINCE",@"ALLOCATE",@"AREA",@"DICT_NAME",@"SITE_CODE",@"SITE"];
        labsInfo.text=[dicInfo objectForKey:keys[indexPath.row]];
    } else {
        labs.text=[_arr2 objectAtIndex:indexPath.row];
        NSString *feedback,*shipTime;
        if (indexPath.row==0) {
            UILabel *labsInfo=[self labFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, cell.frame.size.height-2) andCell:cell];
            labsInfo.text=[NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"WEIGHT"]];
        } else if (indexPath.row==1) {
            _feedback = [self branchesTextViewFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, 100) andCell:cell];
            feedback = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"TIPS"]];
            if ([feedback isEqualToString:@"<null>"]) {
                submitBtn.hidden=NO;
                _feedback.userInteractionEnabled=YES;
                _shipmentTime.userInteractionEnabled=YES;
            } else {
                _feedback.text = feedback;
                submitBtn.hidden=YES;
                _feedback.userInteractionEnabled=NO;
                _shipmentTime.userInteractionEnabled=NO;
            }
            [labs setFrame:CGRectMake(0, 1, cell.frame.size.width/2, 100)];
        } else {
            _shipmentTime = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width/2, 1, cell.frame.size.width/2, 25)];
            _shipmentTime.font=[UIFont systemFontOfSize:14];
            _shipmentTime.textAlignment=NSTextAlignmentCenter;
            shipTime = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"ST_DATE"]];
            if ([shipTime isEqualToString:@"<null>"]) {
                submitBtn.hidden=NO;
                _feedback.userInteractionEnabled=YES;
                _shipmentTime.userInteractionEnabled=YES;
                _dpv = [[MyDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 218.0)];
                
                //实现委托
                _dpv.delegate = self;
                
                //设置文本框的输入视图
                _shipmentTime.inputView = _dpv;
            } else {
                _shipmentTime.text = shipTime;
                submitBtn.hidden=YES;
                _feedback.userInteractionEnabled=NO;
                _shipmentTime.userInteractionEnabled=NO;
            }
            [cell.contentView addSubview:_shipmentTime];
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//实现协议方法
- (void)sendDate:(NSString *)strDate{
    _shipmentTime.text = strDate;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_shipmentTime resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView2) {
        if (indexPath.row==_arr2.count-2) {
            return 100;
        }
    }
    return 25;
}
#pragma mark 提交按钮
- (void)createSubmitBtn{
    //提交
    submitBtn=[[UIButton alloc] initWithFrame:CGRectMake(100, _tableView2.frame.origin.y+_tableView2.frame.size.height+20, WIDTH-200, 30)];
    submitBtn.layer.cornerRadius=5.0;
    submitBtn.layer.masksToBounds=YES;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bcolor.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
}
-(void)clickSubmit{
    int strlength = 0;
    char* p = (char*)[_feedback.text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[_feedback.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    NSLog(@"length=%i",strlength);
    if (strlength>200 || [_feedback.text isEqualToString:@""]) {
        [CYTools showAlert:@"提交失败，原因反馈描述必须在200字符以内"];
    } else if ([_shipmentTime.text isEqualToString:@""]) {
        [CYTools showAlert:@"提交失败，请选择预计出货时间"];
    } else {
        NSString *endtime = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"IDATE"]];
        NSLog(@"feedback=%@ shipmentTime=%@ date=%@",_feedback.text,_shipmentTime.text,endtime);
        //②提交接口 action=SetUpdate Tips：备注（限制200字符）StartDate：开始出货时间 Man：上传人 EndDate：查询日期条件 Where：查询条件，网点名称 SiteName： Level：
        paraDic = @{@"action":@"SetUpdate",@"Tips":_feedback.text,@"StartDate":_shipmentTime.text,@"EndDate":endtime,@"Where":@"义乌江南四区",@"SiteName":@"义乌江南四区", @"Level":level,@"Man":man};
//        [NetWorkRequest getWithExtendUrl:RP Para:paraDic Complete:^(BOOL succeed, id Object) {
//            if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]] isEqualToString:@"1"]) {
//                [CYTools showAlert:@"提交成功！"];
//            }
//        }];
    }
}

//创建lab
-(UILabel *)labFrame:(CGRect)frames andCell:(UITableViewCell *)cell {
    UILabel *lab=[[UILabel alloc] initWithFrame:frames];
    lab.font=[UIFont systemFontOfSize:14];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor blackColor];
    [cell.contentView addSubview:lab];
    return lab;
}
#pragma mark 创建table
- (UITableView *)tableFrame:(CGRect)frames{
    UITableView *myTableView=[[UITableView alloc] initWithFrame:frames];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cargowarnCell"];
    myTableView.scrollEnabled = NO;
    myTableView.tableFooterView=[[UIView alloc] init];
    myTableView.layer.borderColor=[UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1].CGColor;
    myTableView.layer.borderWidth=1;
    myTableView.separatorColor = [UIColor colorWithRed:62/255.0 green:155/255.0 blue:184/255.0 alpha:1];
    myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_scrollView addSubview:myTableView];
    return myTableView;
}

#pragma mark 设置端距，这里表示separator离左边和右边均0像素
-(void)viewDidLayoutSubviews {
    if ([_tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView1 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView1 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView2 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView2 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
            textView.text=NSLocalizedString(@"请输入200以内的文字描述", nil);
        }
        [textView resignFirstResponder];//隐藏键盘
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=NSLocalizedString(@"请输入200以内的文字描述", nil);
    }
}
-(UITextView *)branchesTextViewFrame:(CGRect)frames andCell:(UITableViewCell *)cell {
    UITextView *textView=[[UITextView alloc] initWithFrame:frames];
    textView.font=[UIFont systemFontOfSize:14];
    textView.textAlignment=NSTextAlignmentLeft;
    textView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    textView.text=NSLocalizedString(@"请输入200以内的文字描述", nil);//提示语
    textView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    textView.delegate=self;
    [cell.contentView addSubview:textView];
    return textView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
