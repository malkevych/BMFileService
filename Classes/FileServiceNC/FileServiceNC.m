//
//  FileServiceNC.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "FileServiceNC.h"

@interface FileServiceNC ()

@end

@implementation FileServiceNC

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
