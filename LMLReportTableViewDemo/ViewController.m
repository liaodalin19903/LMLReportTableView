//
//  ViewController.m
//  LMLReportTableViewDemo
//
//  Created by 优谱德 on 16/9/20.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "ViewController.h"
#import "LMLReportController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)report:(UIButton *)sender {
    
    
    LMLReportController *report = [[LMLReportController alloc] initWithNibName:@"LMLReportController" bundle:nil];
    report.info = @{@"type":@"信息采集", @"id":@(23)};  // 类型是：信息采集   id：23
    [self.navigationController pushViewController:report animated:YES];
    
}

@end
