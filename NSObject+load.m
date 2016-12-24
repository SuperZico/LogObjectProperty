//
//  NSObject+load.m
//  RunTime
//
//  Created by 周超 on 2016/12/23.
//  Copyright © 2016年 周超. All rights reserved.
//

#import "NSObject+load.h"

@implementation NSObject (load)
+(NSString *)objFromeDict:(__kindof NSDictionary *)dic{
    NSMutableString * str=[NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@---%@",key,[obj class]);
        NSString * code;
        if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]||[obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSArray * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]||[obj isKindOfClass:NSClassFromString(@"__NSCFString")]){
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSString * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSSingleEntryDictionaryI")]||[obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) NSDictionary * %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            if (strcmp([obj objCType], @encode(float)) == 0||strcmp([obj objCType], @encode(double)) == 0) {
                code=[NSString stringWithFormat:@"@property (nonatomic,assin) float %@;",key];
            }else{
                code=[NSString stringWithFormat:@"@property (nonatomic,assin) int %@;",key];
            }
        }else{
            code=[NSString stringWithFormat:@"@property (nonatomic,strong) %@ * %@;",NSStringFromClass([obj class]),key];//自定的对象
        }
        
        [str appendFormat:@"\n%@\n",code];
    }];
    
    return str;
}
@end
