//
//  ViewController.m
//  DownLoad
//
//  Created by MasterChen on 16/11/24.
//  Copyright © 2016年 MasterChen. All rights reserved.
//  初学下载Demo

#import "ViewController.h"
#import <QuickLook/QuickLook.h>

@interface ViewController ()<NSURLSessionDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
/**总数据*/
@property(nonatomic,strong) NSMutableData *data;
/**总长度*/
@property(nonatomic,assign)NSInteger totalLength;

// 浏览
@property (strong, nonatomic) QLPreviewController * qlpreView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   //  判断文件存不存在
    // 文件名
    NSString  *filename = @"zz.pdf";
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if(![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"文件不存在");
    }else{
        NSLog(@"文件存在");
    }
    
    // 下载网址  我这个是假的
    NSURL *url = [NSURL URLWithString:@"https://extapi.fadada.com/api2//getdocs.action?app_id=000699&send_app_id=null&v=2.0&timestamp=20180416164011&transaction_id=13017c5a04d24c99894f701d786fe9c1&msg_digest=QjIwOTlGQjAyMTdFRUY4RTZDMjlENTA1MjZEMkU5NTFCMjI2RjI3Mg=="];
    
    //创建管理类NSURLSessionConfiguration
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    
    //初始化session并制定代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    
    // 开始
    [task resume];
}


#pragma mark ====  下载用到的 代理方法
#pragma mark *下载完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"%@",[NSThread currentThread]);
    //将下载后的数据存入文件(firstObject 无数据返回nil，不会导致程序崩溃)
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //destPath = [destPath stringByAppendingPathComponent:@"my.zip"];
    
    destPath = [destPath stringByAppendingPathComponent:@"zz.pdf"];
    
    NSLog(@"ccc  %@",destPath);
    
    //将下载的二进制文件转成入文件
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDownLoad =  [manager createFileAtPath:destPath contents:self.data attributes:nil];
    
    if (isDownLoad) {
        NSLog(@"OK");
    }else{
        NSLog(@"Sorry");
    }
//    NSLog(@"下载完成");

    self.qlpreView = [[QLPreviewController alloc]init];
    
    self.qlpreView.view.frame = self.view.bounds;
    
    self.qlpreView.delegate= self;
    
    self.qlpreView.dataSource = self;

    [self.navigationController pushViewController:self.qlpreView animated:YES];
}


#pragma mark  ====  接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //允许继续响应
    completionHandler(NSURLSessionResponseAllow);
    //获取文件的总大小
    self.totalLength = response.expectedContentLength;
}


#pragma mark  ===== 接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{

    //将每次接受到的数据拼接起来
    [self.data appendData:data];
    //计算当前下载的长度
    NSInteger nowlength = self.data.length;
    
    //  可以用些 三方动画
//    CGFloat value = nowlength*1.0/self.totalLength;
}



#pragma mark =======  QLPreviewController  代理
#pragma mark ==== 返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark ==== 即将要退出浏览文件时执行此方法
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
}




#pragma mark ===== 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    
    //    获取指定文件 路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [docDir stringByAppendingPathComponent:@"zz.pdf"]];
    
    return storeUrl;
}


//懒加载
-(NSMutableData *)data{
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    return _data;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
