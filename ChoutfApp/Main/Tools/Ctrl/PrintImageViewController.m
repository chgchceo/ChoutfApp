//
//  PrintImageViewController.m
//  ChoutfApp
//
//  Created by cheng on 2024/5/13.
//

#import "PrintImageViewController.h"
#import "header.h"


@interface PrintImageViewController ()<UIPrintInteractionControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *leftButt;
@property (weak, nonatomic) IBOutlet UIButton *rightButt;


@end

@implementation PrintImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片打印";
    _leftButt.layer.cornerRadius = 10;
    _leftButt.layer.masksToBounds = YES;
    _rightButt.layer.cornerRadius = 10;
    _rightButt.layer.masksToBounds = YES;
}

//选择图片
- (IBAction)leftButtAc:(id)sender {
    
    // 1. 创建 UIAlertController 实例
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 2. 添加 UIAlertAction 选项
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"相册"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        
        [self setTZimageView];
    }];
    
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"拍照"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil]; //
    
    // 将选项添加到 UIAlertController
    [alertController addAction:option1];
    [alertController addAction:option2];
    [alertController addAction:cancelAction];
    
    // 3. 显示弹框
    [self presentViewController:alertController animated:YES completion:nil];
}

//打印图片
- (IBAction)rightButtAc:(id)sender {
    
    UIImage *image = _imgView.image;
    if (image == nil) {
        [Utils showMessage:@"请先选择图片"];
        return;
    }
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    NSData *myPDFData = UIImageJPEGRepresentation(image, 1);
    if  (pic && [UIPrintInteractionController canPrintData: myPDFData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nil];
            [pic presentFromBarButtonItem:item animated:YES
                        completionHandler:completionHandler];
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (void)setTZimageView{
    
    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePC.allowTakePicture = YES;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.allowPickingGif = NO;
    imagePC.showSelectedIndex = YES;
    imagePC.allowPickingOriginalPhoto = YES;//原图
    imagePC.minImagesCount = 0;
    imagePC.maxImagesCount = 1;
    imagePC.showSelectBtn = NO;
    imagePC.allowPreview = YES;
    imagePC.autoSelectCurrentWhenDone = YES;
    imagePC.modalPresentationStyle = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self presentViewController:imagePC animated:YES completion:nil];
        
    });
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if(photos.count > 0){
        
        UIImage *img = photos[0];
        _imgView.image = img;
    }
}

//拍照
- (void)takePhoto{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[@"public.image"];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - =======UIImagePickerControllerDelegate=========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //拍摄的照片
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(img){
        
        _imgView.image = img;
    }
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
