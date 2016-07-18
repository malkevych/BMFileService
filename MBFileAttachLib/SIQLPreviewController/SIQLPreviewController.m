//
//  SIQLPreviewController.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIQLPreviewController.h"

@interface SIQLPreviewController() <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem * btnDone;
@property (nonatomic, strong) UIBarButtonItem * btnClose;

@end

@implementation SIQLPreviewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.typeShowing == TypeShowingSave) {
        if ([self.navigationItem.rightBarButtonItems count] == 1) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.btnDone, self.navigationItem.rightBarButtonItem, nil];
        }
    }
    self.navigationItem.leftBarButtonItem = self.btnClose;
    self.title = @"CV";
}

-(void)onTouchDone:(UIBarButtonItem *)barItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegateUpload && [self.delegateUpload respondsToSelector:@selector(onTouchDoneWithUrl:)]) {
        [self.delegateUpload performSelector:@selector(onTouchDoneWithUrl:) withObject:self.item.previewItemURL];
    }
}

-(void)onTouchClose:(UIBarButtonItem *)barItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegateUpload && [self.delegateUpload respondsToSelector:@selector(onTouchCloseWithUrl:)]) {
        [self.delegateUpload performSelector:@selector(onTouchCloseWithUrl:) withObject:self.item.previewItemURL];
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.item;
}

-(UIBarButtonItem *)btnDone {
    if(_btnDone == nil) {
        NSString * textBtn =  (self.typeShowing == TypeShowingSave) ? @"Attach":@"Done";
        _btnDone = [[UIBarButtonItem alloc] initWithTitle:textBtn style:UIBarButtonItemStylePlain target:self action:@selector(onTouchDone:)];
    }
    return _btnDone;
}

-(UIBarButtonItem *)btnClose {
    if(_btnClose == nil) {
        _btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTouchClose:)];
    }
    return _btnClose;
}




@end
