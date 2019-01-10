//
//  GBDecryptContentEditViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/88.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPositionServiceModel.h"

@interface GBDecryptContentEditViewController : GBBaseViewController

@property (nonatomic, strong) GBPositionServiceModel *decryptModel;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UITextView *topTextView;
@property (weak, nonatomic) IBOutlet UILabel *topCountL;

@property (weak, nonatomic) IBOutlet UITextView *bottomTextView;
@property (weak, nonatomic) IBOutlet UILabel *bottomCountL;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, copy) NSString *incumbentDecryptId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *titleStr;

@property(nonatomic,strong) void(^contentSaveBlock)(NSString *titleStr,NSString *contentStr);

@end
