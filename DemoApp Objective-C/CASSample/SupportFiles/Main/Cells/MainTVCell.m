//
//  MainTVCell.m
//  CASSample
//

#import "MainTVCell.h"

@interface MainTVCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation MainTVCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (void)registerForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[self cellIdentifier]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.arrowImageView.tintColor = UIColor.grayColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.arrowImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.arrowImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.arrowImageView.widthAnchor constraintEqualToConstant:16],
        [self.arrowImageView.heightAnchor constraintEqualToConstant:16],
        
        [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:44]
    ]];
}

- (void)configureCellWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
