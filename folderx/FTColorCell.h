#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

static NSString *domain = @"com.lizynz.folderx";

@interface UIView (FolderX)
- (id)_viewControllerForAncestor;
@end

@interface NSUserDefaults (FolderX)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface FTColorCell : PSControlTableCell <UIColorPickerViewControllerDelegate, UIPopoverPresentationControllerDelegate>
//@property (nonatomic, retain) UIButton *control;
- (NSDictionary *)dictionaryForColor:(UIColor *)color;
- (void)selectColor;
@end
