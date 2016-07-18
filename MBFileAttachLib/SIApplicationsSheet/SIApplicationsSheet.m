//
//  SIApplicationsSheet.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIApplicationsSheet.h"
#import "SIApplicationSheetButtonCell.h"
#import "SIApplicationSheetItemCell.h"
#import <Masonry/Masonry.h>

@interface SIApplicationsSheet () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// Container
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerBottom;

// ColectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// TableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrTableViewHeight;

@end

static NSInteger const kTableCellHeight = 40;
static NSString * const kTableCellIdntf = @"SIApplicationSheetButtonCell";
static NSString * const kCollectionCellIdntf = @"SIApplicationSheetItemCell";

@implementation SIApplicationsSheet


-(instancetype)init {
    return [SIApplicationsSheet loadFromNib];
}

+(SIApplicationsSheet *)loadFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

#pragma mark UI

+(CGRect)getFrameForSheet {
    return [UIScreen mainScreen].bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self registerClasses];
}

-(void)dealloc {
    
}


-(void)registerClasses {
    // TableView
    [self.tableView registerClass:[SIApplicationSheetButtonCell class] forCellReuseIdentifier:kTableCellIdntf];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellIdntf bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTableCellIdntf];
    // ColectionView
    [self.collectionView registerClass:[SIApplicationSheetItemCell class] forCellWithReuseIdentifier:kCollectionCellIdntf];
    [self.collectionView registerNib:[UINib nibWithNibName:kCollectionCellIdntf bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kCollectionCellIdntf];
}

#pragma mark - Displaying

+(void)showWithButtons:(NSArray <SIApplicationSheetButtonProtocol>*)buttons services:(NSArray <SIApplicationSheetServiceProtocol>*)services delegate:(id<SIApplicationsSheetDelegate>)delegate {
    SIApplicationsSheet * sheet = [SIApplicationsSheet loadFromNib];
    sheet.buttons = buttons;
    sheet.services = services;
    sheet.delegate = delegate;
    [sheet display];
}

-(void)show {
    [self display];
}

-(void)display {
    NSAssert(self.buttons != nil, @"buttons is required");
    NSAssert(self.services != nil, @"services is required");
    
    if(!self.superview) {
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        UIScreen *mainScreen = UIScreen.mainScreen;
        
        for (UIWindow *window in frontToBackWindows)
            if (window.screen == mainScreen && window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                [self addConstraintsToSuperView:window];
                break;
            }
    } else {
        [self.superview bringSubviewToFront:self];
    }
    [self animateDismissing:NO];
}

-(void)animateDismissing:(BOOL)isDissmissing {
    CGFloat startAlpha = (isDissmissing)?0.5:0;
    self.constraintContainerBottom.constant = (isDissmissing)?0:self.viewContainer.bounds.size.height;
    [self layoutIfNeeded];
    self.constraintContainerBottom.constant = (!isDissmissing)?0:self.viewContainer.bounds.size.height;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:startAlpha];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5-startAlpha];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (isDissmissing) {
            [self removeFromSuperview];
        }
    }];
}

-(void)addConstraintsToSuperView:(UIView *)superView {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.bottom.equalTo(superView.mas_bottom);
        make.leading.equalTo(superView.mas_leading);
        make.trailing.equalTo(superView.mas_trailing);
    }];
}

- (IBAction)onTapOutside:(id)sender {
    [self animateDismissing:YES];
}






#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.constrTableViewHeight.constant = [self.buttons count] * kTableCellHeight;
    [self setNeedsUpdateConstraints];
    return [self.buttons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIApplicationSheetButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdntf];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SIApplicationSheetButtonCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SIApplicationSheetButtonProtocol> button = self.buttons[indexPath.row];
    [cell fillWithButton:button];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self animateDismissing:YES];
    [self onTouchedButtonIndex:@(indexPath.row)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.services count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SIApplicationSheetItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdntf forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateDismissing:YES];
    id<SIApplicationSheetServiceProtocol> service = self.services[indexPath.row];
    [self onTouchedServiceWithTag:@(service.tag)];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SIApplicationSheetItemCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SIApplicationSheetServiceProtocol> service = self.services[indexPath.row];
    [cell fillWithService:service];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = collectionView.frame.size.height;
    return CGSizeMake(side * 0.85, side);
}







#pragma mark - Delegates

-(void)onTouchedButtonIndex:(NSNumber *)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchedButtonIndex:)]) {
        [self.delegate performSelector:@selector(onTouchedButtonIndex:) withObject:index];
    }
}

-(void)onTouchedServiceWithTag:(NSNumber *)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchedServiceWithTag:)]) {
        [self.delegate performSelector:@selector(onTouchedServiceWithTag:) withObject:index];
    }
}



@end
