//
//  FileDownUpManager.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "FileDownUpManager.h"


static NSString * const dirCVName = @"CVs";

@implementation FileDownUpManager

+(NSURL *)prepareLocalStorePathForStoreCV {
    NSURL * CVPath = [self CVsDirectory];
    [self cleanAllChachedCVs];
    return CVPath;
}

+(void)cleanAllChachedCVs {
    NSURL * CVPath = [self CVsDirectory];
    NSError * error;
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[CVPath path] error:&error];
    for (NSString * filePath in dirContents) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(NSURL *)CVsDirectory {
    NSURL * documentsPath = [self applicationDocumentsDirectory];
    NSURL * documentsCVPath = [documentsPath URLByAppendingPathComponent:dirCVName isDirectory:YES];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[documentsCVPath path] isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:documentsCVPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsCVPath;
}

+(BOOL)saveData:(NSData *)file toUrl:(NSURL *)url {
    BOOL isSaved = [[NSFileManager defaultManager] createFileAtPath:[url path] contents:file attributes:nil];
    if (!isSaved) {
        NSLog(@"Oops, could copy preloaded data");
    }
    return isSaved;
}

@end
