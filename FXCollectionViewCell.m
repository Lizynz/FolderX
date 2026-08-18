#import "FXCollectionViewCell.h"
#import <objc/runtime.h>

@implementation FXCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, frame.size.width, 20)];
        self.textLabel.font = [UIFont boldSystemFontOfSize:9];
        self.textLabel.textColor = [UIColor labelColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)setupBadgeView:(NSString *)badgeText {
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    badgeView.layer.cornerRadius = badgeView.frame.size.width / 2;
    badgeView.backgroundColor = [UIColor redColor];
    [self addSubview:badgeView];

    UILabel *badgeTextLabel = [[UILabel alloc] init];
    badgeTextLabel.text = badgeText;
    badgeTextLabel.textAlignment = NSTextAlignmentCenter;
    badgeTextLabel.font = [UIFont boldSystemFontOfSize:12];
    [badgeTextLabel sizeToFit];
    badgeTextLabel.frame = CGRectOffset(badgeTextLabel.frame, 6, 2);
    badgeTextLabel.textColor = [UIColor whiteColor];

    [badgeView addSubview:badgeTextLabel];

    self.badgeView = badgeView;
    self.badgeTextLabel = badgeTextLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0, 0, 52, 52);
}

@end
