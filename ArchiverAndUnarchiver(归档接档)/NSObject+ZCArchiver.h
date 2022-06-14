//
//  NSObject+ZCArchiver.h
//  归档接档Test
//
//  Created by Zhu on 16/9/29.
//  Copyright © 2016年 ZhuChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZCArchiver)

// 自定义归档方法
- (void)archiveDataWithFileName:(NSString *)fileName;
// 自定义解档方法
- (id)unarchiveDataWithFileName:(NSString *)fileName;
//删除文件
- (void)deleteAllData:(NSString *)fileName;

@end
