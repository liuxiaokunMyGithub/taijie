//
//  CommentPad.h
//  TestKeyBoard
//
//  Created by 刘小坤 on 15/1/22.
//  Copyright (c) 2015年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentPad;

@protocol CommentPadDelegate <NSObject>
- (void)commentPadHide:(CommentPad *)commentPad;
- (void)commentPadSubmit:(CommentPad *)commentPad;

@optional

- (void)commentPadShow:(CommentPad *)commentPad;


@end
@interface CommentPad : UIView<UITextViewDelegate>

@property(nonatomic,assign)id<CommentPadDelegate> delegate;
@property(nonatomic)int tTag;
@property(nonatomic)BOOL selected;


@property(nonatomic, assign) CGFloat commentTag;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *btnExit;
@property(nonatomic, strong) UIButton *btnOk;

-(void)showWithTag:(CGFloat)commentTag;
-(void)exitPad:(id)sender;
-(void)submit:(id)sender;

@end
