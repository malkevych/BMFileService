//
//  ItemDropServiceFile.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "ItemDropServiceFile.h"



@implementation ItemDropServiceFile

+(NSArray <ItemDriveServiceFile*>*)getItemDriveServiceFilesFrom:(NSArray <DBMetadata *>*)files {
    NSMutableArray * resFiles = [NSMutableArray arrayWithCapacity:files.count];
    for (DBMetadata * file in files) {
        ItemDropServiceFile * fileRes = [[ItemDropServiceFile alloc] initWithDBMetadata:file];
        [resFiles addObject:fileRes];
    }
    return resFiles;
}



-(instancetype)initWithDBMetadata:(DBMetadata *)file {
    self = [super init];
    if (self) {
        self.extention = [[file.path pathExtension] lowercaseString];
        self.identifier = file.hash;
        self.title = file.filename;
        self.identifier = file.path;
        self.serverPath = file.path;
        
        if ([file isDirectory]) {
            self.fileType = FSFileTypeFolder;
        } else if ([self.extention isEqualToString:@"doc"]) {
            self.fileType = FSFileTypeDoc;
        } else if ([self.extention isEqualToString:@"docx"]) {
            self.fileType = FSFileTypeDocx;
        } else if([self.extention isEqualToString:@"pdf"]) {
            self.fileType = FSFileTypePdf;
        } else {
            self.fileType = FSFileTypeOther;
        }
    }
    return self;
}

-(BOOL)isFolder {
    return self.fileType == FSFileTypeFolder;
}

-(BOOL)isTrashed {
    return self.isDeleted;
}

@end
