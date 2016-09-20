//
//  LML_Util.m
//  LMLReportTableViewDemo
//
//  Created by 优谱德 on 16/9/20.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "LML_Util.h"
#import "UIViewExt.h"

//设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

// 缩进
#define nav_back_edgeInsets UIEdgeInsetsMake(0, -15,0, 15)
#define nav_rightBtnStr_edgeInsets UIEdgeInsetsMake(0, 4,0, -4)

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

// app color
#define APP_COLOR RGB(30, 170, 60)

@implementation LML_Util

+ (void)addCustomNavWithTitle:(NSString *)title andRightButtonStr:(NSString *)buttonStr andTarget:(UIViewController *)controller {
    
    UIView * _narBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    [_narBarView setBackgroundColor:[UIColor whiteColor]];
    
    //  返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 64, 44)];
    [backButton setImage:[UIImage imageNamed:@"nyBack_image"] forState:UIControlStateNormal];
    [backButton addTarget:controller action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮的图片的缩进（之前太靠右啦）
    backButton.imageEdgeInsets = nav_back_edgeInsets;  // 左右要相反
    
    // 标题
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    [_narBarView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(_narBarView.center.x
                                    , _narBarView.center.y + 10);
    
    titleLabel.textColor = RGB(0, 161, 15);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text =title;
    
    // 右边按钮
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(kScreen_Width - 64, 20, 64, 44)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:APP_COLOR forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton setTitle:buttonStr forState:UIControlStateNormal];
    [rightButton addTarget:controller action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮的图片的缩进（之前太靠右啦）
    rightButton.titleEdgeInsets = nav_rightBtnStr_edgeInsets;  // 左右要相反
    
    //横线
    UIView* line = [UIView new];
    [_narBarView addSubview:line];
    line.width = kScreen_Width;
    line.height = 1;
    line.top = _narBarView.height - 1;
    line.backgroundColor = RGB(193, 194, 194);
    
    [_narBarView addSubview:backButton];
    [_narBarView addSubview:titleLabel];
    [_narBarView addSubview:rightButton];
    
    
    [controller.view addSubview:_narBarView];
    
}

+ (NSString *)removeSpaceForString:(NSString *)originStr {
    
    if ([originStr isEqualToString:@""]) {
        
        return originStr;
    }
    
    return [originStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
