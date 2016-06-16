//
//  CYTools.m
//  Brokers
//
//  Created by 尚度 on 16/4/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "CYTools.h"
#import "sys/utsname.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW  [UIScreen mainScreen].bounds.size.width

@implementation CYTools

//截取指定下标之后的字符串
+ (NSString *)InterceptNSString:(NSString *)smpStr andLenth:(NSInteger )num{
    NSString *string = [smpStr substringFromIndex:smpStr.length-num];
    return string;
}

//判断字符串是否是整形
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断字符串是否是浮点形
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//处理空字符串(字符串为空时返回@“”)
+ (NSString *)checkNullString:(NSString *)string
{
    NSString *smpSting = string.length>0?string:@"";
    return smpSting; 
}

//处理返回的空字符串
+ (NSString *)checkTheStringWithNull:(NSString *)theString
{
    if ([theString isKindOfClass:[NSNull class]]||[theString isKindOfClass:[NSNull class]]||[theString isEqual:[NSNull null]]||[theString isEqualToString:@"<null>"]||[theString isEqualToString:@"(null)"]) {
        theString= @"";
    }
    return theString;
}

//以@""代替回车/换行等
+ (NSString *)replaceStringWithDataString:(NSString *)theString
{
    NSString *strUrl = [theString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strUrl = [theString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"	" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<p>" withString:@" "];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"</p>" withString:@" "];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
    //    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<>" withString:@" "];
    return strUrl ;
}

//去掉包裹符
+ (NSString *)unwrap:(NSString *)str
{
    if ( str.length >= 2 ){
        if ( [str hasPrefix:@"\""] && [str hasSuffix:@"\""] ){
            return [str substringWithRange:NSMakeRange(1, str.length - 2)];
        }
        
        if ( [str hasPrefix:@"'"] && [str hasSuffix:@"'"] ){
            return [str substringWithRange:NSMakeRange(1, str.length - 2)];
        }
    }
    
    return str;
}

//字符串转中文
+ (NSString *)stringByReplacingEncodingWithStr:(NSString *)theStr
{
//    theStr = [theStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    theStr = [theStr stringByRemovingPercentEncoding];
    return theStr;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)str{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (void)setUid:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUid
{
    return [self getUid:NO];
}

+ (NSString *)getUid:(BOOL)showLoginController
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    if (showLoginController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //跳转到登录界面
//            LoginRegisterViewController *login = [[LoginRegisterViewController alloc] init];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:nil];
        });
    }
    
    return uid;
}

+ (NSString *)getNowDate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    return nowDate;
}

//得到当前时间-1
+ (NSString *)getYesterdayDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];

    NSDate *date = [formatter dateFromString:nowDate];

    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];

    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];

    NSLog(@"yesterday %@    tomorrow %@", [formatter stringFromDate:yesterday], [formatter stringFromDate:tomorrow]);

    return [formatter stringFromDate:yesterday];
}
// 截取时间
+ (NSString *)substringDate:(NSString *)times andDM:(NSInteger)DM{
    NSString *time;
    if (DM==1) {//日报:2016-01-02
        if ([[times substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"0"]) {
            time=[times substringFromIndex:9];
        } else{
            time=[times substringFromIndex:8];//截取掉下标7之前的字符串
        }
    } else {//月报：2016-01
        if ([[times substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
            time=[times substringFromIndex:6];
        } else{
            time=[times substringFromIndex:5];//截取掉下标5之前的字符串
        }
    }
    NSLog(@"截取到的时间为：%@",time);
    return time;
}
// 截取省区、大区、分拨中心、经营片区   allarea=@"浙江省杭州市下沙区"   areas
+ (NSString *)substringArea:(NSString *)allarea substring:(NSString *)areas{
    
    allarea=[NSString stringWithFormat:@"%@",allarea];
    areas=[NSString stringWithFormat:@"%@",areas];
    
    allarea = [allarea stringByReplacingOccurrencesOfString:areas withString:@""];
    
    NSLog(@"截取的值为：%@",allarea);
    return allarea;
}

//  时间戳转时间的方法
+ (NSString *)theDateBecomeTimeStrWithStr:(NSString *)smpStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* date = [formatter dateFromString:smpStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

//得到时间差(如"刚刚")
+ (NSString *)checkHowTime:(NSString *)created_atStr
{
    NSString *smpStr;
    if (created_atStr.length>0) {
        
        NSArray *timeArr = [[NSArray alloc] initWithObjects:@"年",@"月",@"日", nil];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *created_atDate =  [dateFormatter dateFromString:created_atStr];
        NSDate * senddate=[NSDate date];
        
        //当前时间
        NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
        //得到相差秒数
        NSTimeInterval time=[senderDate timeIntervalSinceDate:created_atDate];
        NSLog(@"登录时间  得到相差秒数＝＝＝%d",(int)time);
        int days = ((int)time)/(3600*24);
        int hours = ((int)time)%(3600*24)/3600;
        int minute = (((int)time)%(3600*24)%3600)/60;
        
        if (days <= 0&&hours <= 0&&minute <= 0)
        {
            smpStr=@"刚刚";
        }
        if (days<=0&hours<=0&minute>0) {
            
            smpStr = [NSString stringWithFormat:@"%d分钟前",minute];
        }
        if (days<=0&hours>0) {
            smpStr = [NSString stringWithFormat:@"%d小时前",hours];
        }
        if (days>0) {
            
            NSArray *smpArr = [created_atStr componentsSeparatedByString:@" "];
            NSString *firstStr = [smpArr objectAtIndex:0];
            NSArray *smpTimeArr = [firstStr componentsSeparatedByString:@"-"];
            if (smpTimeArr.count>=3) {
                for (int i=0 ;i<3;i++) {
                    NSString *str = [smpTimeArr objectAtIndex:i];
                    NSString *str1 = [NSString stringWithFormat:@"%@%@",str,[timeArr objectAtIndex:i]];
                    if (smpStr.length>0) {
                        smpStr = [NSString stringWithFormat:@"%@%@",smpStr,str1];
                    }else{
                        smpStr = [NSString stringWithFormat:@"%@",str1];
                    }
                    
                }
            }
            
        }
        
    }
    return smpStr;
}

//得到时间差
+ (BOOL)checkTheTimeOverdueWithTheStarTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * senddate=[NSDate date];
    //当前时间
    NSDate *nowDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *beginDate = [dateFormatter dateFromString:beginTime];
    if (endDate>nowDate&&beginDate<nowDate) {
        return YES;
    }else{
        return NO;
    }
}

//检查手机号是否合法
+ (BOOL)checkTel:(NSString *)str
{
//    NSString *regex = @"^1+[3578]+\\d{9}";
    //^((13[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$
//    ^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$
    NSString *regex = @"^((17[0-9])|(14[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

//检查邮箱是否合法
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPasswordInput:(NSString *)password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
//    if (password.length>=6&&password.length<=18) {
//        return YES;
//    }else{
//        return NO;
//    }
}

//判断验证码位数(4位)
+ (BOOL)checkValidateNumber:(NSString *)text
{
    if (text.length==4) {
        return YES;
    }else{
        return NO;
    }
}

//判断字符串是否是指定个数
+ (BOOL)isValidateName:(NSString *)name andNum:(NSInteger )num{
    NSUInteger  character = 0;
    for(int i=0; i< [name length];i++){
        int a = [name characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (character >num) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma mark - 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark - 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma mark - 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

#pragma mark - 禁止输入表情
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//显示弹窗
+ (void)showAlert:(NSString*)alertString
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    //5秒之后消失
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

/** 计算Label高度 */
+(CGFloat )computeLabelH:(UILabel *)lbl{
    
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake(300, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [lbl.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    
    return textH;
}

//计算文字的高度或宽度
+(CGFloat)calculateSize:(NSString *)str andHeight:(BOOL)isHeight withFontSize:(CGFloat)fontSize limitValue:(NSUInteger)limitValue
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize rectSize = isHeight ? CGSizeMake(limitValue, MAXFLOAT) : CGSizeMake(MAXFLOAT, limitValue);
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize textSize = [str boundingRectWithSize:rectSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    
    return isHeight ? textSize.height : textSize.width;
}

//修改Label指定位置的文字样式
+ (void)setCouponLabel:(UILabel *)labell FontSize:(CGFloat )fontSize andRange:(NSRange)range andColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    labell.attributedText = str;
}

//隐藏工具条
+ (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]]){
            [view setFrame:CGRectMake(view.frame.origin.x, ScreenH, view.frame.size.width, view.frame.size.height)];
        }else{
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenH)];
        }
    }
    
    [UIView commitAnimations];
}

//显示工具条
+ (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]]){
            [view setFrame:CGRectMake(view.frame.origin.x, ScreenH-49, view.frame.size.width, view.frame.size.height)];
            
        }else{
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenH-49)];
        }
    }
    
    [UIView commitAnimations];
}

//裁剪图片
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage; //返回的就是已经改变的图片
}

//等比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGSize)scaleSize
{
    UIGraphicsBeginImageContext(scaleSize);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 颜色转换 十六进制颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (UIColor*) colorWithHex:(NSInteger)hexValue{
    return [UIColor redColor];
}
+ (UIColor *) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

//+ (UIColor *) colorWithHex:(NSInteger)hexValue
//{
//    return [UIColor colorWithHex:hexValue alpha:1.0];
//}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

// 获取程序Document目录路径
+ (NSString *)getDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//在Document目录下创建目录
+ (BOOL) createDirectoryInDocByName:(NSString *)docName
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *docPath = [[self getDocumentPath] stringByAppendingPathComponent:docName];
    return [fileManage createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:NULL];
}

//在Document目录是否存在XX目录
+ (BOOL) isExistPath:(NSString *)path {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    return [fileManage fileExistsAtPath:path];
    
}
//在沙盒中是否存在XX目录
+ (BOOL) isExistInDocByPath:(NSString *)path {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *docPath = [[self getDocumentPath] stringByAppendingPathComponent:path];
    return [fileManage fileExistsAtPath:docPath];
}

//在沙盒中查找指定文件夹
+ (NSString *)getFilePathInDocByAppendPath:(NSString *)appendPath {
    return  [[self getDocumentPath] stringByAppendingPathComponent:appendPath];
    
}

// 删除目录（含自目录、文件）或文件
+ (BOOL) removeDocOrFileInDocumentByReletivePath:(NSString *)relativePath {
    NSString *path = [[self getDocumentPath] stringByAppendingPathComponent:relativePath];
    if ([self isExistInDocByPath:relativePath]) {
        NSFileManager *fileManage = [NSFileManager defaultManager];
        
        return [fileManage removeItemAtPath:path error:NULL];
    }
    return NO;
}

// 获取Library/Caches 下缓存目录路径
+ (NSString *)getLibCachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//打电话
+ (void)tellPhoneNumber:(NSString *)teleNum {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",teleNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//MD5 16位加密
+ (NSString *)MD5_16:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

/** 创建按钮 */
+ (UIButton *)btnFrame:(CGRect)frame andTitle:(NSString *)title andAdd:(UIView *)views{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [views addSubview:btn ];
    return btn;
}

+ (UILabel *)labFrame:(CGRect)frame andAdd:(UIView *)views{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = [UIFont systemFontOfSize: 14.0];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    [views addSubview:lab ];
    return lab;
}

@end
