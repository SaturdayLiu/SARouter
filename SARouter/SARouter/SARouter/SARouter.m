//
//  SARouter.m
//  SARouter
//
//  Created by Saturday on 2017/8/17.
//  Copyright © 2017年 Sa.Co. All rights reserved.
//

#import "SARouter.h"

@interface SARouter ()

+ (instancetype)shareInstance;
@property (nonatomic, strong) NSMutableDictionary *annotationModules;

@end

@implementation SARouter

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id LRRInstance = nil;
    dispatch_once(&once, ^{
        LRRInstance = [[self alloc] init];
    });
    return LRRInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerAnnotationModules];
    }
    return self;
}

#pragma mark - 

+(id)lrrHandleClassMethod:(NSString *)method path:(NSString *)path params:(NSArray *)params{
    
    NSAssert(SARIsValidString(method) && SARIsValidString(path), @"无效参数");
    [self lrrCheckClassMethod:method path:path];

    NSDictionary *moduleDic = [[SARouter shareInstance] moduleWithPath:path];
    Class module = NSClassFromString(moduleDic[kSARModuleClass]);
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@",method]);
    NSMethodSignature *signature = [module methodSignatureForSelector:selector];
    
#ifdef SARDebug
    NSAssert(signature, @"方法解析失败");
#else
    if (!signature) {
        return nil;
    }
#endif
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = module;
    invocation.selector = selector;
    NSInteger paramsCount = signature.numberOfArguments - 2;//第一个self，第二个_cmd
    paramsCount = MIN(paramsCount, params.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = params[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    [invocation retainArguments];
    [invocation invoke];
    void *returnValue = NULL;
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    return (__bridge id) returnValue;
}


#pragma mark -

-(void)registerAnnotationModules{
    NSArray<NSString *> *annotationModules = [SARAnnotation annotationModules];
    [annotationModules enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSAssert(SARIsValidString(obj), @"类名obj不能为空");
        NSAssert([NSClassFromString(obj) conformsToProtocol:@protocol(SARModuleProtocol)], @"未实现SARModuleProtocol协议");
        NSAssert([NSClassFromString(obj) respondsToSelector:@selector(lrrPath)], @"未实现lrrPath方法");
        Class module = NSClassFromString(obj);
        NSAssert(SARIsValidString([module lrrPath]), @"lrrPath不能为空");

        NSString *path = [module lrrPath];
        NSMutableDictionary *modules = [self moduleWithPath:path];
        NSAssert(!modules[kSARModuleClass], @"重复定义");

        modules[kSARModuleClass] = obj;
        modules[kSARModulePath] = path;
        
#ifdef SARDebug
        if ([module respondsToSelector:@selector(lrrClassMethods)]) {
            NSArray *classMethods = [module lrrClassMethods];
            [classMethods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSAssert([module respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@",obj])], @"未实现注册方法");
            }];
            modules[kSARModuleClassMethods] = SARSafeArray(classMethods);
        }
#endif
        
    }];
}

-(NSMutableDictionary *)moduleWithPath:(NSString *)path{
    NSArray *paths = [path componentsSeparatedByString:@"/"];
    NSInteger index = 0;
    NSMutableDictionary *subModules = self.annotationModules;
    while (index < paths.count) {
        NSString *path = paths[index];
        if (!subModules[path]) {
            subModules[path] = [[NSMutableDictionary alloc] init];
        }
        subModules = subModules[path];
        index++;
    }
    return subModules;
}

#pragma mark - set get
-(NSMutableDictionary *)annotationModules{
    if (!_annotationModules) {
        _annotationModules = [[NSMutableDictionary alloc] init];
    }
    return _annotationModules;
}

@end


@implementation SARouter (debug)

+(void)lrrCheckClassMethod:(NSString *)method path:(NSString *)path{
#ifdef SARDebug
    NSDictionary *moduleDic = [[SARouter shareInstance] moduleWithPath:path];
    NSAssert(SARIsValidString(moduleDic[kSARModuleClass]), @"未定义该path");
    NSArray *classMethods = moduleDic[kSARModuleClassMethods];
    NSAssert([classMethods containsObject:method], @"lrrClassMethods不支持实现该类方法");
    Class module = NSClassFromString(moduleDic[kSARModuleClass]);
    NSAssert([module respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@",method])], @"未实现该方法");
#endif
}

@end
