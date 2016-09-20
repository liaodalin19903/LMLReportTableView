//
//  LML_Util.h
//  LMLReportTableViewDemo
//
//  Created by 优谱德 on 16/9/20.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

@interface LML_Util : NSObject

+ (void)addCustomNavWithTitle:(NSString *)title andRightButtonStr:(NSString *)buttonStr andTarget:(UIViewController *)controller;

+ (NSString *)removeSpaceForString:(NSString *)originStr;

@end
