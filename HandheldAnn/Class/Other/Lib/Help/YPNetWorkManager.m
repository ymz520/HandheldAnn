//
//  YPNetWorkManager.m
//  Ben
//
//  Created by 在 on 15/12/14.
//  Copyright © 2015年 SuHuiLong. All rights reserved.
//

#import "YPNetWorkManager.h"


@interface YPNetWorkManager ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic, strong)NSURLConnection *connection;
@property (nonatomic, strong)NSMutableData *data;
@end
@implementation YPNetWorkManager
- (void)getDataWithURL:(NSString *)urlStr parameter:(NSString *)para {
    //创建
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    //设置请求类型
    //    request.HTTPMethod = @"POST";
    //    //设置请求体
    //    request.HTTPBody = [para dataUsingEncoding:NSUTF8StringEncoding];
    //开启请求
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//服务器接受响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //开辟空间
    self.data = [NSMutableData data];
    
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
    
}
//结束加载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //解析数据
    id obj = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    //先判断Delegate 是否存在
    //然后再判断delegate 是否响应方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(getDataSuccess:object:)]) {
        //执行方法
        [self.delegate getDataSuccess:self object:obj];
    }
}

//请求失败

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //先判断Delegate 是否存在
    //然后再判断delegate 是否响应方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(getDataFail:error:)]) {
        //执行方法
        [self.delegate getDataFail:self error:error];
        
    }
    
}
//block回调 方法实现
- (void)getDataWithURL:(NSString *)urlStr success:(successBlock)success fail:(failBlock)fail {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 如果Data 存在, 解析, 回调
        // 反之,失败回调
        if (data) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(self, obj);
        }else {
            fail(self, connectionError);
        }
    }];
}

@end
