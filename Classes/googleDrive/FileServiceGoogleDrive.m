//
//  FileServiceGoogleDrive.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 14.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "FileServiceGoogleDrive.h"
#import "FileChooseManager.h"
#import "FileServiceNC.h"
#import "ItemDriveServiceFile.h"
#import "SIMOAuth2ViewControllerTouch.h"

@interface FileServiceGoogleDrive ()

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic, strong) GTLServiceDrive *driveService;

@end

static NSString * const kFolderKey = @"application/vnd.google-apps.folder";

@implementation FileServiceGoogleDrive


+(instancetype)service {
    NSString * serviceName = @"Google Files";
    NSDictionary * credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"GoogleDrive", @"kKeychainItemName", @"861875394107-t3a3aiqutqcsekf9kp9vbq2aq8pmd26n.apps.googleusercontent.com", @"kClientID", nil];
    
    FileServiceGoogleDrive * service = [[FileServiceGoogleDrive alloc] initWithServiceName:serviceName credentials:credentials];
    return service;
}

-(instancetype)initWithServiceName:(NSString *)name credentials:(NSDictionary *)credentials {
    self = [super init];
    if (self) {
        self.keys = credentials;
        self.name = name;
        self.driveService = [[GTLServiceDrive alloc] init];
        self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:credentials[@"kKeychainItemName"]
                                                                                             clientID:credentials[@"kClientID"]
                                                                                         clientSecret:credentials[@"kClientSecret"]];
        self.rootDirectory = @"root";
        self.rootDirectoryTitle = name;
    }
    return self;
}

-(BOOL)isLogined {
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

-(void)loginWithVC:(UIViewController *)viewController {
    self.viewController = viewController;
    SIMOAuth2ViewControllerTouch *authController = [[SIMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                                clientID:self.keys[@"kClientID"]
                                                            clientSecret:self.keys[@"kClientSecret"]
                                                        keychainItemName:self.keys[@"kKeychainItemName"]
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    authController.title = @"Authorization";
    FileServiceNC * NC = [[FileServiceNC alloc] initWithRootViewController:authController];
    [viewController presentViewController:NC animated:YES completion:Nil];
}

-(id)currentSession {
    return self.driveService;
}

-(void)logout {
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:self.keys[@"kKeychainItemName"]];
}


#pragma mark-
#pragma mark- google implementation methods


-(void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
     finishedWithAuth:(GTMOAuth2Authentication *)authResult
                error:(NSError *)error
{
    [self.viewController dismissViewControllerAnimated:YES completion:Nil];
    if (error != nil) {
        self.driveService.authorizer = nil;
        self.loginHandler(NO, error);
    } else {
        self.driveService.authorizer = authResult;
        self.loginHandler(YES, nil);
    }
}



#pragma mark - ServiceFilesChooserProtocol

-(void)loadFilesInFolder:(NSString *)directory handler:(FilesFromDirLoadedHandler)handler {
    self.driveService.shouldFetchNextPages = YES;
    GTLQueryDrive * query = [GTLQueryDrive queryForFilesList];
    NSString * queryQ = [NSString stringWithFormat: @"trashed = false and '%@' in parents and (mimeType='application/vnd.google-apps.document' or mimeType='application/vnd.google-apps.folder' OR mimeType='application/pdf' OR mimeType='application/msword' OR mimeType='application/vnd.openxmlformats-officedocument.wordprocessingml.document')", directory];
    
    query.q  = queryQ;
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        
        NSArray <ItemDriveServiceFile*>* resFiles = [ItemDriveServiceFile getItemDriveServiceFilesFrom:files.files];
        handler(resFiles, error);
    }];
}


// Download FIle

-(void)downloadAndSaveFile:(id<ItemFromFileServiceProtocol>)file localUrl:(NSURL *)url handler:(FileDownloadHandler)handler {
    NSString *dataPath = [[url path] stringByAppendingPathComponent:file.title];
    GTMSessionFetcher *fetcher =  [self.driveService.fetcherService fetcherWithURLString:file.serverPath];
    fetcher.destinationFileURL = [NSURL fileURLWithPath:dataPath isDirectory:NO];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil) {
            handler(dataPath, nil);
        } else {
            NSLog(@"An error occurred: %@", error);
            handler(nil, error);
        }
    }];
}


@end