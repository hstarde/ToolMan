//
//  TimeTool.m
//  HouseWifery
//
//  Created by macbook on 2018/10/15.
//  Copyright © 2018年 hstar. All rights reserved.
//

#import "TimeTool.h"


@implementation DateModel
-(NSString *)commonpickName
{
    return self.name;
}
-(NSString *)commonpickID
{
    return self.ID;
}
-(NSArray *)commonpickChildArr
{
    return self.arrchild;
}
@end

@implementation TimeTool


static TimeTool *_sharedMan;
+ (instancetype)sharedMan {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedMan = [[self alloc] init]; });
    return _sharedMan;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//获取时间戳
+(NSString *)getTimestamp
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    return dateString;
}
//获取 13位时间戳
+(NSString *)getIntTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    return  [TimeTool getIntTimestamp:dat];
}
//获取 13位时间戳 传入时间
+(NSString *)getIntTimestamp:(NSDate*)time
{
    NSTimeInterval a=[time timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
//时间戳 转时间yyyy-MM-dd HH:mm:ss
+(NSDate *)getTimeWithIntStr:(NSString *)timeInt formatterStr:(NSString *)formatterStr
{
    if ([formatterStr isEqualToString:@""]||formatterStr==nil) {
        formatterStr=@"yyyy-MM-dd HH:mm:ss";
    }
    NSTimeInterval time=[timeInt doubleValue]/1000;//+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    return detaildate;
}

//时间戳 转时间字符串yyyy-MM-dd HH:mm:ss
+(NSString *)getTimeStrWithIntStr:(NSString *)timeInt formatterStr:(NSString *)formatterStr
{
    if ([formatterStr isEqualToString:@""]||formatterStr==nil) {
        formatterStr=@"yyyy-MM-dd HH:mm:ss";
    }
    NSTimeInterval time=[timeInt doubleValue];//+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterStr];
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

//时间与字符串互转//yyyy-MM-dd HH:mm:ss
+(NSString *)getStrWithTime:(NSDate *)time formatterStr:(NSString *)formatterStr
{
    if ([formatterStr isEqualToString:@""]||formatterStr==nil) {
        formatterStr=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterStr];
    NSString *str = [dateFormatter stringFromDate:time];
    return str;
}
//时间与字符串互转//yyyy-MM-dd HH:mm:ss
+(NSDate *)getTimeWithStr:(NSString *)str formatterStr:(NSString *)formatterStr
{
    if ([formatterStr isEqualToString:@""]||formatterStr==nil) {
        formatterStr=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterStr];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}
//获取前count天的数组
+(NSMutableArray *)getArrdate:(NSDate *)date count:(NSInteger)count{
    NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:count];
    for (int i=0; i<count; i++) {
        NSDate *lastDay = [NSDate dateWithTimeInterval:-(24*60*60)*i sinceDate:date];//前i天
        [arr insertObject:lastDay atIndex:0];//
    }
    return arr;
}

//获取 星期几  字符串
+(NSString *)getWeekStr:(NSDate *)time{
    NSInteger weekInt=[TimeTool getWeek:time];
    NSString *weekStr=@"";
    if (weekInt==1) {weekStr=@"日";}else if(weekInt==2){weekStr=@"一";}else if(weekInt==3){weekStr=@"二";}else if(weekInt==4){weekStr=@"三";}else if(weekInt==5){weekStr=@"四";}else if(weekInt==6){weekStr=@"五";}else{weekStr=@"六";}
    return weekStr;
//    return [NSString stringWithFormat:@"星期%@",weekStr];
}
//获取周几
+(NSInteger)getWeek:(NSDate *)time
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:time];
    return [comps weekday];
}
//获取时间  之前与之后  day 可以为负
+(NSDate *)getTimeAgo:(int)day month:(int)month year:(int)year andtime:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

/**
 *  根据时间字符串转化成时间描述，如"刚刚","1分钟前","1小时前","1个月前"等等
 */
+ (NSString *)timeAgo:(NSString *)dateString {
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //服务器系统时间
    NSDate *compareDate = [dateFormatter dateFromString:dateString];
    
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceDate:[NSDate date]];
    
    timeInterval = -timeInterval;
    
    long temp = 0;
    
    if (timeInterval < 60) {
        
        return [NSString stringWithFormat:@"刚刚"];
        
    } else if((temp = timeInterval / 60) < 60) {
        
        return [NSString stringWithFormat:@"%ld分钟前",temp];
        
    } else if((temp = temp / 60) < 24) {
        
        return [NSString stringWithFormat:@"%ld小时前",temp];
        
    } else if((temp = temp / 24) < 30) {
        
        return [NSString stringWithFormat:@"%ld天前",temp];
        
    } else if((temp = temp / 30) < 12) {
        
        return [NSString stringWithFormat:@"%ld月前",temp];
    } else {
        temp = temp / 12;
        return [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return [NSString stringWithFormat:@"%ld年%ld月", [compareDate year], [compareDate month]];
}

//转换成时分秒

+ (NSString *)timeFormSec:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours==0) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
}

/**
  *  是否为今天
  */
+ (BOOL)isToday:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

/**
  *  是否为昨天
  */
+ (BOOL)isYesterday:(NSDate*)date
{
    // 2014-05-01
    NSDate *nowDate = [TimeTool dateWithYMD:[NSDate date]];
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD:date];
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
  *  是否为今年
  */
+ (BOOL)isThisYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return nowCmps.year == selfCmps.year;
}
//判断在两个时间之间
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending){
        return NO;
    }
    if ([date compare:endDate] == NSOrderedDescending){
        return NO;
    }
    return YES;
}

/**
 *  返回一个只有年月日的时间
 */
+ (NSDate *)dateWithYMD:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

/**
 *  获得与当前时间的差距
 */
+ (NSDateComponents *)deltaWithNow:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
}
-(NSMutableArray *)arrYear{
    if (_arrYear==nil) {
        _arrYear=[[NSMutableArray alloc]init];
        NSDate *now=[NSDate date];
        for (int i = 1970; i <= now.year; i++) {
            DateModel *year=[[DateModel alloc]init];
            year.ID=[NSString stringWithFormat:@"%d",i];
            year.name=[NSString stringWithFormat:@"%d",i];
            NSMutableArray *monthArray=[[NSMutableArray alloc]init];
            for (int j = 1; j <= 12; j++) {
                DateModel *month=[[DateModel alloc]init];
                month.ID=[NSString stringWithFormat:@"%d",j];
                month.name=[NSString stringWithFormat:@"%02d",j];
                NSMutableArray *dayArray=[[NSMutableArray alloc]init];
                for (int k=1; k<=[TimeTool calculateDayWithMonth:j andYear:i]; k++) {
                    DateModel *day=[[DateModel alloc]init];
                    day.ID=[NSString stringWithFormat:@"%d",k];
                    day.name=[NSString stringWithFormat:@"%02d",k];
                    [dayArray addObject:day];
                }
                month.arrchild=dayArray;
                [monthArray addObject:month];
            }
            year.arrchild=monthArray;
            [_arrYear addObject:year];
        }
    }
    return _arrYear;
}
-(NSMutableArray *)arrTime
{
    if (_arrTime==nil) {
        _arrTime=[[NSMutableArray alloc]init];
        for (int i = 0; i <= 23; i++) {
            DateModel *hh=[[DateModel alloc]init];
            hh.ID=[NSString stringWithFormat:@"%d",i];
            hh.name=[NSString stringWithFormat:@"%02d",i];
            NSMutableArray *hhArray=[[NSMutableArray alloc]init];
            for (int j = 0; j <= 59; j++) {
                DateModel *mm=[[DateModel alloc]init];
                mm.ID=[NSString stringWithFormat:@"%d",j];
                mm.name=[NSString stringWithFormat:@"%02d",j];
                NSMutableArray *mmArray=[[NSMutableArray alloc]init];
                for (int k=0; k<=59; k++) {
                    DateModel *ss=[[DateModel alloc]init];
                    ss.ID=[NSString stringWithFormat:@"%d",k];
                    ss.name=[NSString stringWithFormat:@"%02d",k];
                    [mmArray addObject:ss];
                }
                mm.arrchild=mmArray;
                [hhArray addObject:mm];
            }
            hh.arrchild=hhArray;
            [_arrTime addObject:hh];
        }
    }
    return _arrTime;
}
//根据month和year计算对应的天数
+ (NSInteger)calculateDayWithMonth:(int)month andYear:(int)year {
    NSInteger dayCount = 28;
    if (year / 100 == 0) {
        if (year / 4 == 0) {
            dayCount = 29;
        } else {
            dayCount = 28;
        }
    } else {
        if (year / 4 == 0) {
            dayCount = 29;
        } else {
            dayCount = 28;
        }
    }
    NSInteger _dayNumber=30;
    switch (month) {
        case 1:_dayNumber = 31; break;
        case 2:_dayNumber = dayCount; break;
        case 3:_dayNumber = 31; break;
        case 4:_dayNumber = 30; break;
        case 5:_dayNumber = 31; break;
        case 6:_dayNumber = 30; break;
        case 7:_dayNumber = 31; break;
        case 8:_dayNumber = 31; break;
        case 9:_dayNumber = 30; break;
        case 10:_dayNumber = 31; break;
        case 11:_dayNumber = 30; break;
        case 12:_dayNumber = 31; break;
    }
    return _dayNumber;
}

@end
