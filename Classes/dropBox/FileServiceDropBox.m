//
//  FileServiceDropBox.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 10.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "FileServiceDropBox.h"
#import "ItemDropServiceFile.h"

@interface FileServiceDropBox()

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, copy) FilesFromDirLoadedHandler dirLoadedHandler;
@property (nonatomic, copy) FileDownloadHandler fileDownloadHandler;

@end

@implementation FileServiceDropBox

+(instancetype)service {
    NSString * serviceName = @"Dropbox Files";
    NSDictionary * credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"py9nnrvsrtd4x43", @"Appkey", @"1xsrvsq1hugjf24", @"Appsecret", nil];
    FileServiceDropBox * service = [[FileServiceDropBox alloc] initWithServiceName:serviceName credentials:credentials];
    
    return service;
}

-(instancetype)initWithServiceName:(NSString *)name credentials:(NSDictionary *)credentials {
    self = [super init];
    if (self) {
        self.keys = credentials;
        self.name = name;
        DBSession *dbSession = [[DBSession alloc]
                                initWithAppKey:credentials[@"Appkey"]
                                appSecret:credentials[@"Appsecret"]
                                root:kDBRootDropbox];
        [DBSession setSharedSession:dbSession];
        self.rootDirectory = @"/";
        self.rootDirectoryTitle = name;
        self.restClient = [[DBRestClient alloc] initWithSession:dbSession];
        self.restClient.delegate = self;
    }
    return self;
}

-(BOOL)isLogined {
    return [[DBSession sharedSession] isLinked];
}

-(void)loginWithVC:(UIViewController *)viewController {
    [[DBSession sharedSession] linkFromController:viewController];
}

-(id)currentSession {
    return [DBSession sharedSession];
}

-(void)logout {
    [[DBSession sharedSession] unlinkAll];
}

-(void)onDropSessionChanged {
    self.loginHandler([self isLogined], nil);
}

#pragma mark - ServiceFilesChooserProtocol

-(void)loadFilesInFolder:(NSString *)directory handler:(FilesFromDirLoadedHandler)handler {
    self.dirLoadedHandler = handler;
    [self.restClient loadMetadata:directory];
}


-(NSArray <NSString *>*)getAllowedExtentions {
    return @[@"pdf",@"doc", @"docx", @""];
}


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSArray <NSString *>* allowedExtentions = [self getAllowedExtentions];
        NSArray <id<ItemFromFileServiceProtocol>>* items = [ItemDropServiceFile getItemDriveServiceFilesFrom:metadata.contents];
        NSMutableArray <id<ItemFromFileServiceProtocol>>* resItems = (NSMutableArray <id<ItemFromFileServiceProtocol>>*)[NSMutableArray array];
        
        for (id<ItemFromFileServiceProtocol> item in items) {
            if([allowedExtentions containsObject:item.extention]) {
                [resItems addObject:item];
            }
        }
        
        self.dirLoadedHandler(resItems, nil);
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    self.dirLoadedHandler(nil, error);
    NSLog(@"Error loading metadata: %@", error);
}


// Download File

-(void)downloadAndSaveFile:(id<ItemFromFileServiceProtocol>)file localUrl:(NSURL *)url handler:(FileDownloadHandler)handler {
    self.fileDownloadHandler = handler;
    NSURL * endURL = [url URLByAppendingPathComponent:file.title isDirectory:NO];
    [self.restClient loadFile:file.serverPath intoPath:[endURL path]];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
    self.fileDownloadHandler(localPath, nil);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
    self.fileDownloadHandler(nil, error);
}

@end
