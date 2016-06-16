//
//  NetWorkRequest.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/16.
//  Copyright © 2016年 com.cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkRequest : NSObject

/**
 * Get请求数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)getWithExtendUrl:(NSString *)url Para:(NSDictionary *)para Complete:(void (^) (BOOL succeed, id Object))complete;

/**
 *  Post请求数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)postWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success ;

/**
 * Get提交数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)submitGetWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success;

/**
 *  Post提交数据
 *
 *  @param url      添加url
 *  @param para     入参
 *  @param complete 完成block回调
 */
+ (void)submitPostWithExtendUrl:(NSString *)url Para:(NSDictionary *)para success:(void (^)(id data))success;

@end
