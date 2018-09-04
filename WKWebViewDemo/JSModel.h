//
//  JSModel.h
//  WKWebViewDemo
//
//  Created by 杨晓周 on 2018/8/29.
//  Copyright © 2018年 杨晓周. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MFWKWebViewController.h"

@interface JSModel : NSObject <WKScriptMessageHandler>
@property (nonatomic, weak) WKWebView *webView;
@end
