//
//  SARAnnotation.h
//  SARouter
//
//  Created by Saturday on 2017/8/18.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SARModuleSectName
#define SARModuleSectName "SARModules"
#endif

//将数据存到特定的数据段中
#define SARDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

//声明组件模块
#warning 不支持动态库
#define SARModule(name) \
char * k##name##_module SARDATA(SARModules) = ""#name""; \
@interface name () <SARModuleProtocol> \
@end\
@interface name (Annotation)\
@end\
@implementation name (Annotation)\
+(void)load{\
    [SARAnnotation addModule:[name class]];\
}\
@end\

@interface SARAnnotation : NSObject

+(NSArray<NSString *> *)annotationModules;
+(void)addModule:(Class)module;

@end
