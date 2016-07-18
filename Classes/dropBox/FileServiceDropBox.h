//
//  FileServiceDropBox.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 10.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileServiceProtocol.h"
#import "ServiceFilesChooserProtocol.h"
#import "DropboxSDK/DropboxSDK.h"

@interface FileServiceDropBox : NSObject <FileServiceProtocol, ServiceFilesChooserProtocol, DBRestClientDelegate>

// FileServiceProtocol

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDictionary * keys;
@property (nonatomic, copy) LoginHandlerHandler loginHandler;

+(instancetype)service;
-(BOOL)isLogined;
-(void)loginWithVC:(UIViewController *)viewController;
-(id)currentSession;
-(void)logout;

// ServiceFilesChooserProtocol

@property (nonatomic, strong) NSString * rootDirectory;
@property (nonatomic, strong) NSString * rootDirectoryTitle;

-(NSArray <NSString *>*)getAllowedExtentions;
-(void)loadFilesInFolder:(NSString *)directory handler:(FilesFromDirLoadedHandler)handler;
-(void)downloadAndSaveFile:(id<ItemFromFileServiceProtocol>)file localUrl:(NSURL *)url handler:(FileDownloadHandler)handler;

@end
