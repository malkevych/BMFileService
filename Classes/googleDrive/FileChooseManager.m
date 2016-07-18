//
//  FileChooseManager.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 14.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "FileChooseManager.h"
#import "FileServiceGoogleDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "SVProgressHUD/SVProgressHUD.h"

typedef void(^FileSavingCompletionHandler) (BOOL successStatus);

@interface FileChooseManager () {
    NSInteger level;
}

@property (strong, nonatomic) NSArray <id<ItemFromFileServiceProtocol>>*files;
@property (strong, nonatomic) NSMutableArray *parentIdArray;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) UIBarButtonItem * backButton;
@property (strong, nonatomic) UIBarButtonItem * closeButton;
@property (strong, nonatomic) UIBarButtonItem * logOutButton;
@property (strong, nonatomic) id<ServiceFilesChooserProtocol, FileServiceProtocol> serivceChooser;

@end

static NSString *CellIdentifier = @"SFFileCell";

@implementation FileChooseManager

@synthesize parentIdArray, titleArray;


+(instancetype)fileManagerVC {
    UIStoryboard * filemanagerStoryBoard = [UIStoryboard storyboardWithName:@"FileChooseManager" bundle:[NSBundle mainBundle]];
    FileChooseManager * vc = [filemanagerStoryBoard instantiateViewControllerWithIdentifier:@"FileChooseManager"];
    return vc;
}

-(void)setServiceFilesChooser:(id<ServiceFilesChooserProtocol, FileServiceProtocol>)serivceChooser {
    self.serivceChooser = serivceChooser;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    parentIdArray = @[self.serivceChooser.rootDirectory].mutableCopy;
    titleArray = @[self.serivceChooser.rootDirectoryTitle].mutableCopy;
    [self loadFilesInNeededFolder];
    [self normalizeNavigationBar];
    self.navigationItem.rightBarButtonItem = self.logOutButton;
}

-(void)normalizeNavigationBar {
    NSString *title = [titleArray lastObject];
    self.title = title;
    if (level == 0) {
        self.navigationItem.leftBarButtonItem = self.closeButton;
    } else {
        self.navigationItem.leftBarButtonItem = self.backButton;
    }
}

-(void)increaseLevelWithTitle:(NSString *)title idntf:(NSString *)identifier {
    ++level;
    if (title == nil) {
        [titleArray addObject:@""];
    } else {
        [titleArray addObject:title];
    }
    [parentIdArray addObject:identifier];
    [self normalizeNavigationBar];
}

-(void)decreaseLevel {
    --level;
    [titleArray removeLastObject];
    [parentIdArray removeLastObject];
    [self normalizeNavigationBar];
}

- (void)onTouchBackButton:(id)sender {
    [self decreaseLevel];
    [self loadFilesInNeededFolder];
}

-(void)onTouchCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onTouchLogout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.serivceChooser logout];
    }];
}


#pragma tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id<ItemFromFileServiceProtocol> file = [self.files objectAtIndex:indexPath.row];
    
    cell.textLabel.text = file.title;
    
    if (file.fileType == FSFileTypeFolder) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"files_folder"];
    } else if (file.fileType == FSFileTypeDoc) {
        cell.imageView.image = [UIImage imageNamed:@"files_doc"];
    } else if (file.fileType == FSFileTypeDocx) {
        cell.imageView.image = [UIImage imageNamed:@"files_docx"];
    } else if(file.fileType == FSFileTypePdf) {
        cell.imageView.image = [UIImage imageNamed:@"files_pdf"];
    } else if (file.fileType == FSFileTypeOther) {
        cell.imageView.image = nil;
    }
    return cell;
}

-(void)printFilesInFolderWithService:(GTLServiceDrive *)service
                            folderId:(NSString *)folderId
                             andName:(NSString *)name{
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ItemFromFileServiceProtocol> file = [self.files objectAtIndex:indexPath.row];
    if ([file isTrashed]){
        [self showAlertWithTitle:@"Error" msg:@"File has been deleted"];
    } else if ([file isFolder]) {
        [self increaseLevelWithTitle:file.title idntf:file.identifier];
        [self loadFilesInNeededFolder];
    } else {
        NSLog(@"Need to load file: %@", file);
        NSAssert(self.localSavePath != nil, @"SavePath can`t be nil");
        NSAssert(self.downloadFileHandler != nil, @"DownloadFileHandler can`t be nil");
        
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"Downloading File..."];
        [self.serivceChooser downloadAndSaveFile:file localUrl:self.localSavePath handler:^(NSString *path, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                strongSelf.downloadFileHandler(path, error);
                [SVProgressHUD dismiss];
            }];
        }];
    }
}


-(void)loadFilesInNeededFolder {
    NSString * idntf = [parentIdArray lastObject];
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self.serivceChooser loadFilesInFolder:idntf handler:^(NSArray<id<ItemFromFileServiceProtocol>> *items, NSError *error) {
        if (error) {
            [weakSelf showAlertWithTitle:@"Error" msg:error.localizedDescription];
        }
        weakSelf.files = items;
        [weakSelf.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark Helpers


-(void)showAlertWithTitle:(NSString *)title msg:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchBackButton:)];
    }
    return _backButton;
}

-(UIBarButtonItem *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTouchCancel:)];
    }
    return _closeButton;
}

-(UIBarButtonItem *)logOutButton {
    if (_logOutButton == nil) {
        _logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchLogout:)];
    }
    return _logOutButton;
}



@end