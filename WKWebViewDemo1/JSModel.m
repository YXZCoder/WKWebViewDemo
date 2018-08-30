//
//  JSModel.m
//  WKWebViewDemo
//
//  Created by 杨晓周 on 2018/8/29.
//  Copyright © 2018年 杨晓周. All rights reserved.
//

#import "JSModel.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface JSModel () 

@end

@implementation JSModel

- (void)jsCallNativeWithParameters:(NSDictionary *)param
{
    NSString *funcName = param[@"function"];
    NSDictionary *params = [param objectForKey:@"parameters"];
    
    SEL sel = NSSelectorFromString(funcName);
    if ([self respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:sel withObject:params];
        });
      );
    }
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    [self jsCallNativeWithParameters:message.body];
}


#pragma mark - 交互方法
- (void)setToken
{
    //当H5想要获取token时,需要先调用我们本地获取token的方法,然后我们在改方法中可以调用H5的localStorage.setItem方法把token存进去,然后H5再从localStorage里面取,这样就会是和app保持同步的了
    NSString *sendToken = [NSString stringWithFormat:@"localStorage.setItem(\"accessToken\",'%@');",@"xiaozhou123"];
    [self.webView evaluateJavaScript:sendToken completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}

- (void)goToProductDetail:(NSDictionary *)dic
{
    NSLog(@"%@",dic);
}

- (void)dealloc{
    
}




@end
