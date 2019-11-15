//
//  TimeTool.h
//  HouseWifery
//
//  Created by macbook on 2018/10/15.
//  Copyright © 2018年 hstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Extension.h"
#import "NSData+CommonCryptor.h"


@interface DateModel : NSObject

@property (strong,nonatomic) NSString *ID;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSArray *arrchild;

@end


@interface TimeTool : NSObject


+ (instancetype)sharedMan;

@property (strong,nonatomic) NSMutableArray *arrYear;
@property (strong,nonatomic) NSMutableArray *arrTime;

//获取时间戳
+(NSString *)getTimestamp;
//获取 13位时间戳
+(NSString *)getIntTimestamp;
//获取 13位时间戳 传入时间
+(NSString *)getIntTimestamp:(NSDate*)time;

//时间戳 转时间
//yyyy-MM-dd HH:mm:ss
+(NSDate *)getTimeWithIntStr:(NSString *)timeInt formatterStr:(NSString *)formatterStr;
//时间戳 转时间字符串
//yyyy-MM-dd HH:mm:ss
+(NSString *)getTimeStrWithIntStr:(NSString *)timeInt formatterStr:(NSString *)formatterStr;

//时间与字符串互转//yyyy-MM-dd HH:mm:ss
+(NSString *)getStrWithTime:(NSDate *)time formatterStr:(NSString *)formatterStr;
+(NSDate *)getTimeWithStr:(NSString *)str formatterStr:(NSString *)formatterStr;
//获取前count天的数组
+(NSMutableArray *)getArrdate:(NSDate *)date count:(NSInteger)count;
//获取 星期几  字符串
+(NSString *)getWeekStr:(NSDate *)time;
//获取周几
+(NSInteger)getWeek:(NSDate *)time;

//获取时间  之前与之后  day 可以为负
+(NSDate *)getTimeAgo:(int)day month:(int)month year:(int)year andtime:(NSDate *)date;
/**
 *  根据时间字符串转化成时间描述，如"刚刚","1分钟前","1小时前","1个月前"等等
 */
+ (NSString *)timeAgo:(NSString *)dateString;


+ (NSString *)timeFormSec:(int)totalSeconds;


/**
  *  是否为今天
  */
+ (BOOL)isToday:(NSDate *)date;

/**
  *  是否为昨天
  */
+ (BOOL)isYesterday:(NSDate *)date;

/**
  *  是否为今年
  */
+ (BOOL)isThisYear:(NSDate *)date;

//判断在两个时间之间
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

/**
 *  返回一个只有年月日的时间
 */
+ (NSDate *)dateWithYMD:(NSDate *)date;

/**
  *  获得与当前时间的差距
 */
+ (NSDateComponents *)deltaWithNow:(NSDate *)date;

//根据month和year计算对应的天数
+ (NSInteger)calculateDayWithMonth:(int)month andYear:(int)year;
@end
