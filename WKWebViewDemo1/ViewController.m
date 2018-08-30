//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by 杨晓周 on 2018/8/29.
//  Copyright © 2018年 杨晓周. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "JSModel.h"
#import "MFWKWebViewController.h"

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)] ;
    [btn setTitle:@"点击进入" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)clickBtn
{
    MFWKWebViewController *test = [[MFWKWebViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

@end
