//
//  ANUserInfo.h
//  HandheldAnn
//
//  Created by 傅登慧 on 16/5/30.
//  Copyright © 2016年 Elle.Sheena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANUserInfo : NSObject
/**
 Man 用户编号
 */
@property (nonatomic,assign) NSString * Man;

/**
 Level 层级
 */
@property (nonatomic,assign) NSString *Level;

/**
 Sitename 网店名称
 */
@property (nonatomic,assign) NSString * Sitename;

/**
 Name 用户名称
 */
@property (nonatomic,assign) NSString * Name;
@end
