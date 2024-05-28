//
//  HostNameSelectViewController.m
//  ZDFProduct
//
//  Created by cheng on 2024/3/14.
//

#import "HostNameSelectViewController.h"


@interface HostNameSelectViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation HostNameSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}


- (void)initView{
    
    _bgView.layer.cornerRadius = 20;
    _bgView.layer.masksToBounds = YES;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"host_cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"host_cell"];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *hostName = self.data[indexPath.row];
    
    if (self.block) {
        
        self.block(hostName);
    }
    [self closeButtAc:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (IBAction)closeButtAc:(id)sender {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}





@end
