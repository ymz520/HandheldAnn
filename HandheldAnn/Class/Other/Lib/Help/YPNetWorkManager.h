//
//  YPNetWorkManager.h
//  Ben
//
//  Created by 在 on 15/12/14.
//  Copyright © 2015年 SuHuiLong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YPNetWorkManager;

@protocol YPNetWorkManagerDelegate <NSObject>

@optional
//获取数据成功
- (void)getDataSuccess:(YPNetWorkManager *)network object:(id)obj;
- (void)getDataFail:(YPNetWorkManager *)network error:(NSError *)error;

@end
//声明block
//Block 是匿名函数
//tapedef 类型重命名
//定义了一个参数为(YPNetWorkManager, id)返回值为void类型的函数类型, 类型重命名为successBlock
//成功回调
typedef void (^successBlock)(YPNetWorkManager *net, id object);
//失败回调
typedef void (^failBlock)(YPNetWorkManager *net, NSError *error);







@interface YPNetWorkManager : NSObject

@property (nonatomic, assign) id<YPNetWorkManagerDelegate> delegate;

- (void)getDataWithURL:(NSString *)urlStr parameter:(NSString *)para;

//block回调 方法声明
- (void)getDataWithURL:(NSString *)urlStr success:(successBlock)success fail:(failBlock)fail;


@end
