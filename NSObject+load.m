//
//  NSObject+load.m
//  RunTime
//
//  Created by 周超 on 2016/12/23.
//  Copyright © 2016年 周超. All rights reserved.
//

#import "NSObject+load.h"
#import "NSObject+load.h"
#import <objc/message.h>
@implementation NSObject (load)
+(NSString *)objFromeDict:(__kindof NSDictionary *)dic{
    NSMutableString * str=[NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"%@---%@",key,[obj class]);
        NSString * code;
        if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]||[obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSArray * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]||[obj isKindOfClass:NSClassFromString(@"__NSCFString")]){
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSString * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSSingleEntryDictionaryI")]||[obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSDictionary * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            if (strcmp([obj objCType], @encode(float)) == 0||strcmp([obj objCType], @encode(double)) == 0) {
                code=[NSString stringWithFormat:@"@property (nonatomic,assign) float %@;",key];
            }else{
                code=[NSString stringWithFormat:@"@property (nonatomic,assign) int %@;",key];
            }
        }else{
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) %@ * %@;",NSStringFromClass([obj class]),key];//自定的对象
        }
        
        [str appendFormat:@"\n%@\n",code];
    }];
    
    return str;
}

+(instancetype)modelWithDict:(__kindof NSDictionary *)dic{
    id objc=[[self alloc]init];
    unsigned int count=0;
    Ivar * ivarList= class_copyIvarList(self , &count);//对象属性列表
    for (int i=0; i<count; i++) {
        Ivar ivar=ivarList[i];//获取属性
        NSString * propertyName=[NSString stringWithUTF8String:ivar_getName(ivar)];//获取属性的名称
        NSString * propertyType=[NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];//获取属性的类型
        
        NSString * key=[propertyName substringFromIndex:1];
        id value=dic[key];
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {//字典类，但不是字典的二次转对象
            NSString * str=[propertyType substringFromIndex:2];
            NSRange range= [str rangeOfString:@"\""];
            str= [str substringToIndex:range.location];
            Class  Typeclass=NSClassFromString(str);//将java转为类
            value = [Typeclass modelWithDict:value];
        }
        if (value) {//value有值才传，不然会崩
            [objc setValue:value forKey:key];
        }
        
        
        
        
    }
    
    return objc;
}
@end
