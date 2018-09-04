//
//  AAA.m
//  SARouter
//
//  Created by Saturday on 2017/8/21.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#import "AAA.h"
#import "SARouter.h"

SARModule(AAA)

@implementation AAA

+(void)load{
//    [SARouter lrrCheckClassMethod:@"set" path:@"TTT"];
}

+(NSString *)lrrPath{
    return @"TTT/AAA";
}

+(NSArray<NSString *> *)lrrClassMethods{
    return @[@"get:"];
}

//+(instancetype)lrrHandleClassMethod:(NSString *)method params:(NSDictionary *)params{
////    if ([method isEqualToString:@"get"]) {
////        NSLog(@"get");
////        [SARouter lrrHandleClassMethod:@"set" path:@"TTT" params:params];
////    }
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",method]) withObject:params];
//#pragma clang diagnostic pop
//    
//    return nil;
//}

+(void)get:(NSString *)params{
    
    [SARouter lrrHandleClassMethod:@"set:aa:" path:@"TTT" params:@[params,@"cc"]];
}

+(void)aaa:(NSDictionary *)params{
}

@end
