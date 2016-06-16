//
//  CYTools.h
//  Brokers
//
//  Created by 尚度 on 16/4/12.
//  Copyright © 2016年 Charles. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface CYTools : NSObject

//===============================================字符串相关操作==========================================================
/** 截取指定下标之后的字符串 */
+ (NSString *)InterceptNSString:(NSString *)smpStr andLenth:(NSInteger )num;

/** 判断字符串是否是整形 */
+ (BOOL)isPureInt:(NSString*)string;
/** 判断字符串是否是浮点型 */
+ (BOOL)isPureFloat:(NSString*)string;

/** 处理空字符串(字符串为空时返回@“”) */
+ (NSString *)checkNullString:(NSString *)string;
/** 处理返回的空字符串 */
+ (NSString *)checkTheStringWithNull:(NSString *)theString;
/** 以@""代替回车/换行等 */
+ (NSString *)replaceStringWithDataString:(NSString *)theString;
/** 去掉包裹符 \xxxx\ ==> xxxx   'xxx' => xxx */
+ (NSString *)unwrap:(NSString *)str;
/** 字符串转中文 */
+ (NSString *)stringByReplacingEncodingWithStr:(NSString *)theStr;
/** JSON字符串转换为字典 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)str;

//设置uid(当前用户id)
+ (void)setUid:(NSString *)uid;
/**
 获得当前登录用户的uid，检测是否登录
 NSString *：已经登录, nil：没有登录
 */
+ (NSString *)getUid;
/**
 *  判断是否登录
 *  @param showLoginController 是否需要显示登录界面
 */
+ (NSString *)getUid:(BOOL)showLoginController;

//=================================================时间相关操作==========================================================
/** 得到当前时间-1 */
+ (NSString *)getNowDate;
+ (NSString *)getYesterdayDate;
/** 截取时间 */
+ (NSString *)substringDate:(NSString *)times andDM:(NSInteger)DM;
/** 截取省区、大区、分拨中心、经营片区 */
+ (NSString *)substringArea:(NSString *)allarea substring:(NSString *)areas;
/** 时间戳转换 */
+ (NSString *)theDateBecomeTimeStrWithStr:(NSString *)smpStr;
/** 得到时间差(如"刚刚") */
+ (NSString *)checkHowTime:(NSString *)created_atStr;
/** 得到时间差 */
+ (BOOL)checkTheTimeOverdueWithTheStarTime:(NSString *)beginTime endTime:(NSString *)endTime;

//=================================================常用判断相关==========================================================
/** 检查手机号是否合法 */
+ (BOOL)checkTel:(NSString *)str;
/** 检查邮箱是否合法 */
+(BOOL)isValidateEmail:(NSString *)email;
/** 正则匹配用户密码6-18位数字和字母组合 */
+ (BOOL)checkPasswordInput:(NSString *)password;
/** 判断验证码位数(4位) */
+ (BOOL)checkValidateNumber:(NSString *)text;
/** 判断字符串是否是指定个数 */
+ (BOOL)isValidateName:(NSString *)name andNum:(NSInteger )num;

/** 正则匹配用户姓名,20位的中文或英文 */
+ (BOOL)checkUserName : (NSString *) userName;
/** 正则匹配用户身份证号 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;
/** 正则匹员工号,12位的数字 */
+ (BOOL)checkEmployeeNumber : (NSString *) number;
/** 正则匹配URL */
+ (BOOL)checkURL : (NSString *) url;
/** 禁止输入表情 */
+ (NSString *)disable_emoji:(NSString *)text;

//=================================================UI相关==============================================================
/** 显示弹窗 */
+ (void)showAlert:(NSString*)alertString;

/** 计算Label高度 */
+(CGFloat )computeLabelH:(UILabel *)lbl;
/**
 *  计算文字的高度或宽度
 *  @param isHeight   YES 高度  NO 宽度
 *  @param font       字体大小
 *  @param limitValue YES获取高度 限制值为宽度   NO获取宽度 限制值为高度
 */
+(CGFloat)calculateSize:(NSString *)str andHeight:(BOOL)isHeight withFontSize:(CGFloat)fontSize limitValue:(NSUInteger)limitValue;
/** 修改Label指定位置的文字样式 */
+ (void)setCouponLabel:(UILabel *)labell FontSize:(CGFloat )fontSize andRange:(NSRange)range andColor:(UIColor *)color;

/** 隐藏工具条 */
+ (void)hideTabBar:(UITabBarController *) tabbarcontroller;
/** 显示工具条 */
+ (void)showTabBar:(UITabBarController *) tabbarcontroller;

/** 裁剪图片 */
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

/** 等比例缩放图片 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGSize)scaleSize;

//==================================================沙盒操作=============================================================
/** 获取程序document目录路径 */
+ (NSString *)getDocumentPath;

/** 在Document目录下创建文件夹 */
+ (BOOL)createDirectoryInDocByName:(NSString *)docName;

/** 在Document目录是否存在XX文件夹 */
+ (BOOL)isExistPath:(NSString *)path;

/** 在沙盒中是否存在XX目录 */
+ (BOOL)isExistInDocByPath:(NSString *)path;

/** 在沙盒中查找指定文件夹 */
+ (NSString *)getFilePathInDocByAppendPath:(NSString *)appendPath;

/** 删除目录（含自目录、文件）或文件 */
+ (BOOL)removeDocOrFileInDocumentByReletivePath:(NSString *)relativePath;

/** 获取Library/Caches 下缓存目录路径 */
+ (NSString *)getLibCachesPath;

//==================================================颜色相关=============================================================
/** 16进制字符串转UIColor */
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

//==================================================其它===============================================================
/** 打电话 */
+ (void)tellPhoneNumber:(NSString *)teleNum;

/** MD5 16位加密 */
+ (NSString *)MD5_16:(NSString *)str;

/** 创建按钮 */
+ (UIButton *)btnFrame:(CGRect)frame andTitle:(NSString *)title andAdd:(UIView *)views;

/** 创建按钮 */
+ (UILabel *)labFrame:(CGRect)frame andTitle:(NSString *)title andAdd:(UIView *)views;
@end
