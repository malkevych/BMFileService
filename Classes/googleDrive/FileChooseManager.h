//
//  FileChooseManager.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 14.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ServiceFilesChooserProtocol.h"
#import "FileServiceProtocol.h"

typedef void(^FileDownloadedrHandler) (NSString * path, NSError * error);

@interface FileChooseManager : UITableViewController

@property (copy, nonatomic) FileDownloadedrHandler downloadFileHandler;
@property (nonatomic, nonatomic) NSURL * localSavePath;

+(instancetype)fileManagerVC;
-(void)setServiceFilesChooser:(id<ServiceFilesChooserProtocol, FileServiceProtocol>)serivceChooser;

@end
