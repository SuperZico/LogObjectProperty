//
//  NSObject+load.h
//  RunTime
//
//  Created by 周超 on 2016/12/23.
//  Copyright © 2016年 周超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (load)
//将词典转为对象
+(instancetype)modelWithDict:(__kindof NSDictionary *)dic;
//生成对象属性
+(NSString *)objFromeDict:(__kindof NSDictionary *)dic;

@end
