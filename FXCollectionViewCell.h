#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SBIcon;
@class SBIconView;
@class SBIconViewActionDelegate;
@class SBFolderIcon;

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, assign) BOOL labelHidden;
@property (nonatomic, assign) BOOL allowsLabelArea;
@property (nonatomic, weak) id overrideActionDelegate;
@property (nonatomic, retain) SBFolderIcon *folderIcon;
@property (nonatomic, assign) id delegate;
- (bool)isFolderIcon;
- (instancetype)initWithFrame:(CGRect)frame;
- (id)actionDelegate;
- (void)addGesturesAndInteractionsIfNecessary;
@end

@interface FXCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UITapGestureRecognizer *appLaunchRecognizer;
@property (nonatomic, strong) SBIconView *iconView;
@property (nonatomic, strong) UILabel *textLabel;
- (void)setSBIcon:(SBIcon *)icon;
@end
