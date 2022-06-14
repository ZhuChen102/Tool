//
//  NSObject+ZCArchiver.m
//  归档接档Test
//
//  Created by Zhu on 16/9/29.
//  Copyright © 2016年 ZhuChen. All rights reserved.
//

#import "NSObject+ZCArchiver.h"
#import <objc/runtime.h>

@implementation NSObject (ZCArchiver)
//删除文件
- (void)deleteAllData:(NSString *)fileName{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ZCArchiver/%@.archiver",fileName]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}
// 创建文件并返回路径
- (NSString *)getPath:(NSString *)fileName {
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ZCArchiver/%@.archiver",fileName]];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {//不存在则创建
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"ZCArchiver"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
#pragma mark - 归档
// 自定义归档方法
- (void)archiveDataWithFileName:(NSString *)fileName {
    //创建文件
    NSString *path = [self getPath:fileName];
    //归档
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}
// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    objc_property_t *attributes = class_copyPropertyList([self class], &count); //属性列表
    for (int i = 0; i < count; i ++) {
        objc_property_t attributey = attributes[i]; //循环获取属性
        NSString *attributeyName = [[NSString alloc] initWithCString:property_getName(attributey) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:attributeyName];
        [aCoder encodeObject:value forKey:attributeyName];
    }
    free(attributes);
}
#pragma mark - 解档
//解归档方法
- (id)unarchiveDataWithFileName:(NSString *)fileName {
    NSString *path = [self getPath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
//解档
#pragma clang diagnostic ignored "-Wobjc-designated-initializers" //忽略警告
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    unsigned int count;
    objc_property_t *attributes = class_copyPropertyList([self class], &count); //属性列表
    for (int i = 0; i < count; i ++) {
        objc_property_t attributey = attributes[i]; //循环获取属性
        NSString *attributeyName = [[NSString alloc] initWithCString:property_getName(attributey) encoding:NSUTF8StringEncoding];
        id value = [aDecoder decodeObjectForKey:attributeyName];
        [self setValue:value forKey:attributeyName];
    }
    free(attributes);
    return self;
}




@end
