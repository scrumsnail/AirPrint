//
//  TextEditorViewController.m
//  AirPrint
//
//  Created by allthings_LuYD on 2016/11/22.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "TextEditorViewController.h"

@interface TextEditorViewController ()<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TextEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)hideKeyb:(id)sender {
    [self.textView resignFirstResponder];
}
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

    //设置页面范围
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:self.textView.text];
    textFormatter.startPage = 0;//指定从哪一张开始打印0代表第一张
    textFormatter.contentInsets = UIEdgeInsetsMake(36, 36, 36, 36);//72相当于1英寸，这样设置上下左右的边距都为0.5英寸
    textFormatter.maximumContentWidth = 504;//(72x7.5)相当于打印宽度为7英寸
    printer.printFormatter = textFormatter;

    printer.showsPageRange = YES;

    [printer presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error) {
            NSLog(@"Error");
        }
    }];
}

#pragma mark - UIPrintInteractionControllerDelegate
- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{

    NSLog(@"Print Interaction Controller Will Present");
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{

    NSLog(@"Print Interaction Controller Did Present");
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{

    NSLog(@"Print Interaction Controller Will Dismiss");
}

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{

    NSLog(@"Print Interaction Controller Did Dismiss");
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController{

    NSLog(@"Print Interaction Controller Will Start Job");
}

- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController{
    
    NSLog(@"Print Interaction Controller Did Finish Job");
}

@end
