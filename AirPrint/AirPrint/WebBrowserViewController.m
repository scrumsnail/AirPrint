//
//  WebBrowserViewController.m
//  AirPrint
//
//  Created by allthings_LuYD on 2016/11/22.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController ()<UIWebViewDelegate,UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwordBtn;

@end

@implementation WebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.enabled = self.webView.canGoBack;
    self.forwordBtn.enabled = self.webView.canGoForward;
    [self.textField becomeFirstResponder];
}
- (IBAction)back:(id)sender {
    [self.webView goBack];
}
- (IBAction)forword:(id)sender {
    [self.webView goForward];
}
//打印渲染的HTML
- (IBAction)print:(id)sender {
    //为打印做准备，创建一个指向sharedPrintController的引用
    UIPrintInteractionController *printer = [UIPrintInteractionController sharedPrintController];
    printer.delegate = self;

    //配置打印信息
    UIPrintInfo *Pinfo = [UIPrintInfo printInfo];
    Pinfo.outputType = UIPrintInfoOutputGeneral;//可打印文本、图形、图像
    Pinfo.jobName = @"Print for xiaodui";//可选属性，用于在打印中心中标识打印作业
    Pinfo.duplex = UIPrintInfoDuplexLongEdge;//双面打印绕长边翻页，NONE为禁止双面
    Pinfo.orientation = UIPrintInfoOrientationPortrait;//打印纵向还是横向
    //    Pinfo.printerID = @"";//指定默认打印机，也可以使用UIPrintInteractionControllerDelegate来知悉
    printer.printInfo = Pinfo;

    NSURL *requestURL = [[self.webView request] URL];
    NSError *error = nil;
    NSString *contentHTML = [NSString stringWithContentsOfURL:requestURL encoding:NSASCIIStringEncoding error:&error];
    UIMarkupTextPrintFormatter *textFormmatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:contentHTML];
    textFormmatter.startPage = 0;
    textFormmatter.contentInsets = UIEdgeInsetsMake(36, 36, 36, 36);
    textFormmatter.maximumContentWidth = 504;
    printer.printFormatter = textFormmatter;
    [printer presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error) {
            NSLog(@"Error");
        }
    }];
}
- (IBAction)go:(id)sender {
    NSString *urlString = self.textField.text;
    if (![urlString.lowercaseString hasPrefix:@"http://"]) {
        urlString = [@"http://" stringByAppendingString:self.textField.text];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.textField resignFirstResponder];
}
- (IBAction)printPDF:(id)sender {
    //为打印做准备，创建一个指向sharedPrintController的引用
    UIPrintInteractionController *printer = [UIPrintInteractionController sharedPrintController];
    printer.delegate = self;

    //配置打印信息
    UIPrintInfo *Pinfo = [UIPrintInfo printInfo];
    Pinfo.outputType = UIPrintInfoOutputGeneral;//可打印文本、图形、图像
    Pinfo.jobName = @"Print for xiaodui";//可选属性，用于在打印中心中标识打印作业
    Pinfo.duplex = UIPrintInfoDuplexLongEdge;//双面打印绕长边翻页，NONE为禁止双面
    Pinfo.orientation = UIPrintInfoOrientationPortrait;//打印纵向还是横向
    //    Pinfo.printerID = @"";//指定默认打印机，也可以使用UIPrintInteractionControllerDelegate来知悉
    printer.printInfo = Pinfo;

    UIGraphicsBeginImageContext(self.webView.bounds.size);
    [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    printer.printingItem = image;
    [printer presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error) {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.backBtn.enabled = self.webView.canGoBack;
    self.forwordBtn.enabled = self.webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.backBtn.enabled = self.webView.canGoBack;
    self.forwordBtn.enabled = self.webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}
@end
