//
//  PrinterViewController.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/28.
//

#import "PrinterViewController.h"
#import "PrinterH5ViewController.h"
#import "PrintImageViewController.h"
#import "PrintTextViewController.h"
#import "PrintPDFViewController.h"


@interface PrinterViewController ()<UITableViewDelegate,UITableViewDataSource,UIPrintInteractionControllerDelegate>{
    
    UITableView *_tableView;
    NSArray *_data;
    
}

@end

@implementation PrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"打印机";
    _data = @[@"图片打印",@"pdf文件打印",@"文本打印"];//,@"网页打印"
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.textLabel.text = _data[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        
        PrintImageViewController *printCtrl = [[PrintImageViewController alloc] init];
        [self.navigationController pushViewController:printCtrl animated:YES];
    }else if(indexPath.row == 1){
        
        PrintPDFViewController *printCtrl = [[PrintPDFViewController alloc] init];
        [self.navigationController pushViewController:printCtrl animated:YES];

    }else if(indexPath.row == 2){
        
        PrintTextViewController *printCtrl = [[PrintTextViewController alloc] init];
        [self.navigationController pushViewController:printCtrl animated:YES];

    }else if(indexPath.row == 3){
        
        PrinterH5ViewController *h5Ctrl = [[PrinterH5ViewController alloc] init];
        [self.navigationController pushViewController:h5Ctrl animated:YES];
    }
}

- (void)printPdf{
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    UIImage *image = [UIImage imageNamed:@"icon_back"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"pdf"];
    
    NSData *myPDFData = [[NSData alloc] initWithContentsOfFile:path];
    if  (pic && [UIPrintInteractionController canPrintData: myPDFData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
//        pic.showsPageRange = YES;
        pic.printingItem = myPDFData;
//        printInfo.orientation = UIPrintInfoOrientationPortrait;//打印纵向还是横向
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
//            self.content = nil;
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
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

- (void)printText{
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    UIImage *image = [UIImage imageNamed:@"icon_back"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"pdf"];
    
    NSData *myPDFData = [[NSData alloc] initWithContentsOfFile:path];
    if  (pic && [UIPrintInteractionController canPrintData: myPDFData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jobName";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                initWithMarkupText:@"会谈时，拉马福萨总统讲起郑和下西洋。在“云帆高张、昼夜星驰”的古丝绸之路上，中非互通有无、相知相交。跨越千年之久，伴随中华民族复兴征程，唤醒沉睡的古老丝路，历史掀开了新一页。“一带一路”倡议发出后，南非成为第一个加入的非洲国家。此次签署的《中南关于同意深化“一带一路”合作的意向书》，描绘了更壮阔的未来图景"];
            htmlFormatter.startPage = 0;
        htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
            pic.printFormatter = htmlFormatter;
        
//        pic.showsPageRange = YES;
//        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
//            self.content = nil;
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
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

//
- (void)printImg{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
@end
