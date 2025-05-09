//
//  MainTVCell.h
//  CASSample
//

#import <UIKit/UIKit.h>

@interface MainTVCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title;
+ (NSString *)cellIdentifier;
+ (void)registerForTableView:(UITableView *)tableView;

@end
