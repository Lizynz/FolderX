#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SBIcon;
@class SBIconView;
@class SBIconViewActionDelegate;

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, assign) BOOL labelHidden;
@property (nonatomic, assign) BOOL allowsLabelArea;
//@property (nonatomic, assign) BOOL allowsContextMenus;
@property (nonatomic, weak) id overrideActionDelegate;
//@property (nonatomic, readonly) UIContextMenuInteraction *contextMenuInteraction;
- (instancetype)initWithFrame:(CGRect)frame;
- (id)actionDelegate;
- (void)addGesturesAndInteractionsIfNecessary;
@end

@interface FXCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) UILabel *badgeTextLabel;
@property (nonatomic, strong) UITapGestureRecognizer *appLaunchRecognizer;
@property (nonatomic, strong) SBIconView *iconView;
@property (nonatomic, strong) UILabel *textLabel;
- (void)setSBIcon:(SBIcon *)icon;
- (void)setupBadgeView:(NSString *)badgeText;
@end
