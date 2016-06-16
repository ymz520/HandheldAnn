//
//  ANScreenView.m
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/19.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import "ANScreenView.h"
@interface ANScreenView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation ANScreenView
- (void)layoutSubviews{
    [self createTable];
}
- (void)createTable{
    self.userInteractionEnabled=YES;
//    UIImageView *input_boxImg=[[UIImageView alloc] initWithFrame:self.bounds];
//    input_boxImg.image=[UIImage imageNamed:@"input_box.png"];
//    [self addSubview:input_boxImg];
    _tableView=[[UITableView alloc] initWithFrame:_frames];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.layer.cornerRadius=10.0;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"screenCell"];
    [self addSubview:_tableView];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"input_box.png"]];
    imageView.image=[UIImage imageNamed:@"input_box.png"];
    [_tableView setBackgroundView:imageView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"screenCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=[_array objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前被选中的数据
    NSString *desc=_array[indexPath.row];
    
    //将数据外传
//    if([self.delegate respondsToSelector:@selector(didSelectedItem:)]){
//        
//        [self.delegate didSelectedItem:desc];
//    }
    [self performSelectorOnMainThread:@selector(clickIndexPath) withObject:self waitUntilDone:YES];
}
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
    NSLog(@"=========");
}
-(void)clickIndexPath{
    self.hidden=YES;
    NSLog(@"=========");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
@end
