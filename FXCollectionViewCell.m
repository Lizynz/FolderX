#import "FXCollectionViewCell.h"
#import <objc/runtime.h>
#import <objc/message.h>

@class SBIconView;

@implementation FXCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;

        Class SBIconViewClass = objc_getClass("SBIconView");

        if (SBIconViewClass) {
            self.iconView = [[SBIconViewClass alloc]
                initWithFrame:CGRectMake(0, 0, 60, 82)];

            self.iconView.labelHidden = YES; // Hide label
            self.iconView.allowsLabelArea = YES;

            [self.contentView addSubview:self.iconView];
        }
    }
    return self;
}

- (void)setSBIcon:(SBIcon *)icon {
    self.iconView.icon = icon;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.iconView.frame = CGRectMake(
        (CGRectGetWidth(self.contentView.bounds) - 60) / 2.0,
        -5,
        60,
        82
    );
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.iconView.icon = nil;

    [self.badgeView removeFromSuperview];
    self.badgeView = nil;
    self.badgeTextLabel = nil;
}

- (void)setupBadgeView:(NSString *)badgeText {
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    badgeView.layer.cornerRadius = 10;
    badgeView.backgroundColor = UIColor.redColor;
    
    [self.contentView addSubview:badgeView];

    UILabel *label = [[UILabel alloc] initWithFrame:badgeView.bounds];
    label.text = badgeText;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = UIColor.whiteColor;
    
    [badgeView addSubview:label];

    self.badgeView = badgeView;
    self.badgeTextLabel = label;
}

@end
