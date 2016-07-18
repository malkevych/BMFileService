//
//  ServiceFilesChooserProtocol.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemFromFileServiceProtocol.h"

typedef void(^FilesFromDirLoadedHandler) (NSArray <id<ItemFromFileServiceProtocol>>* items, NSError * error);
typedef void(^FileDownloadHandler) (NSString * path, NSError * error);

@protocol ServiceFilesChooserProtocol <NSObject>

@property (nonatomic, strong) NSString * rootDirectory;
@property (nonatomic, strong) NSString * rootDirectoryTitle;

-(void)loadFilesInFolder:(NSString *)directory handler:(FilesFromDirLoadedHandler)handler;
-(void)downloadAndSaveFile:(id<ItemFromFileServiceProtocol>)file localUrl:(NSURL *)url handler:(FileDownloadHandler)handler;
@optional
-(NSArray <NSString *>*)getAllowedExtentions;

@end
