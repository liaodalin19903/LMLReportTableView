//
//  LMLReportController.m
//  Cell的折叠
//
//  Created by 优谱德 on 16/7/9.
//  Copyright © 2016年 董诗磊. All rights reserved.
//

#import "LMLReportController.h"
#import "LMLReportHeadView.h"
#import "LMLReportCell.h"
#import "LML_Util.h"
#import "WLAlertViewController/WLAlertViewController.h"

#define LMLSystemAlertControllerShowSingelButtonWithMessageWL(messageStr, buttonStr)   WLAlertViewController *alert=[WLAlertViewController alertWithTitle:@"温馨提示" message:(messageStr) delegate:self cancelButtonTitle:(buttonStr) preferredStyle:WLAlertControllerStyleAlert];[alert show]

#define Placeholder_Str @"请输入您的举报内容"

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
// app color
#define APP_COLOR RGB(30, 170, 60)
#define Back_Color_QQ RGB(232, 232, 232)  // 这个是QQ的back_color
#define color_666666 [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1.0]

//设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

@interface LMLReportController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{

    
    NSInteger selectedSection;
    
    UITextView *mTextView;
    
    NSString *report_content;  // 举报内容
    
}

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSMutableArray *headerArr;

@end

@implementation LMLReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

#pragma mark - init

- (void)initData {

    selectedSection = -1;
    
    report_content = @"";
    
    _headerArr = [NSMutableArray arrayWithCapacity:0];
    _titleArr = @[@"色情低俗", @"广告骚扰", @"诱导分享", @"谣言", @"政治敏感", @"违法（暴力恐怖、违禁品等）", @"侵权", @"售假", @"其他"];
    
    
}

- (void)initUI {

    // tableView上面多出来20个像素，是因为自动布局的缘故，设置一下属性就可以解决问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = Back_Color_QQ;
    
    UIView *header_of_tab = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
    header_of_tab.backgroundColor = Back_Color_QQ;
    UILabel *label_of_reason = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 35)];
    label_of_reason.text = @"请选择举报原因";
    label_of_reason.textColor = color_666666;
    label_of_reason.font = [UIFont systemFontOfSize:15];
    [header_of_tab addSubview:label_of_reason];
    
    self.tableView.tableHeaderView = header_of_tab;
    
    [self.view addSubview:self.tableView];
    
    // nav
    [LML_Util addCustomNavWithTitle:@"举报内容" andRightButtonStr:@"举报" andTarget:self];
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedSection == 8  && section == 8)
    {
        NSLog(@"section----%ld",(long)section);
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_id = @"cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LMLReportCell" owner:self options:nil].firstObject;
    }
    
    LMLReportHeadView *view = _headerArr[selectedSection];
    if (indexPath.row == selectedSection) {
        
        view.checkImage.hidden = NO;
    }else {
        view.checkImage.hidden = YES;
    }
    
    /* 配置cell */
    if (indexPath.section == 8) {
        mTextView = ((LMLReportCell *)cell).textView;
        mTextView.delegate = self;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}



// 这个是header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    LMLReportHeadView *view = [[NSBundle mainBundle] loadNibNamed:@"LMLReportHeadView" owner:self options:nil].firstObject;//[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    view.userInteractionEnabled = YES;
    
    view.tag = section;
    
    view.titleLabel.text = _titleArr[section];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(display1:)]];
    
    if (section == selectedSection) {
        
        view.checkImage.hidden = NO;
    }
    
    if (_headerArr.count < 9) {
        [_headerArr addObject:view];
    }
    
    
    if (section == selectedSection) {
        
        view.titleLabel.textColor = APP_COLOR;
    }else {
        view.titleLabel.textColor = [UIColor blackColor];
    }
    
    return view;
    
}


#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:Placeholder_Str]) {
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = Placeholder_Str;
        textView.textColor = [UIColor grayColor];
    }
}


#pragma mark - scroll view 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > 0) {
        //[mTextView resignFirstResponder];
    }
    
}

#pragma mark - private methods

- (void)display1:(UITapGestureRecognizer *)tap
{
  
    
    NSInteger section = tap.view.tag;
    
    if (selectedSection == section) {
        
        return;
    }else {
        
        selectedSection = section;
    }
    
  
    
    /*if (Display[section]) {
        
        return;
    }*/
    
    NSIndexSet * set = [NSIndexSet indexSetWithIndex:tap.view.tag];
  
 
    for (int i = 0; i < 9; i ++) {
        
        LMLReportHeadView *header = _headerArr[i];
        header.checkImage.hidden = YES;
        
    }
    LMLReportHeadView *header = _headerArr[section];
    header.checkImage.hidden = NO;
    
    
    
    if (section == 8) {
        
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        
        //[self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:8];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        report_content = mTextView.text;
    }else {
        
        LMLReportHeadView *view = _headerArr[section];
        report_content = view.titleLabel.text;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [mTextView resignFirstResponder];
    [self.view resignFirstResponder];
}

#pragma mark - click 

- (void)clickLeft {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRight {

    // 举报
    // 1.先判断
    
    if ([[LML_Util removeSpaceForString:report_content] isEqualToString:@""]) {
        
        LMLSystemAlertControllerShowSingelButtonWithMessageWL(@"请说明举报原因", @"确定");
        return;
    }
    
    
    if (selectedSection == 8) {
        
        if ([mTextView.text isEqualToString:Placeholder_Str] || mTextView.text.length == 0 || [LML_Util removeSpaceForString:mTextView.text].length == 0) {
            
            LMLSystemAlertControllerShowSingelButtonWithMessageWL(@"请输入举报内容", @"确定");
            return;
        }
        if ([LML_Util removeSpaceForString:mTextView.text].length > 100 || [LML_Util removeSpaceForString:mTextView.text].length < 15) {
            
            LMLSystemAlertControllerShowSingelButtonWithMessageWL(@"输入的举报内容在15到100之间", @"确定");
            return;
        }
        
    }
    
    // 2.网络
    
    [self networkForReport];
    
}

#pragma mark - network
// 举报
- (void)networkForReport {

    // 1.这个是网络举报
    
    /* 参数准备 */
    
    // 1.id id是多少
    
    // 2.type 是谁进入的
    
    // 3.content 就是 report_content
    
    // 4.userid
//    NSString *userid = [UserInfoStatic sharedUserInfoStatic].userId;
//    
//    /* 网络请求 */
//    [Mysevers AFPOSTAddressname:@"feedBack/addReport" parmas:@{@"id":self.info[@"id"], @"type":self.info[@"type"], @"content":report_content, @"userid":@([userid intValue])} RequestSuccess:^(id result) {
//        
//        if ([result[@"flag"] boolValue] == YES) {
//            
//            LMLSystemAlertControllerShowSingelButtonWithMessageAndPop(@"举报成功，我们将尽快处理...", @"确定");
//            
//            
//        }else {
//            LMLSystemAlertControllerShowSingelButtonWithMessageWL(result[@"message"], @"确定");
//        }
//        
//    } failBlcok:^{
//        LMLSystemAlertControllerShowSingelButtonWithMessageRequestFial;
//    }];
    
    
    // 2.这个是测试结果
    
    NSLog(@" type = %@; \n id = %@; \n content = %@; \n ", self.info[@"type"], self.info[@"id"], report_content);
    
}

#pragma mark - getter

- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        
    }
    return _tableView;
}


@end
