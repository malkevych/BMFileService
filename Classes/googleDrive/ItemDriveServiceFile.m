//
//  ItemDriveServiceFile.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "ItemDriveServiceFile.h"

static NSString * const kFolderKey = @"application/vnd.google-apps.folder";

@implementation ItemDriveServiceFile

+(NSArray <ItemDriveServiceFile*>*)getItemDriveServiceFilesFrom:(NSArray <GTLDriveFile *>*)files {
    NSMutableArray * resFiles = [NSMutableArray arrayWithCapacity:files.count];
    for (GTLDriveFile * file in files) {
        ItemDriveServiceFile * fileRes = [[ItemDriveServiceFile alloc] initWithGTLDriveFile:file];
        [resFiles addObject:fileRes];
    }
    return resFiles;
}

-(instancetype)initWithGTLDriveFile:(GTLDriveFile *)file {
    self = [super init];
    if (self) {
        self.extention = [file.fileExtension lowercaseString];
        self.identifier = file.identifier;
        self.title = file.name;
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/drive/v3/files/%@?alt=media", file.identifier];
        self.serverPath = url;
        
        NSString *fileExtension = file.fileExtension;
        if ([file.mimeType isEqualToString:kFolderKey]) {
            self.fileType = FSFileTypeFolder;
        } else if ([fileExtension isEqualToString:@"doc"]) {
            self.fileType = FSFileTypeDoc;
        } else if ([fileExtension isEqualToString:@"docx"]) {
            self.fileType = FSFileTypeDocx;
        } else if([fileExtension isEqualToString:@"pdf"]) {
            self.fileType = FSFileTypePdf;
        } else if ([file.mimeType isEqualToString:@"application/vnd.google-apps.document"]) {
            self.fileType = FSFileTypeDoc;
        } else {
            self.fileType = FSFileTypeOther;
        }
    }
    return self;
}


-(BOOL)isFolder {
    return (self.fileType == FSFileTypeFolder);
}

-(BOOL)isTrashed {
    return self.trashed.boolValue;
}

@end
