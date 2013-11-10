//
//  SHUSettingViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHUSettingViewController.h"
#import "SHUCloudDocument.h"
#import "SHUAppDelegate.h"
#import "CXAlertView.h"

@interface SHUSettingViewController ()

@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;
@property (strong, nonatomic) NSMetadataQuery *query;
@property (strong, nonatomic) SHUCloudDocument *myCloudDocument;

@property id WelcomeMenuVC;

@property (strong, nonatomic) NSMutableArray *testArray;

- (void)searchFilesOniCloud;
@property (weak, nonatomic) IBOutlet UILabel *completionDate;
@property (weak, nonatomic) IBOutlet UILabel *countDown;

@end

@implementation SHUSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*      查询iCloud文件变化，并注册通知      */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUbiquitousDocuments:) name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUbiquitousDocuments:) name:NSMetadataQueryDidUpdateNotification object:nil];
    
    [self searchFilesOniCloud];


    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_query enableUpdates];
    [_query startQuery];
    
    /*      更新cell      */
    NSDate *date = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"completionDate"];
    if (date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.completionDate.text = [dateFormatter stringFromDate:date];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [_query disableUpdates];
    [_query stopQuery];
}

- (IBAction)saveSwitch:(id)sender {
    /*      将文件保存到文档中，然后设置文档保存状态]       */
    
    _testArray = [@[@"1",@"2",@"3"] mutableCopy];
    
    if (_iCloudSwitch.on) {
        _myCloudDocument.wordsInNote = _testArray;
        [_myCloudDocument updateChangeCount:UIDocumentChangeDone];
    }
}


- (void)updateUbiquitousDocuments:(NSNotification *)notification
{
    /*      查询结束后通知调用方法，如果文件存在则初始化文档并与View相关，否则创建文件     */
    if (_query.resultCount == 1) {
        NSURL *ubiquityURL = [[_query.results lastObject] valueForAttribute:NSMetadataItemURLKey];
        
        _myCloudDocument = [[SHUCloudDocument alloc] initWithFileURL:ubiquityURL];
        [_myCloudDocument openWithCompletionHandler:^(BOOL success){
            if (success){
                NSLog(@"iCloud目录中数据库存在");
            }
        }];
    }else{
        NSLog(@"iCloud目录中数据库不存在");
        NSURL *documentiCloudPath = [_ubiquitousDocumentsURL URLByAppendingPathComponent:@"wordsInNote.dat"];
        _myCloudDocument = [[SHUCloudDocument alloc] initWithFileURL:documentiCloudPath];
    }
}

- (void)searchFilesOniCloud
{
    /*      获得iCloud文件目录，初始化Query查询对象，设定查询条件与范围     */
    _ubiquitousDocumentsURL = [self ubiquitousDocumentsURL];
    
    if (_ubiquitousDocumentsURL) {
        _query = [[NSMetadataQuery alloc] init];
        _query.predicate = [NSPredicate predicateWithFormat:@" %K like 'wordsInNote.dat'",NSMetadataItemFSNameKey];
        _query.searchScopes = [NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope];
    }
}

- (NSURL *)ubiquitousDocumentsURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *containerURL = [fileManager URLForUbiquityContainerIdentifier:@"QTZNKWLRFR.com.WHG.tango"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Documents"];
    return containerURL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)backToMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

#pragma mark - table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && indexPath.row == 0 ) ||(indexPath.section == 2 && indexPath.row == 0)) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //      处理选择日期
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        
        NSDate *cpDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"completionDate"];  //    上次记录的时间
        if (cpDate) {
            [datePicker setDate:cpDate];
        }
        CXAlertView *pickUpDateAlertView = [[CXAlertView alloc] initWithTitle:nil contentView:datePicker cancelButtonTitle:nil];
        datePicker.frame = CGRectMake(0, 0, 250, 200);
        [pickUpDateAlertView addButtonWithTitle:@"确定" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
            [alertView dismiss];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];

            NSDate *completionDate = [datePicker date];
            [[NSUserDefaults standardUserDefaults] setObject:completionDate forKey:@"completionDate"];
            self.completionDate.text = [dateFormatter stringFromDate:completionDate];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [pickUpDateAlertView show];
    }
    //      处理充值进度
    else if (indexPath.section == 1 && indexPath.row == 2){
        CXAlertView *resetAlertView = [[CXAlertView alloc] initWithTitle:@"确定要重置进度吗？" message:@"这将会清初你所有的学习记录" cancelButtonTitle:nil];
        [resetAlertView addButtonWithTitle:@"点错了" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
            [alertView dismiss];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [resetAlertView addButtonWithTitle:@"确定" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
            [alertView dismiss];
            [self resetStudyProgress];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [resetAlertView show];
    }
}

- (void)resetStudyProgress{
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *reset = "update word_tbl set wrong_times = 0,right_times = 0,is_mastered = 0,studied_today = 0,is_mastered_today = 0,studied_total = 0;";
    sqlite3_stmt *resetStmt;
    if (sqlite3_prepare_v2(wordDatabase, reset, -1, &resetStmt, NULL) == SQLITE_OK) {
        sqlite3_step(resetStmt);
    }else{
        NSLog(@"resetStudyProgress failed");
    }
}

- (IBAction)countDownChanged:(UISlider *)sender {
    float value = sender.value;
    NSInteger countDown = value * 16;
    self.countDown.text = [NSString stringWithFormat:@"%ld秒", (long)countDown];
    [[NSUserDefaults standardUserDefaults] setInteger:countDown forKey:@"countDown"];
}
@end






























