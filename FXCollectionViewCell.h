#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FXIcon.h"

@class SBApplication;

@interface FXCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) FXIcon *entry;
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) UILabel *badgeTextLabel;
@property (nonatomic, strong) UITapGestureRecognizer *appLaunchRecognizer;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;
- (void)setupBadgeView:(NSString *)badgeText;
@end
