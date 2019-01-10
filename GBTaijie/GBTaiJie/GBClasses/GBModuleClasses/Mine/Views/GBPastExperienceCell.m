//
//  GBPastExperienceCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPastExperienceCell.h"

@interface GBPastExperienceCell () <
UITextFieldDelegate,
UITextViewDelegate
>

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/* 一句话评价 */
//@property (nonatomic, strong) UILabel *oneWordLabel;

/* 开始时间 */
@property (nonatomic, strong) UITextField *timeStartTextField;

/* 结束时间 */
@property (nonatomic, strong) UITextField *timeEndTextField;

/* 至 */
@property (nonatomic, strong) UILabel *label;

/* 评价 */
//@property (nonatomic, strong) UILabel *wordLabel;
/* 评价 */
//@property (nonatomic, strong) UIView *wordBgView;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;

/* 日期上方工具条 */
@property (nonatomic,strong) UIToolbar *textFieldToolbar;
/* 日期DatePicker */
@property (nonatomic,strong) UIDatePicker *dataPicker;

@end

@implementation GBPastExperienceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.companyTextField];
        [self.contentView addSubview:self.positionTextField];
//        [self.contentView addSubview:self.oneWordLabel];
        [self.contentView addSubview:self.timeStartTextField];
        [self.contentView addSubview:self.timeEndTextField];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];
//        [self.contentView addSubview:self.nubLabel];
//        [self.wordBgView addSubview:self.wordLabel];
//        [self.contentView addSubview:self.wordBgView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

//        // FSTextView
//        FSTextView *textView = [FSTextView textView];
//        textView.placeholder =  @"不是所有流浪者都迷失了自我";
//        textView.placeholderFont = Fit_Font(14);
//        textView.canPerformAction = NO;
//        textView.font = Fit_Font(14);
//        // 限制输入最大字符数.
//        textView.maxLength = 140;
//
//        // 弱化引用, 以免造成内存泄露.
//        __weak __typeof (&*_nubLabel) weakNoticeLabel = _nubLabel;
//        weakNoticeLabel.text = @"0/140";
//
//        // 添加输入改变Block回调.
//        [textView addTextDidChangeHandler:^(FSTextView *textView) {
//            if (textView.text.length < textView.maxLength) {
//                weakNoticeLabel.text = [NSString stringWithFormat:@"%zu/140", textView.text.length];
//                weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
//            }else {
//                weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
//                weakNoticeLabel.textColor = [UIColor kBaseColor];
//            }
//        }];
//        [self.contentView addSubview:textView];
//
////        self.wordTextView = textView;
//
//        GBViewBorderRadius(textView, 2, 0.5, [UIColor kSegmentateLineColor]);
//
//        GBViewBorderRadius(self.wordBgView, 2, 0.5, [UIColor kSegmentateLineColor]);
        
        [self p_addMasonry];
    }
    
    return self;
}

- (void)setPastExperienceModel:(GBPastExperienceModel *)pastExperienceModel {
    _pastExperienceModel = pastExperienceModel;
    self.timeStartTextField.text = _pastExperienceModel.startTime;
    self.timeEndTextField.text = _pastExperienceModel.endTime;
    self.companyTextField.text = _pastExperienceModel.companyName;
    self.positionTextField.text = _pastExperienceModel.positionName;
//    if (self.isEdit) {
//        self.wordTextView.text = _pastExperienceModel.evaluateContent;
//        self.wordLabel.hidden = YES;
//        self.wordBgView.hidden = YES;
//    }else {
//        self.wordLabel.text = _pastExperienceModel.evaluateContent;
//        self.wordTextView.hidden = YES;
//    }
    
    self.timeStartTextField.userInteractionEnabled = self.isEdit;
    self.timeEndTextField.userInteractionEnabled = self.isEdit;
    self.companyTextField.userInteractionEnabled = self.isEdit;
    self.positionTextField.userInteractionEnabled = self.isEdit;
//    self.wordTextView.userInteractionEnabled = self.isEdit;
//    self.nubLabel.hidden = !self.isEdit;
}

- (void)cancelAction {
    [_timeStartTextField resignFirstResponder];
    [_timeEndTextField resignFirstResponder];
}

- (void)finishBirthChange {
    NSDate* choosedDate = self.dataPicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init]; //设置日期格式
    formatter.dateFormat = @"yyyy.MM";
    
    NSString *dateStr = [formatter stringFromDate:choosedDate];
    NSString *timeType = nil;
    if ([self.timeStartTextField isFirstResponder]) {
        timeType = @"timeStart";
    }else if ([self.timeEndTextField isFirstResponder]) {
        timeType = @"timeEnd";
    }
    
    if (self.datePickerClickedBlock) {
        self.datePickerClickedBlock(dateStr,timeType);
    }
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.width.equalTo(@60);
        make.height.equalTo(@48);
    }];
    
    // 公司
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.width.equalTo(@60);
        make.height.equalTo(@48);
    }];
    // 职位
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.width.equalTo(@60);
        make.height.equalTo(@48);
    }];
    
    // 输入公司
    [self.companyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.timeLabel.mas_right).offset(GBMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-GBMargin);
        make.height.equalTo(@48);
    }];
    
    // 输入职位
    [self.positionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyTextField.mas_bottom);
        make.left.equalTo(self.timeLabel.mas_right).offset(GBMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-GBMargin);
        make.height.equalTo(@48);
    }];
    
    //    // 一句话评价
    //    [self.oneWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.positionLabel.mas_bottom).offset(GBMargin);
    //        make.left.equalTo(self.contentView).offset(GBMargin);
    //        make.height.equalTo(@30);
    //    }];
    
    //    // 字数
    //    [self.nubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.positionLabel.mas_bottom).offset(GBMargin);
    //        make.right.equalTo(self.contentView).offset(-GBMargin);
    //        make.height.equalTo(@30);
    //    }];
    
    // 开始时间
    [self.timeStartTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.right.equalTo(self.label.mas_left).offset(-8);
        make.height.equalTo(@48);
        //        make.width.equalTo(@80);
    }];
    // 结束时间
    [self.timeEndTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@48);
        //        make.width.equalTo(@80);
    }];
    
    // 至
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.right.equalTo(self.timeEndTextField.mas_left).offset(-5);
        make.height.equalTo(@48);
        make.width.equalTo(@16);
    }];
    
    // 线1
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
    
    // 线2
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.companyLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
    
    // 线3
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.positionLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
    
    //    // 评价
    //    [self.wordTextView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.oneWordLabel.mas_bottom);
    //        make.left.equalTo(self.contentView).offset(GBMargin);
    //        make.right.equalTo(self.contentView).offset(-GBMargin);
    //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    //    }];
    //
    //    // 评价背景
    //    [self.wordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.oneWordLabel.mas_bottom);
    //        make.left.equalTo(self.contentView).offset(GBMargin);
    //        make.right.equalTo(self.contentView).offset(-GBMargin);
    //        make.bottom.equalTo(self.contentView.mas_bottom);
    //    }];
    //    // 评价
    //    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.wordBgView).offset(5);
    //        make.left.equalTo(self.wordBgView).offset(5);
    //        make.right.equalTo(self.wordBgView).offset(-5);
    //        make.bottom.equalTo(self.wordBgView.mas_bottom).offset(-5);
    //    }];
    
}

#pragma mark - # Getters and Setters
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间";
        _timeLabel.textColor = [UIColor kImportantTitleTextColor];
        _timeLabel.font = Fit_Font(16);
    }
    return _timeLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.text = @"公司";
        _companyLabel.textColor = [UIColor kImportantTitleTextColor];
        _companyLabel.font = Fit_Font(16);
    }
    return _companyLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.text = @"职位";
        _positionLabel.textColor = [UIColor kImportantTitleTextColor];
        _positionLabel.font = Fit_Font(16);
        
    }
    return _positionLabel;
}

- (UITextField *)companyTextField {
    if (!_companyTextField) {
        _companyTextField = [[UITextField alloc] init];
        _companyTextField.delegate = self;
        _companyTextField.placeholder = @"请输入公司名称";
        _companyTextField.textAlignment = NSTextAlignmentRight;
    }
    
    return _companyTextField;
}

- (UITextField *)positionTextField {
    if (!_positionTextField) {
        _positionTextField = [[UITextField alloc] init];
        _positionTextField.delegate = self;
        _positionTextField.placeholder = @"请输入职位";
        _positionTextField.textAlignment = NSTextAlignmentRight;
        
    }
    return _positionTextField;
}

//- (UILabel *)oneWordLabel {
//    if (!_oneWordLabel) {
//        _oneWordLabel = [[UILabel alloc] init];
//        _oneWordLabel.text = @"一句话评价";
//    }
//    return _oneWordLabel;
//}

//- (FSTextView *)wordTextView {
//    if (!_wordTextView) {
//        _wordTextView = [[FSTextView alloc] init];
//    }
//
//    return _wordTextView;
//}

//- (UILabel *)wordLabel {
//    if (!_wordLabel) {
//        _wordLabel = [[UILabel alloc] init];
//        _wordLabel.numberOfLines = 0;
//        _wordLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2-GBMargin/2;
//        _wordLabel.font = Fit_Font(14);
//        _wordLabel.textColor = [UIColor kImportantTitleTextColor];
//    }
//    
//    return _wordLabel;
//}

//- (UIView *)wordBgView {
//    if (!_wordBgView) {
//        _wordBgView = [[UIView alloc] init];
//    }
//
//    return _wordBgView;
//}
//
//- (UILabel *)nubLabel {
//    if (!_nubLabel) {
//        _nubLabel = [[UILabel alloc] init];
//        _nubLabel.textColor = [UIColor kPlaceHolderColor];
//        _nubLabel.font = Fit_Font(12);
//    }
//
//    return _nubLabel;
//}

- (UITextField *)timeStartTextField {
    if (!_timeStartTextField) {
        _timeStartTextField = [[UITextField alloc] init];
        _timeStartTextField.delegate = self;
        _timeStartTextField.placeholder = @"请选择";
        _timeStartTextField.textAlignment = NSTextAlignmentRight;
        //设置文本输入框的输入辅助视图为自定义的视图
        _timeStartTextField.inputAccessoryView = self.textFieldToolbar;
        //设置文本输入框的输入视图为自定义的dataPicker;
        _timeStartTextField.inputView = self.dataPicker;
    }
    return _timeStartTextField;
}

- (UITextField *)timeEndTextField {
    if (!_timeEndTextField) {
        _timeEndTextField = [[UITextField alloc] init];
        _timeEndTextField.delegate = self;
        _timeEndTextField.placeholder = @"请选择";
        _timeEndTextField.textAlignment = NSTextAlignmentRight;
        //设置文本输入框的输入辅助视图为自定义的视图
        _timeEndTextField.inputAccessoryView = self.textFieldToolbar;
        //设置文本输入框的输入视图为自定义的dataPicker;
        _timeEndTextField.inputView = self.dataPicker;
    }
    
    return _timeEndTextField;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"至";
        
    }
    return _label;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line2;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line3;
}

- (UIDatePicker *)dataPicker {
    if (!_dataPicker) {
        _dataPicker = [[UIDatePicker alloc]init];
        _dataPicker.backgroundColor = [UIColor whiteColor];
        //设置显示模式，只显示日期
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        //本地化
        _dataPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        NSDate *  timeDate=[NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        
        NSDate *minDate = [fmt dateFromString:@"1965-1-1"];
        //设置日期最大及最小值
        _dataPicker.maximumDate = timeDate;
        _dataPicker.minimumDate = minDate;
    }
    
    return _dataPicker;
}

- (UIView *)textFieldToolbar {
    
    if (!_textFieldToolbar) {
        
        _textFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _textFieldToolbar.barTintColor = [UIColor whiteColor];
        //设置按钮
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)] ;
        [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kAssistInfoTextColor]} forState:UIControlStateNormal];
        
        UIBarButtonItem *fixSpaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishBirthChange)];
        [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kBaseColor]} forState:UIControlStateNormal];
        _textFieldToolbar.items = @[cancelBtn,fixSpaceBtn,doneBtn];
    }
    return _textFieldToolbar;
}

@end
