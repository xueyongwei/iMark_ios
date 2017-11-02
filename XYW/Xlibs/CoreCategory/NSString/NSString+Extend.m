//
//  NSString+Extend.m
//  CoreCategory
//
//
//  Created by 薛永伟 on 15/11/26.
//  xueyongwei@foxmail.com
//  Copyright © 2015年 薛永伟. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)


/** 删除所有的空格 */
-(NSString *)deleteSpace{
    
    NSMutableString *strM = [NSMutableString stringWithString:self];
    
    [strM replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, strM.length)];
    
    return [strM copy];
}


/*
 *  时间戳对应的NSDate
 */
-(NSDate *)date{
    
    NSTimeInterval timeInterval=self.floatValue;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}


/**
 *  时间戳转格式化的时间字符串
 */
-(NSString *)timestampToTimeStringWithFormatString:(NSString *)formatString{
    //时间戳转date
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    
    return [self timeStringFromDate:date formatString:formatString];
}

-(NSString *)timeStringFromDate:(NSDate *)date formatString:(NSString *)formatString{
    //实例化时间格式化工具
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    //定义格式
    formatter.dateFormat=formatString;
    
    //时间转化为字符串
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/*
 *取最后一个X字符前的字符串
 */
-(NSString *)beforeLastStr:(NSString *)x
{
    NSString *st = [[self reverseStr] substringFromIndex:[[self reverseStr] rangeOfString:x].location+1];
    return [st reverseStr];
}
/*
 *反转字符串
 */
-(NSString *)reverseStr{
    NSMutableString * reverseString = [NSMutableString string];
    for(int i = 0 ; i < self.length; i ++){
        //倒序读取字符并且存到可变数组数组中
        unichar c = [self characterAtIndex:self.length- i -1];
        [reverseString appendFormat:@"%c",c];
    }
    return reverseString;
}

@end
