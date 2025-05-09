//
//  MainVC.m
//  CASSample
//

#import "MainVC.h"
#import "MainTVCell.h"
#import "FormatsSection.h"
#import "AppCoordinator.h"

@interface MainVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSNumber *> *formats;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select Ad format";
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    self.formats = [FormatsSectionHelper allCases];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MainTVCell registerForTableView:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formats.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTVCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTVCell cellIdentifier] forIndexPath:indexPath];
    FormatsSection format = [self.formats[indexPath.row] integerValue];
    NSString *title = [FormatsSectionHelper titleForFormat:format];
    [cell configureCellWithTitle:title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FormatsSection selectedFormat = [self.formats[indexPath.row] integerValue];
    
    switch (selectedFormat) {
        case FormatsSectionAppOpen:
            [self.coordinator navigateToAppOpenAd];
            break;
        case FormatsSectionBanner:
            [self.coordinator navigateToBannerAd];
            break;
        case FormatsSectionNative:
            [self.coordinator navigateToNativeAd];
            break;
        case FormatsSectionNativeTemplate:
            [self.coordinator navigateToNativeTemplateAd];
            break;
        case FormatsSectionInterstitial:
            [self.coordinator navigateToInterstitialAd];
            break;
        case FormatsSectionRewarded:
            [self.coordinator navigateToRewardedAd];
            break;
    }
}

@end
