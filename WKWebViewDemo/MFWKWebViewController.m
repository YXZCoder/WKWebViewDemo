//
//  MFWKWebViewController.m
//  WKWebViewDemo
//
//  Created by 杨晓周 on 2018/8/30.
//  Copyright © 2018年 杨晓周. All rights reserved.
//

#import "MFWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "JSModel.h"

@interface MFWKWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation MFWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self creatWebView];
    [self addObserver];
    [self creatProgressView];
}

-(void)creatWebView{
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    NSString *sendToken = [NSString stringWithFormat:@"localStorage.setItem(\"accessToken\",'%@');",@"74851c23358c"];
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    JSModel *model = [[JSModel alloc] init];
    model.webView = self.webView;
    
    config.userContentController = [WKUserContentController new];
    [config.userContentController addScriptMessageHandler:model name:@"mf"];
    [config.userContentController addUserScript:wkUScript];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    model.webView = self.webView;
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"TestJS" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    [self.view addSubview:self.webView];
    
}

-(void)creatProgressView{
    self.progressView = [[UIProgressView alloc]initWithFrame:self.view.bounds];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.progressView];
}

- (void)addObserver
{
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

#pragma mark - KVO监听函数
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }else if([keyPath isEqualToString:@"loading"]){
        NSLog(@"loading");
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]){
        //estimatedProgress取值范围是0-1;
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
}


#pragma mark = WKNavigationDelegate
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"title:%@",webView.title);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

//alert 警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark WKUIDelegate
- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"mf"];
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
