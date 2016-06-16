//
//  ANTaskDetailTableViewController.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/6/2.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANTaskDetailTableViewController.h"
#import "MyDatePicker.h"

@interface ANTaskDetailTableViewController ()<UITextViewDelegate,UITextFieldDelegate,MyDatePickerDelegate>
{
    NSString *man,*level,*siteName,*name;
    NSArray *_arrTitle;
    NSArray *_arrBasicInfo;
    NSArray *_arrExistingBasis;
    NSArray *_arrFeedbackInfo;
    
    NSMutableArray *_arrExistingBasisData;
    NSDictionary *_dicData;
    
    NSDictionary *_paraDic;
    MyDatePicker *_dpv;
    NSString *_tempTime;
}

@end

@implementation ANTaskDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"网点访谈表";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    man = [user stringForKey:@"Man"];
    siteName = [user stringForKey:@"SiteName"];
    name = [user stringForKey:@"NAME"];
    NSLog(@"man=%@ siteName=%@ name=%@",man,siteName,name);
    _arrExistingBasisData = [[NSMutableArray alloc] initWithCapacity:0];
    _dicData = [NSDictionary dictionary];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self loadData];
}

- (void)loadData{
    _arrTitle=@[@"基本信息",@"现有基础信息",@"反馈信息"];
    _arrBasicInfo=@[@"所属分拨",@"拜访人",@"拜访原因",@"网店名称",@"网店老板",@"网点电话"];
    _arrFeedbackInfo=@[@"出货目标值＊",@"改善时间＊",@"网店存在问题＊",@"网点需求＊",@"改善方案＊",@" "];
    if (self.type==1) {
        /*SITE_TAR_M：货量指标 M_WEIGHT_A：实际完成 TAR_LV：指标完成率  SITE_TAR_D：本月日均完成值 L_SITE_TAR_D：上月日均完成值  POOR_DAY：日均差值 SUM_BILL_COUNT：mini小包票数*/
        _arrExistingBasis = @[@"货量指标",@"实际完成",@"指标完成率",@"本月日均完成值",@"上月日均完成值",@"日均差值",@"Mini小包指标",@"mini小包票数",@"mini小包完成率"];
    } else if(self.type==2) {
        /*S_SUM_TOTAL:妥投目标值 S_SUM_ACT:实际完成 TAR_LV:目标完成率 L_SUM_ACT:上月完成值 L_TAR_LV:上月完成率*/
        _arrExistingBasis = @[@"妥投率目标值",@"实际完成",@"目标完成率",@"上月完成值",@"上月完成率",];
    } else {
        /*SITE_TAR_M:货量指标（吨） M_WEIGHT_A:实际完成 S_SUM_TOTAL:妥投率目标值 S_SUM_ACT:妥投率完成值   BALANCE:系统余额    DEBT_TIME:系统欠款时间*/
        _arrExistingBasis = @[@"货量指标（吨）",@"实际完成",@"妥投率目标值",@"妥投率完成值",@"系统余额",@"系统欠款时间"];
    }
    _arrayData = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_arrBasicInfo.count+_arrExistingBasis.count+_arrFeedbackInfo.count; i++) {
        [_arrayData addObject:@" "];
    }
    /*读出数据action=WriteView SITE:网点名称 ALLOCATE:所属分拨 Date:提交时间 TYPE:访谈状态（已访谈，未访谈）FTTYPE:访谈类型（货量，妥投，系统欠款）TID:编号 Man:登录名称）
     action=WriteView&SITE=武汉青山区&ALLOCATE=武汉分拨中心&Date=2016-03-21&TYPE=0&FTTYPE=1&TID=T201632213536&Man=00001
     */_paraDic=@{@"action":@"WriteView",@"TID":self.TID,@"FTTYPE":@(self.type),@"ALLOCATE":@"武汉分拨中心",@"SITE":self.ALLOCATE,@"Man":man,@"Date":@"2016-03-21",@"TYPE":@(self.yesOrNo)};
    NSLog(@"TID=%@ SITE=%@ FTTYPE(type)=%@ TYPE(yesorno)=%@",self.TID,self.ALLOCATE,@(self.type),@(self.yesOrNo));
    [NetWorkRequest getWithExtendUrl:Interview Para:_paraDic Complete:^(BOOL succeed, id Object) {
        if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"state"]]isEqualToString:@"1"]) {
            _arrExistingBasisData = [Object objectForKey:@"returninfo"];
            _dicData = [_arrExistingBasisData objectAtIndex:0];
            [self.tableView reloadData];
        } else {
            
        }
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
    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%li%ld",(long)indexPath.section,(long)indexPath.row];
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (_cell == nil) {
        _cell = [[ANTaskDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [_cell removeFromSuperview];
    }
    //强引用转化
    __weak typeof(self) weakSelf = self;
    _cell.block = ^(NSString *textInfo) {
        NSInteger rownum;
        if (indexPath.section==0) {
            rownum = indexPath.section*_arrBasicInfo.count+indexPath.row;
        } else if(indexPath.section==1){
            rownum = _arrBasicInfo.count+indexPath.row;
        } else {
            rownum = _arrBasicInfo.count+_arrExistingBasis.count+indexPath.row;
        }
        [weakSelf.arrayData replaceObjectAtIndex:rownum withObject:textInfo];
        [weakSelf.tableView reloadData];
    };
    if (indexPath.section==0) {//基本信息
        _cell.title.text=[_arrBasicInfo objectAtIndex:indexPath.row];
        if (indexPath.row<4) {
            _cell.textInfos.userInteractionEnabled=NO;
            if (indexPath.row==0) {
                _cell.textInfos.text=siteName;
            } else if (indexPath.row==1) {
                _cell.textInfos.text=name;
            } else if (indexPath.row==2){
                _cell.textInfos.text=self.reason;
            } else {
                _cell.textInfos.text=self.ALLOCATE;
            }
        } else {
            _cell.textInfos.userInteractionEnabled=YES;
        }
    } else if (indexPath.section==1){//现有基本信息
        _cell.title.text=[_arrExistingBasis objectAtIndex:indexPath.row];
        NSArray *keys;
        if (self.type==1) {
            keys = @[@"SITE_TAR_M",@"M_WEIGHT_A",@"TAR_LV",@"SITE_TAR_D",@"L_SITE_TAR_D",@"POOR_DAY",@"SUM_BILL_COUNT"];
        } else if (self.type==2) {
            keys = @[@"S_SUM_TOTAL",@"S_SUM_ACT",@"TAR_LV",@"L_SUM_ACT",@"L_TAR_LV"];
        } else {
            keys = @[@"SITE_TAR_M",@"M_WEIGHT_A",@"S_SUM_TOTAL",@"S_SUM_ACT",@"BALANCE",@"DEBT_TIME"];
        }
        _cell.textInfos.text = [NSString stringWithFormat:@"%@",[_dicData objectForKey:keys[indexPath.row]]];
        _cell.textInfos.userInteractionEnabled=NO;
    } else {//section==2
        if (indexPath.row<=_arrFeedbackInfo.count-2) {
            _cell.title.text=[_arrFeedbackInfo objectAtIndex:indexPath.row];
            if (indexPath.row!=0) {
                if (indexPath.row==1) {
                    _dpv = [[MyDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 218.0)];
                    //实现委托
                    _dpv.delegate = self;
                    _cell.textInfos.inputView = _dpv;
                    _cell.textInfos.text=_tempTime;
                } else {
                    _cell.textInfos.frame = CGRectMake(10, 30, WIDTH-20, 110);
                    _cell.textInfos.delegate=self;
                    _cell.textInfos.textColor=[UIColor lightGrayColor];//设置提示内容颜色
                    _cell.textInfos.text=NSLocalizedString(@"请输入200以内的文字描述", nil);//提示语
                    _cell.textInfos.selectedRange=NSMakeRange(0,0) ;//光标起始位置
                }
            }
        } else if(indexPath.row==_arrFeedbackInfo.count-1) {
            _cell.textInfos.hidden=YES;
            //提交
            UIButton *submitBtn=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH/4, 10, WIDTH/2, 30)];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"bcolor.png"] forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(clickSubmit:event:) forControlEvents:UIControlEventTouchUpInside];
            [_cell addSubview:submitBtn];
        }
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return _cell;
}
//实现协议方法
- (void)sendDate:(NSString *)strDate{
    _tempTime = strDate;
    NSInteger rownum = _arrBasicInfo.count+_arrExistingBasis.count+2;
    [_arrayData replaceObjectAtIndex:rownum withObject:_tempTime];
    //强引用转化
    __weak typeof(self) weakSelf = self;
    _cell.block = ^(NSString *textInfo) {
        NSInteger rownum = _arrBasicInfo.count+_arrExistingBasis.count+1;
        [weakSelf.arrayData replaceObjectAtIndex:rownum withObject:textInfo];
        NSLog(@"=======%@",weakSelf.arrayData);
    };
}

#pragma mark 提交网点访谈表
- (void)clickSubmit:(UIButton *)btn event:(UIEvent *)event{
    
    NSString*  selDateStr=_dpv.selDateStr;
    NSLog(@"selDateStr==%@",selDateStr);
    
    NSLog(@"arrayData=%@  _dicData=%@",self.arrayData,_dicData);
    NSString *targetValue = [NSString stringWithFormat:@"%@",[_arrayData objectAtIndex:_arrayData.count-5]];
    NSString *time = [NSString stringWithFormat:@"%@",[_arrayData objectAtIndex:_arrayData.count-4]];
    NSString *quest = [NSString stringWithFormat:@"%@",[_arrayData objectAtIndex:_arrayData.count-3]];
    NSString *needs = [NSString stringWithFormat:@"%@",[_arrayData objectAtIndex:_arrayData.count-2]];
    NSString *plan = [NSString stringWithFormat:@"%@",[_arrayData objectAtIndex:_arrayData.count-1]];
    if ([targetValue isEqualToString:@" "] || [time isEqualToString:@" "] || [quest isEqualToString:@" "] || [needs isEqualToString:@" "] || [plan isEqualToString:@" "]) {
        [CYTools showAlert:@"提交失败，反馈信息必须全部填写！"];
    } else {
        //提交数据action=InsertView TID:编号 FTTYPE:访谈类型 ALLOCATE:所属分拨 SITE:网点名称 Man:登录名称 Date:反馈日期,提交时间 Filldata:填写数据,各个数据用”|”分开(填写内容及经纬度，地址）
        NSMutableArray *arrayStr = [NSMutableArray array];
        NSArray *keys;
        if (self.type==1) {//货量
            keys = @[@"SITE_TAR_M",@"M_WEIGHT_A",@"TAR_LV",@"SITE_TAR_D",@"L_SITE_TAR_D",@"POOR_DAY",@" ",@"SUM_BILL_COUNT",@" "];
            for (int i=0; i<keys.count; i++) {
                [arrayStr addObject:[NSString stringWithFormat:@"%@",[_dicData objectForKey:keys[i]]]];
            }
            _paraDic=@{@"action":@"InsertView",@"Man":man,@"TYPE":@(self.yesOrNo),@"TID":self.TID,@"FTTYPE":@(self.type),@"Date":@"2016-01-20",@"CALL_PEPOLE":name,@"ALLOCATE":self.ALLOCATE,@"ALL_BECASE":self.reason,@"SITE":siteName,@"SITE_PERSON":@" ",@"SITE_PHONE":@" ",@"VOLUME_INDEX":arrayStr[0],@"CATUAL_COMP":arrayStr[1],@"TARGET_COMPLETE":arrayStr[2],@"LMONTH_TARGET":arrayStr[3],@"TMONTH_TARGET":arrayStr[4],@"DAILY_DIDDERENCE":arrayStr[5],@"MINI_TATGET":arrayStr[6],@"MINI_PIAOSHU":arrayStr[7],@"MINI_COMPLETION":arrayStr[8],@"SHIPMENT_TARGET":targetValue,@"IMPROVE_DATE":time,@"PROBLEMS":quest,@"SITE_DEMAND":needs,@"IMPROVE_PROGRAM":plan,@"Longitude":@"",@"Latitude":@"",@"ADDRESS":@""};
        } else if (self.type==2) {
            keys = @[@"S_SUM_TOTAL",@"S_SUM_ACT",@"TAR_LV",@"L_SUM_ACT",@"L_TAR_LV"];
            for (int i=0; i<keys.count; i++) {
                [arrayStr addObject:[NSString stringWithFormat:@"%@",[_dicData objectForKey:keys[i]]]];
            }
            _paraDic=@{@"action":@"InsertView",@"Man":man,@"TYPE":@(self.yesOrNo),@"TID":self.TID,@"FTTYPE":@(self.type),@"Date":@"2016-01-20",@"CALL_PEPOLE":name,@"ALLOCATE":self.ALLOCATE,@"ALL_BECASE":self.reason,@"SITE":siteName,@"SITE_PERSON":@" ",@"SITE_PHONE":@" ",@"VOLUME_INDEX":arrayStr[0],@"CATUAL_COMP":arrayStr[1],@"TARGET_COMPLETE":arrayStr[2],@"LMONTH_TARGET":arrayStr[3],@"TMONTH_TARGET":arrayStr[4],@"SHIPMENT_TARGET":targetValue,@"IMPROVE_DATE":time,@"PROBLEMS":quest,@"SITE_DEMAND":needs,@"IMPROVE_PROGRAM":plan,@"Longitude":@"",@"Latitude":@"",@"ADDRESS":@""};
        } else {
            keys = @[@"SITE_TAR_M",@"M_WEIGHT_A",@"S_SUM_TOTAL",@"S_SUM_ACT",@"BALANCE",@"DEBT_TIME"];
            for (int i=0; i<keys.count; i++) {
                [arrayStr addObject:[NSString stringWithFormat:@"%@",[_dicData objectForKey:keys[i]]]];
            }
            _paraDic=@{@"action":@"InsertView",@"Man":man,@"TYPE":@(self.yesOrNo),@"TID":self.TID,@"FTTYPE":@(self.type),@"Date":@"2016-01-20",@"CALL_PEPOLE":name,@"ALLOCATE":self.ALLOCATE,@"ALL_BECASE":self.reason,@"SITE":siteName,@"SITE_PERSON":@" ",@"SITE_PHONE":@" ",@"VOLUME_INDEX":arrayStr[0],@"CATUAL_COMP":arrayStr[1],@"TARGET_COMPLETE":arrayStr[2],@"LMONTH_TARGET":arrayStr[3],@"TMONTH_TARGET":arrayStr[4],@"DAILY_DIDDERENCE":arrayStr[5],@"SHIPMENT_TARGET":targetValue,@"IMPROVE_DATE":time,@"PROBLEMS":quest,@"SITE_DEMAND":needs,@"IMPROVE_PROGRAM":plan,@"Latitude":@"",@"ADDRESS":@""};
        }
        NSLog(@"arrayStr=%@",arrayStr);
        [NetWorkRequest getWithExtendUrl:Interview Para:_paraDic Complete:^(BOOL succeed, id Object) {
            if ([[NSString stringWithFormat:@"%@",[Object objectForKey:@"State"]]isEqualToString:@"1"]) {
                
            } else {
                
            }
        }];
    }
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor]){//如果不是delete响应,当前是提示信息，修改其属性
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    if ([text isEqualToString:@"\n"]){//回车事件
        if ([textView.text isEqualToString:@""]) {//如果直接回车，显示提示内容
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
//////


@end
