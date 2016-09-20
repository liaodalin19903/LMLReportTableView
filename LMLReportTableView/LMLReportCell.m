//
//  LMLReportCell.m
//  Cell的折叠
//
//  Created by 优谱德 on 16/7/9.
//  Copyright © 2016年 董诗磊. All rights reserved.
//

#import "LMLReportCell.h"

#define Placeholder_Str @"请输入您的举报内容"

@interface LMLReportCell () <UITextViewDelegate>

@end

@implementation LMLReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initUI {

    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.cornerRadius = 3;
    
    //self.textView.delegate = self;
    
    
}

#pragma mark - textView delegate 

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([self.textView.text isEqualToString:Placeholder_Str]) {
        
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if ([self.textView.text isEqualToString:@""]) {
        
        self.textView.text = Placeholder_Str;
        self.textView.textColor = [UIColor grayColor];
    }
}

@end
