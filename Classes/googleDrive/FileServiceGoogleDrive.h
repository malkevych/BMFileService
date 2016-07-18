//
//  FileServiceGoogleDrive.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 14.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "FileServiceProtocol.h"
#import "ServiceFilesChooserProtocol.h"


@interface FileServiceGoogleDrive : NSObject <FileServiceProtocol, ServiceFilesChooserProtocol>

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

-(void)loadFilesInFolder:(NSString *)directory handler:(FilesFromDirLoadedHandler)handler;
-(void)downloadAndSaveFile:(id<ItemFromFileServiceProtocol>)file localUrl:(NSURL *)url handler:(FileDownloadHandler)handler;

@end


