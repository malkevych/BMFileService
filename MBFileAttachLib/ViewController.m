//
//  ViewController.m
//  MBFileAttachLib
//
//  Created by Malkevych Bohdan Ihorovych on 18.04.16.
//  Copyright © 2016 MB. All rights reserved.
//

#import "ViewController.h"
#import "FileServiceProtocol.h"
#import "SIApplicationSheetButton.h"
#import "SIApplicationSheetService.h"
#import "SIApplicationsSheet.h"
#import "FileServiceGoogleDrive.h"
#import "FileChooseManager.h"
#import "FileServiceDropBox.h"
#import "SIPreviewItem.h"
#import "FileServiceNC.h"
#import "SIQLPreviewController.h"
#import "SIRotatedNC.h"
#import "FileDownUpManager.h"


typedef NS_ENUM(NSInteger, SetviceUpload) {
    SetviceUploadDropBox = 0,
    SetviceUploadGoogleDrive,
    SetviceSavedCV
};

@interface ViewController () <SIQLPreviewControllerUploadingDelegate, SIApplicationsSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblAction;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark upload CV

- (IBAction)onTouchUpload:(id)sender {
    SIApplicationSheetButton * cancelButton = [[SIApplicationSheetButton alloc] initWithTitle:@"Cancel" style:SIApplicationSheetButtonTypeDefault];
    
    NSArray <SIApplicationSheetServiceProtocol>* services;
    SIApplicationSheetService * dropBoxService = [[SIApplicationSheetService alloc] initWithTitle:@"Dropbox" imageName:@"drop_box_serv" tag:SetviceUploadDropBox];
    SIApplicationSheetService * driveService = [[SIApplicationSheetService alloc] initWithTitle:@"Google Drive" imageName:@"google_drive_serv" tag:SetviceUploadGoogleDrive];
        services = (NSArray <SIApplicationSheetServiceProtocol>*)@[dropBoxService, driveService];
    
    NSArray <SIApplicationSheetButtonProtocol>* buttons = (NSArray <SIApplicationSheetButtonProtocol>*)@[cancelButton];
    
    [SIApplicationsSheet showWithButtons:buttons services:services delegate:self];
}

-(void)onDropSessionChanged {
    [self uploadFileWithService:[FileServiceDropBox service]];
}

-(void)onTouchedServiceWithTag:(NSNumber *)index {
    if ([index integerValue] == SetviceUploadDropBox) {
        [self uploadFileWithService:[FileServiceDropBox service]];
    } else if([index integerValue] == SetviceUploadGoogleDrive) {
        [self uploadFileWithService:[FileServiceGoogleDrive service]];
    }
}

-(void)uploadFileWithService:(id<FileServiceProtocol, ServiceFilesChooserProtocol>)service {
    if ([service isLogined]) {
        FileChooseManager * fileManager = [FileChooseManager fileManagerVC];
        [fileManager setServiceFilesChooser:service];
        fileManager.localSavePath = [FileDownUpManager prepareLocalStorePathForStoreCV];
        FileServiceNC * NC = [[FileServiceNC alloc] initWithRootViewController:fileManager];
        [self.navigationController presentViewController:NC animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        fileManager.downloadFileHandler = ^(NSString * path, NSError * error) {
            NSLog(@"Saved to Path: %@", path);
            if (!error) {
                [weakSelf previewFileAtPath:path type:TypeShowingSave title:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Can't download file"];
            }
        };
    } else {
        [service loginWithVC:self];
    }
    // Handling logining
    __weak typeof(self) weakSelf = self;
    __weak typeof(service) weakService = service;
    service.loginHandler = ^(BOOL isSuccess, NSError * error) {
        if (isSuccess) {
            [weakSelf uploadFileWithService:weakService];
        } else {
            
        }
    };
}


-(void)previewFileAtPath:(NSString *)path type:(TypeShowing)typeShowing title:(NSString *)titleVC {
    SIPreviewItem * prevItem = [[SIPreviewItem alloc] initWithPath:path title:titleVC];
    SIQLPreviewController * previewVC = [SIQLPreviewController new];
    previewVC.delegateUpload = self;
    previewVC.typeShowing = typeShowing;
    SIRotatedNC * NC = [[SIRotatedNC alloc] initWithRootViewController:previewVC];
    if([SIQLPreviewController canPreviewItem:prevItem]) {
        previewVC.item = prevItem;
        [self.navigationController presentViewController:NC animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Can't open document, please, choose another one"];
    }
}

#pragma mark - SIQLPreviewControllerUploadingDelegate

-(void)onTouchDoneWithUrl:(NSURL *)localeFileUrl {
    NSData * fileData = [NSData dataWithContentsOfURL:localeFileUrl];
    self.lblAction.text = [NSString stringWithFormat:@"You choosed file that loacted: %@", localeFileUrl];
}


-(void)onTouchCloseWithUrl:(NSURL *)localeFileUrl {
    [FileDownUpManager cleanAllChachedCVs];
    self.lblAction.text = @"Canceled choosing, local store cleaned";
}


@end
