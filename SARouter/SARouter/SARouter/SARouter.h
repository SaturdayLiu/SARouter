//
//  SARouter.h
//  SARouter
//
//  Created by Saturday on 2017/8/17.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SARAnnotation.h"
#import "SARModuleProtocol.h"
#import "SARModuleMacro.h"

@interface SARouter : NSObject

/*
 调用注册方法，method为方法名，path为对应模块，params为参数
 */
+(id)lrrHandleClassMethod:(NSString *)method path:(NSString *)path params:(NSArray *)params;

@end

/*
 强烈建议在开发阶段打开SARDebug，可以帮助定位到异常情况
 只需加入以下代码即可打开
 */
//#define SARDebug
@interface SARouter (debug)

//在调用的时候  建议在load方法里面加上这个检测方法  请放心  只有SARDebug模式打开时才会起作用
+(void)lrrCheckClassMethod:(NSString *)method path:(NSString *)path;

@end

