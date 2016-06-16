//
//  NetWorkRequest.m
//  RequestDemo
//
//  Created by 张椋萌 on 16/3/14.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "NetWorkRequest.h"

@implementation NetWorkRequest

/**
 * Get请求数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)getWithExtendUrl:(NSString *)url Para:(NSDictionary *)para Complete:(void (^) (BOOL succeed, id Object))complete {
    //创建manger单例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //拼接url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, url];
    
    //1.改变解析器类型为:万能解析器 ---> 手动解析JSON
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.改变判断条件的类型,以使类型匹配,acceptableContentTypes默认情况下无text/plain类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    //开始请求
    [manager GET:urlStr parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功，data: %@", responseObject);
        //写缓存
//        NSString *cachePath = @"缓存路径";//  /Library/Caches/MyCache
//        [responseObject writeToFile:cachePath atomically:YES];
        complete(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败，Error: %@", error);
        NSString * cachePath = @"缓存路径";
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            //从本地读缓存文件
//            NSData *data = [NSData dataWithContentsOfFile:cachePath];
        }
    }];
}


/**
 *  Post请求数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)postWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success {
    //创建manger单例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //拼接url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    //开始请求
    [manager POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //json解析
//        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求成功，data: %@", responseObject);
        success(responseObject);
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败，Error: %@", error);
    }];
}

/**
 *  Post提交数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)submitPostWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success {
    // 1.创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //拼接url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    //开始提交 利用网络管理者上传数据para
    // formData: 专门用于拼接需要上传的数据
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        NSLog(@"请求成功 %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"请求失败 %@", error);
    }];
}

+ (void)submitGetWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //声明请求的数据是json
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //申明返回的数据是json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, url];
    [manager GET:urlStr parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"请求失败 错误:%@",error);  //这里打印错误信息
    }];
}

@end
