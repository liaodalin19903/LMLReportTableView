//
//  XFTAlertViewController.h
//
//  Created by wanglei on 15/11/11.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

typedef NS_ENUM(NSInteger, WLAlertActionStyle) {
    WLAlertActionStyleDefault = 0,
    WLAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, WLAlertControllerStyle) {
    WLAlertControllerStyleActionSheet = 0,
    WLAlertControllerStyleAlert
};

typedef NS_ENUM(NSInteger, WLAlertViewTextFieldStyle) {
    WLAlertViewTextFieldStyleSecureTextInput = 1,
    WLAlertViewTextFieldStylePlainTextInput,
    WLAlertViewTextFieldStyleLoginAndPasswordInput
};

@protocol WLAlertViewControllerDelegate;
@interface WLAlertViewController : NSObject

@property (nonatomic, strong, readonly) NSArray *textFields;
@property (nonatomic, weak) id<WLAlertViewControllerDelegate> delegate;

/**
 *  初始化方法
 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(WLAlertControllerStyle)preferredStyle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(WLAlertControllerStyle)preferredStyle;

/**
 *  添加按钮
 */
- (void)addOtherButtonWithTitle:(NSString *)title style:(WLAlertActionStyle)actionStyle;

/**
 *  添加输入框
 *  若参数alertViewTextFieldStyle 不等于 XFTAlertViewTextFieldStyleLoginAndPasswordInput, 则只有 Placehold0 有效
 */
- (void)addAlertViewTextFieldWithStyle:(WLAlertViewTextFieldStyle)alertViewTextFieldStyle textFieldPlaceholderAtIndex0:(NSString *)Placehold0 textFieldPlaceholderAtIndex1:(NSString *)Placehold1;

/**
 *  显示
 */
- (void)show;

@end

@protocol WLAlertViewControllerDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)WLAlertView:(WLAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


