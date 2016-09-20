//
//  WLAlertViewController.m
//
//  Created by wanglei on 15/11/11.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "WLAlertViewController.h"

@interface WLAlertViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSMutableArray *otherTitles;
@property (nonatomic, strong) NSMutableArray *privateTextFields;
@property (nonatomic, assign) WLAlertControllerStyle preferredStyle; //alertView or actionSheet

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

@implementation WLAlertViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(WLAlertControllerStyle)preferredStyle;
{
    self = [super init];
    if (self) {
        
        if (title != nil) {
            self.title = title;
        }
        if (message != nil) {
            self.message = message;
        }
        if (delegate != nil) {
            self.delegate = delegate;
        }
        if (cancelTitle != nil) {
            self.cancelTitle = cancelTitle;
        }
        self.preferredStyle = preferredStyle;
        
        self.otherTitles = [NSMutableArray array];
        self.privateTextFields = [NSMutableArray array];
        
        [self creatAlertView];
        
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(WLAlertControllerStyle)preferredStyle{
    return [[WLAlertViewController alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle preferredStyle:preferredStyle];
}

-(NSArray *)textFields{
    if (self.privateTextFields.count) {
        return self.privateTextFields;
    }else{
        return nil;
    }
}

#pragma mark - 创建 alertView
- (void)creatAlertView{
    if (kSystemVersion >= 8.0f) {// iOS8.0之后
        self.alertView = nil;
        self.actionSheet = nil;
        [self creatAlertViewIOS8Later];
    }else{// iOS8.0之前
        self.alertController = nil;
        (self.preferredStyle == 1) ? [self creatAlertViewIOS8Before] : [self creatActionSheetIOS8Before];
    }
}

// iOS8.0之后
-(void)creatAlertViewIOS8Later{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:(int)self.preferredStyle];
    
    if (self.cancelTitle != nil) {//取消按钮
        WLAlertControllerStyle controllerStyle = self.preferredStyle;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ([self.delegate respondsToSelector:@selector(WLAlertView:clickedButtonAtIndex:)]) {
                if (controllerStyle == WLAlertControllerStyleAlert){
                    [self.delegate WLAlertView:self clickedButtonAtIndex:0];
                }else{
                    [self.delegate WLAlertView:self clickedButtonAtIndex:self.otherTitles.count];
                }
            }
            
        }];
        [alertController addAction:cancelAction];
    }
    
    self.alertController = alertController;
}

// iOS8.0之前----创建 alertView
-(void)creatAlertViewIOS8Before{
    self.actionSheet = nil;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:self.cancelTitle otherButtonTitles:nil];
    self.alertView = alertView;
}

// iOS8.0之前----创建 actionSheet
-(void)creatActionSheetIOS8Before{
    self.alertView = nil;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet = actionSheet;
    [self refreshAlertViewButtons];
}

#pragma mark - 添加 Button
//判断OS版本, 添加 Button
- (void)addOtherButtonWithTitle:(NSString *)title style:(WLAlertActionStyle)actionStyle{
    
    if (kSystemVersion >= 8.0f) {
        [self addButtonWithTitle:title style:actionStyle];
    }else{
        [self addButtonBeforeIOS8WithTitle:title style:actionStyle];
    }
    
}

// iOS8.0之后----添加 Button
-(void)addButtonWithTitle:(NSString *)title style:(WLAlertActionStyle)actionStyle{
    if (title != nil) {
        [self.otherTitles addObject:title];
        WLAlertActionStyle style;
        if (actionStyle == 1) {
            style = 2;
        }
        
        WLAlertControllerStyle controllerStyle = self.preferredStyle;
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:(int)style handler:^(UIAlertAction * _Nonnull action) {
            if ([self.delegate respondsToSelector:@selector(WLAlertView:clickedButtonAtIndex:)]) {
                
                if (controllerStyle == WLAlertControllerStyleAlert) {
                    if (self.cancelTitle != nil) {
                        [self.delegate WLAlertView:self clickedButtonAtIndex:[self.otherTitles indexOfObject:title]+1];
                    }else{
                        [self.delegate WLAlertView:self clickedButtonAtIndex:[self.otherTitles indexOfObject:title]];
                    }
                }else{
                    [self.delegate WLAlertView:self clickedButtonAtIndex:[self.otherTitles indexOfObject:title]];
                }
                
            }
        }];
        [self.alertController addAction:otherAction];
    }
}

// iOS8.0之前----添加 Button
-(void)addButtonBeforeIOS8WithTitle:(NSString *)title style:(WLAlertActionStyle)actionStyle{
    if (title != nil) {
        if (self.alertView != nil) {
            [self.alertView addButtonWithTitle:title];
        }
        if (self.actionSheet != nil) {
            
            NSDictionary *dic = @{title: @(actionStyle)};
            [self.otherTitles addObject:dic];
            
            [self refreshAlertViewButtons];//重新对按钮排序
            
        }
    }
}

//重新对按钮排序
- (void)refreshAlertViewButtons{
    self.actionSheet = nil;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet = actionSheet;
    
    //按顺序添加按钮
    for (NSDictionary *dic  in self.otherTitles) {
        NSArray *keys = [dic allKeys];
        for (int i = 0; i<keys.count; i++) {
            NSString *title = keys[i];
            WLAlertActionStyle actionStyle = [[dic objectForKey:title] intValue];
            if (actionStyle == WLAlertActionStyleDestructive) {
                self.actionSheet.destructiveButtonIndex = [self.actionSheet addButtonWithTitle:title];
            }else{
                [self.actionSheet addButtonWithTitle:title];
            }
        }
    }
    
    //将取消按钮放在底部
    if (self.cancelTitle != nil) {
        self.actionSheet.cancelButtonIndex = [self.actionSheet addButtonWithTitle:self.cancelTitle];
    }
}

#pragma mark - 添加 输入框
// 添加 alertView 输入框
- (void)addAlertViewTextFieldWithStyle:(WLAlertViewTextFieldStyle)alertViewTextFieldStyle textFieldPlaceholderAtIndex0:(NSString *)Placehold0 textFieldPlaceholderAtIndex1:(NSString *)Placehold1{
    if (self.alertController != nil && self.alertController.preferredStyle == UIAlertControllerStyleActionSheet) return;
    if (kSystemVersion >= 8.0f) {
        [self addAlertViewTextFieldIOS8LaterWithStyle:alertViewTextFieldStyle textFieldPlaceholderAtIndex0:Placehold0 textFieldPlaceholderAtIndex1:Placehold1];
    }else{
        [self addAlertViewTextFieldBeforeIOS8WithStyle:alertViewTextFieldStyle textFieldPlaceholderAtIndex0:Placehold0 textFieldPlaceholderAtIndex1:Placehold1];
    }
}

// iOS8.0之后----添加 alertView 输入框
- (void)addAlertViewTextFieldIOS8LaterWithStyle:(WLAlertViewTextFieldStyle)alertViewTextFieldStyle textFieldPlaceholderAtIndex0:(NSString *)Placehold0 textFieldPlaceholderAtIndex1:(NSString *)Placehold1{
    if (self.alertController != nil) {
        if (alertViewTextFieldStyle == WLAlertViewTextFieldStyleLoginAndPasswordInput) {//两个输入框:账号/密码
            [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {//账号
                if (Placehold0 != nil) {
                    textField.placeholder = Placehold0;
                }else{
                    textField.placeholder = @"Login";
                }
            }];
            [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {//密码
                textField.secureTextEntry = YES;
                if (Placehold1 != nil) {
                    textField.placeholder = Placehold1;
                }else{
                    textField.placeholder = @"Password";
                }
            }];
        }else if (alertViewTextFieldStyle == WLAlertViewTextFieldStyleSecureTextInput){//一个输入框, 带密码保护
            [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.secureTextEntry = YES;
                if (Placehold0 != nil) {
                    textField.placeholder = Placehold0;
                }
            }];
        }else{//一个输入框, 不带密码保护
            [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                if (Placehold0 != nil) {
                    textField.placeholder = Placehold0;
                }
            }];
        }
        
    }
}

// iOS8.0之前----添加 alertView 输入框
- (void)addAlertViewTextFieldBeforeIOS8WithStyle:(WLAlertViewTextFieldStyle)alertViewTextFieldStyle textFieldPlaceholderAtIndex0:(NSString *)Placehold0 textFieldPlaceholderAtIndex1:(NSString *)Placehold1{
    
    if (self.alertView == nil) return;
    self.alertView.alertViewStyle = (int)alertViewTextFieldStyle;
    
    if (alertViewTextFieldStyle == WLAlertViewTextFieldStyleLoginAndPasswordInput) {//两个输入框
        
        if (Placehold0 != nil) {
            UITextField *textField0 = [self.alertView textFieldAtIndex:0];
            textField0.placeholder = Placehold0;
        }
        if (Placehold1 != nil) {
            UITextField *textField1 = [self.alertView textFieldAtIndex:1];
            textField1.placeholder = Placehold1;
        }
        
    }else{//一个输入框
        UITextField *textField = [self.alertView textFieldAtIndex:0];
        textField.placeholder = Placehold0;
    }
}

#pragma mark - show
- (void)show{
    
    if (kSystemVersion >= 8.0f) {
        [(UIViewController *)self.delegate presentViewController:self.alertController animated:YES completion:nil];
        self.privateTextFields = [NSMutableArray arrayWithArray:self.alertController.textFields];
    }else{
        if (self.alertView != nil) {
            
            switch (self.alertView.alertViewStyle) {
                case UIAlertViewStyleLoginAndPasswordInput:
                    [self.privateTextFields addObject:[self.alertView textFieldAtIndex:0]];
                    [self.privateTextFields addObject:[self.alertView textFieldAtIndex:1]];
                    break;
                case UIAlertViewStyleDefault:
                    self.privateTextFields = nil;
                    break;
                default:
                    [self.privateTextFields addObject:[self.alertView textFieldAtIndex:0]];
                    break;
            }
            
            [self.alertView show];//显示
            
        }
        if (self.actionSheet != nil) {
            
            UIViewController *vc = (UIViewController *)self.delegate;
            if (vc.tabBarController.tabBar == NULL) {//如果vc没有 tabBar, 就从 keyWindow 弹出 actionSheet
                [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            }else{//如果vc有 tabBar, 就从 tabBar 弹出 actionSheet
                [self.actionSheet showFromTabBar:vc.tabBarController.tabBar];
            }
        
        }
        
    }
    
}

#pragma mark - alertView Delegate (Before iOS8.0)
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(WLAlertView:clickedButtonAtIndex:)]) {
        [self.delegate WLAlertView:self clickedButtonAtIndex:buttonIndex];
    }
}

#pragma mark - actionSheet Delegate (Before iOS8.0)
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(WLAlertView:clickedButtonAtIndex:)]) {
        [self.delegate WLAlertView:self clickedButtonAtIndex:buttonIndex];
    }
}

@end
