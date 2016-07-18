//
//  SIMOAuth2ViewControllerTouch.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 21.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIMOAuth2ViewControllerTouch.h"

@implementation SIMOAuth2ViewControllerTouch

-(void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [super viewDidLoad];
}

- (void)setUpNavigation {
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
