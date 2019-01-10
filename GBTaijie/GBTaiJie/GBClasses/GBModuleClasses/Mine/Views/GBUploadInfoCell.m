//
//  GBUploadInfoCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBUploadInfoCell.h"
#import "XKSelPhotos.h"

@interface GBUploadInfoCell ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, assign) BOOL isShowButton;

@end

@implementation GBUploadInfoCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                      section:(NSInteger )section
                    imageUrls:(NSArray *)imageUrls  {
    self.section = section;
    self.imageUrls = [NSMutableArray arrayWithArray:imageUrls];
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.iconImageView addGestureRecognizer:tap];
//    self.iconImageView.userInteractionEnabled = self.isShowButton;
    
    self.iconImageView.userInteractionEnabled = self.imageUrls.count > 0 ? NO : YES;
    self.deleteButton.hidden = self.imageUrls.count > 0 ? NO : YES;
    self.resetUpdateImageButton.hidden = self.imageUrls.count > 0 ? NO : YES;

//    self.resetUpdateImageButton.hidden = !self.isShowButton;
    
    [self.iconImageView sd_setImageWithURL:GBImageURL((ValidArray(self.imageUrls) ? self.imageUrls[0] :@"")) placeholderImage:GBImageNamed(@"icon_update_Info")];
}

/** MARK: 重传 */
- (void)resetUpdateImageButtonAction{
    [self changeProfileImage];
}

/** MARK: 删除 */
- (void)deleteButtonAction {
    [self.imageUrls removeAllObjects];
    if (self.updateInfoImages) {
        self.updateInfoImages(self.imageUrls,self.section);
    }
    
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap {
    [self changeProfileImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.contentView)setOffset:GBMargin];
        make.top.mas_equalTo(self.contentView).offset(5);
        make.height.mas_equalTo(88);
        make.width.mas_equalTo(66);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.iconImageView.mas_right)setOffset:18];
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.top.mas_equalTo(self.contentView).offset(5);
//        make.height.mas_equalTo(60);
    }];
    
    [self.resetUpdateImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.iconImageView.mas_right)setOffset:18];
        make.bottom.mas_equalTo(self.iconImageView);
        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(60);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
   [make.left.mas_equalTo(self.resetUpdateImageButton.mas_right)setOffset:GBMargin];
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.iconImageView);
    }];
}

- (void)changeProfileImage {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//        //拍摄
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
//        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
//        picker.sourceType = sourceType;
//        [GBRootViewController presentViewController:picker animated:YES completion:nil];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//        //从相册选择
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
//        [GBRootViewController presentViewController:picker animated:YES completion:nil];
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//
//    [GBRootViewController presentViewController:alert animated:YES completion:nil];
//
    [[GBAppHelper currentViewController] ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"上传图片"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            XKSelPhotos *imageManager = [XKSelPhotos selPhotos];
            [imageManager pushImagePickerControllerWithImagesCount:1 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
                [[GBAppHelper currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    [self updateImage:[photos lastObject]];
                }];
            }];
        }
    }];
}

- (void)updateImage:(UIImage *)image {
    // 判断图片是不是png格式的文件
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if (UIImagePNGRepresentation(image)) {
        // 返回为png图像。
    }else if (imageData){
        // 返回为JPEG图像
    }else{
        [UIView showHubWithTip:@"请上传 jpeg或是png格式"];
        return;
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_IMAGE_GetQiuNiuUpToken httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"认证七牛云%@",responseData);
        if([responseData[@"result"] integerValue] == 1)
        {
            NSString *token = responseData[@"data"][@"upToken"];
            // 七牛云
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNFixedZone zone1];
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:imageData key:nil token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"认证七牛云key%@",resp);
                // 图片
                self.imageUrls = [NSMutableArray arrayWithObject:resp[@"key"]];
                
                if (self.updateInfoImages) {
                    self.updateInfoImages(self.imageUrls,self.section);
                }
            } option:nil];
            
        }else {
        }
        
    }fail:^(NSError *error) {
        NSLog(@"认证资料error%@",error);
    }];
}

#pragma mark - Getter/Setter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_Font(14);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor kAssistInfoTextColor];
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UIButton *)resetUpdateImageButton {
    if (!_resetUpdateImageButton) {
        _resetUpdateImageButton = [[UIButton alloc] init];
        [_resetUpdateImageButton setTitle:@"重新上传" forState:UIControlStateNormal];
        [_resetUpdateImageButton addTarget:self action:@selector(resetUpdateImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _resetUpdateImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_resetUpdateImageButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _resetUpdateImageButton.titleLabel.font = Fit_Font(14);
        [self.contentView addSubview:_resetUpdateImageButton];
    }
    
    return _resetUpdateImageButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.titleLabel.font = Fit_Font(14);
        [self.contentView addSubview:_deleteButton];
    }
    
    return _deleteButton;
}

@end
