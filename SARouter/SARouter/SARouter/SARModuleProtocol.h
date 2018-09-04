//
//  SARModuleProtocol.h
//  SARouter
//
//  Created by Saturday on 2017/8/18.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SARModuleProtocol <NSObject>

#pragma mark - 用于注册 
/*
 * 用于生成url，如果是子模块用/分隔，比如B是A的子模块：A/B
 */
+(NSString *)lrrPath;

#pragma mark - class
/*
 * 用于注册可用类方法 NSStringFromSelector(@selector()) 方法参数只支持id类型
 */
+(NSArray<NSString *> *)lrrClassMethods;

@end
