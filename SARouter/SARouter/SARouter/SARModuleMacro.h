//
//  SARModuleMacro.h
//  SARouter
//
//  Created by Saturday on 2017/8/21.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#ifndef SARModuleMacro_h
#define SARModuleMacro_h

// 数据有效性

#define SARIsValidString(str) (str && ![str isKindOfClass:[NSNull class]] && ![str isEqualToString:@"<null>"] && ![str isEqualToString:@""])
#define SARSafeString(str) (SARIsValidString(str)?str:@"")
#define SARIsValidArray(arr) ([arr isKindOfClass:[NSArray class]])
#define SARSafeArray(arr) (SARIsValidArray(arr)?arr:@[])



// 字典key

#define kSARModulePath @"kSARModulePath"
#define kSARModuleClass @"kSARModuleClass"
#define kSARModuleClassMethods @"kSARModuleClassMethods"


#endif /* SARModuleMacro_h */
