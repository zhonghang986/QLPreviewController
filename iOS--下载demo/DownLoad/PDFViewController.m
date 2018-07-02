//
//  PDFViewController.m
//  DownLoad
//
//  Created by 吕超 on 17/2/14.
//  Copyright © 2017年 MasterChen. All rights reserved.
//

#import "PDFViewController.h"
#import <QuickLook/QuickLook.h>

@interface PDFViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (strong, nonatomic) QLPreviewController * qlpreView;

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.qlpreView = [[QLPreviewController alloc]init];

    self.qlpreView.view.frame = self.view.bounds;
    
    self.qlpreView.delegate = self;

    self.qlpreView.dataSource = self;
    
    [self.view addSubview:self.qlpreView.view];
    
    // Do any additional setup after loading the view.
}


#pragma mark - 返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark - 即将要退出浏览文件时执行此方法
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
}


#pragma mark - 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    
    NSString *dataPdf = [NSString stringWithFormat:@"zz.pdf"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:dataPdf ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    return url;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
