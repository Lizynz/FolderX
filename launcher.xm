#import "FXCollectionViewCell.h"
#import "FXIcon.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreData/CoreData.h>

@interface UIApplication (poop)
- (void)launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
@end

@interface SBActivationSettings : NSObject
- (void)setFlag:(long long)arg1 forActivationSetting:(unsigned)arg2 ;
@end

@interface SBIconListView : UIView
- (void)hideAllIcons;
- (void)showAllIcons;
@end

@interface SBApplication : NSObject
@property (nonatomic,copy) id badgeValue;
- (NSString *)bundleIdentifier;
- (NSString *)displayName;
- (id)initWithApplicationInfo:(id)arg1 ;
- (id)badgeNumberOrStringForIcon:(id)arg1 ;
@end

@interface SBApplicationIcon
- (id)initWithApplication:(SBApplication *)application;
- (SBApplication *)application;
@end

@interface UIWebClip : NSObject
@property (assign) BOOL fullScreen;
@property (nonatomic, retain) NSURL *pageURL;
@property (nonatomic, readonly, retain) UIImage *iconImage;
- (id)bundleIdentifier;
@end

@interface SBIcon : NSObject
@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly) long long badgeValue;
- (bool)isApplicationIcon;
- (bool)isBookmarkIcon;
- (bool)isWidgetIcon;
- (bool)isWidgetStackIcon;
- (id)applicationBundleID;
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBBookmarkIcon : SBLeafIcon
@property (readonly, nonatomic) NSURL *launchURL;
@property (nonatomic, readonly) UIWebClip *webClip;
@end

@interface SBFolder : NSObject
@property(copy, nonatomic) NSString *displayName;
@property (nonatomic, readonly, copy) NSArray *icons;
- (id)allIcons;
@end

@interface SBFolderIcon : SBIcon
@property (nonatomic, readonly) SBFolder *folder;
- (id)nodeIdentifier;
@end

@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, retain) SBFolderIcon *folderIcon;
- (bool)isFolderIcon;
@end

@interface SBIconImageView : UIView
@property (assign,nonatomic) SBIconView * iconView;
- (void)setIconView:(SBIconView *)arg1 ;
- (SBIconView *)iconView;
@end

@interface SBIconListPageControl : UIView
@end

@interface UIImage (UIApplicationIconPrivate)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format;
@end

@interface SBFolderController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, strong) SBFolder *folder;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) SBIconListView *customListView;
@property (nonatomic,copy,readonly) NSArray *iconListViews;
@property (nonatomic, strong) NSMutableArray *iconEntries;
@property (retain, nonatomic) SBIconListPageControl *pageControl;
- (void)deselectAllItems;
- (void)folderIcons;
@end

#define kRWSettingsPath @"/var/jb/var/mobile/Library/Preferences/com.lizynz.folderx.plist"

static const NSBundle *tweakBundle = [NSBundle bundleWithPath:@"/var/jb/Library/PreferenceBundles/FolderX.bundle"];
#define LOCALIZED(str) [tweakBundle localizedStringForKey:str value:@"" table:nil]

#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width

static BOOL ios15 = YES;

%hook SBFolderController
%property (nonatomic, strong) NSArray *icons;
%property (nonatomic, strong) UICollectionView *collectionView;
%property (nonatomic, strong) SBIconListView *customListView;
%property (nonatomic, strong) NSString *cellReuseIdentifier;
%property (nonatomic, strong) NSMutableArray *iconEntries;

- (void)viewDidLoad {
    %orig;
    if ((![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) || [self isKindOfClass:%c(SBRootFolderController)]) {
        return;
    }
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"launcher"] boolValue]) {
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipeUp];
    }
    
    if ([[prefs objectForKey:@"hidefoldername"] boolValue]) {
        UISwipeGestureRecognizer *swipeTwoFinger = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRenameFolder:)];
        swipeTwoFinger.direction = UISwipeGestureRecognizerDirectionUp;
        swipeTwoFinger.numberOfTouchesRequired = 2;
        [self.view addGestureRecognizer:swipeTwoFinger];
    }
    
    if ([[prefs objectForKey:@"hidedots"] boolValue]) {
        self.pageControl.hidden = 1;
    } else {
        return %orig;
    }
}

- (void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hidedots"] boolValue]) {
        self.pageControl.hidden = 1;
    } else {
        return %orig;
    }
}

- (void)setFolder:(SBFolder *)arg1 {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"alphabet"] boolValue]) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *icons = ios15 ? arg1.icons : arg1.allIcons;
        self.icons = [icons sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        self.icons = [arg1.icons copy];
    }
}

%new
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.cellReuseIdentifier = @"FXCells";
        self.customListView = self.iconListViews.firstObject;
        
        if (ios15)
        [self folderIcons];
        
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
        if ([[prefs objectForKey:@"FolderName"] boolValue]) {
            UIViewController *folderViewController = [[UIViewController alloc] init];
            folderViewController.modalPresentationStyle = UIModalPresentationPopover;
            folderViewController.preferredContentSize = CGSizeMake(kScreenWidth, kScreenHeight - 157);
            
            UIView *folderView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth - 37, kScreenHeight - 200)];
            UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, folderView.frame.size.width, 35)];
            [folderView addSubview:naviView];
            
            UIPopoverPresentationController *popoverController = [folderViewController popoverPresentationController];
            popoverController.delegate = self;
            popoverController.sourceView = self.view;
            popoverController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds), 0, 0);
            popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.itemSize = CGSizeMake(75, 75);
            
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(naviView.frame), folderView.frame.size.width, folderView.frame.size.height - CGRectGetMaxY(naviView.frame)) collectionViewLayout:layout];
            
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            self.collectionView.backgroundColor = [UIColor clearColor];
            self.collectionView.delaysContentTouches = NO;
            self.collectionView.scrollEnabled = YES;
            
            SBFolder *folder = [self folder];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.textColor = [UIColor labelColor];
            textField.font = [UIFont systemFontOfSize:40.0];
            textField.text = folder.displayName;
            textField.enabled = NO;
            textField.delegate = self;
            [textField sizeToFit];
            textField.center = CGPointMake(CGRectGetWidth(naviView.bounds) / 2.0, CGRectGetHeight(textField.bounds) / 2.0);
            
            if ([[prefs objectForKey:@"countApp"] boolValue]) {
                [textField setFrame:CGRectMake(textField.frame.origin.x, -40, textField.frame.size.width, textField.frame.size.height)];
                
                UILabel *countLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.customListView.frame.size.width, 90)];
                countLabel1.textAlignment = NSTextAlignmentCenter;
                countLabel1.textColor = [UIColor labelColor];
                countLabel1.font = [UIFont boldSystemFontOfSize:15.0];
                countLabel1.text = [NSString stringWithFormat:LOCALIZED(@"Apps: %lu"), (unsigned long)self.icons.count];
                countLabel1.center = CGPointMake(CGRectGetWidth(naviView.bounds) / 2.0, CGRectGetHeight(countLabel1.bounds) / 2.0);
                [countLabel1 setFrame:CGRectMake(countLabel1.frame.origin.x, -20, countLabel1.frame.size.width, countLabel1.frame.size.height)];
                [naviView addSubview:countLabel1];
            } else {
                [textField setFrame:CGRectMake(textField.frame.origin.x, -30, textField.frame.size.width, textField.frame.size.height)];
            }
            
            [textField setUserInteractionEnabled:YES];
            [naviView addSubview:textField];
            
            [self.collectionView registerClass:[FXCollectionViewCell class] forCellWithReuseIdentifier: self.cellReuseIdentifier];
            [self.customListView addSubview: self.collectionView];
            [folderView addSubview:self.collectionView];
            [self.view addSubview:folderView];
            [folderViewController.view addSubview:folderView];
            
            [self presentViewController:folderViewController animated:YES completion:nil];
        } else {
            UIViewController *folderViewController = [[UIViewController alloc] init];
            folderViewController.modalPresentationStyle = UIModalPresentationPopover;
            folderViewController.preferredContentSize = CGSizeMake(kScreenWidth, kScreenHeight - 157);
            
            UIView *folderView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth - 37, kScreenHeight - 175)];
            
            UIPopoverPresentationController *popoverController = [folderViewController popoverPresentationController];
            popoverController.delegate = self;
            popoverController.sourceView = self.view;
            popoverController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds), 0, 0);
            popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.itemSize = CGSizeMake(75, 75);
            
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, folderView.frame.size.width, folderView.frame.size.height) collectionViewLayout:layout];

            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            self.collectionView.backgroundColor = [UIColor clearColor];
            self.collectionView.delaysContentTouches = NO;
            self.collectionView.scrollEnabled = YES;
            
            [self.collectionView registerClass:[FXCollectionViewCell class] forCellWithReuseIdentifier: self.cellReuseIdentifier];
            [self.customListView addSubview: self.collectionView];
            [folderView addSubview:self.collectionView];
            [self.view addSubview:folderView];
            [folderViewController.view addSubview:folderView];
            
            [self presentViewController:folderViewController animated:YES completion:nil];
        }
    }
}

%new
- (void)handleRenameFolder:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].windows.firstObject.windowScene.interfaceOrientation;

        if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
            return;
        }
        
        SBFolder *folder = [self folder];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Rename folder:") message:folder.displayName preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Apply") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alertController.textFields.firstObject;
            NSString *newFolderName = textField.text;
            folder.displayName = newFolderName;
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:addAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

%new
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    [self.collectionView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    %orig;
    if (![self isMemberOfClass:%c(SBFolderController)] && ![self isMemberOfClass:%c(SBFloatyFolderController)]) {
        return;
    }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIInterfaceOrientation orientation = [[[UIApplication sharedApplication] windows].firstObject windowScene].interfaceOrientation;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape(orientation)) {

        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

%new
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SBActivationSettings *customSettings = [[%c(SBActivationSettings) alloc] init];
    [customSettings setFlag:1 forActivationSetting:2];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:[[self.iconEntries[indexPath.item] application] bundleIdentifier] suspended:NO];
    }];

    SBBookmarkIcon *selectedIcon = self.icons[indexPath.item];
    if ([selectedIcon isBookmarkIcon]) {
        NSString *pageURLString = [NSString stringWithFormat:@"%@", [[selectedIcon webClip] pageURL]];
        if (pageURLString) {
            NSURL *pageURL = [NSURL URLWithString:pageURLString];
            
            UIApplication *application = [UIApplication sharedApplication];
            NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly: @NO};
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [application openURL:pageURL options:options completionHandler:^(BOOL success) {
                if (!success) {}}];
        }
    }
}

%new
- (void)folderIcons {
    self.iconEntries = [[NSMutableArray alloc] init];
    for (SBApplicationIcon *icon in self.icons) {
        FXIcon *newEntry = [[FXIcon alloc] initWithApplication:icon.application];
        [self.iconEntries addObject: newEntry];
    }
}

%new
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

%new
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.icons.count < 1) { // Если количество иконок равно нулю или меньше единицы, закрываем контроллер представления.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return self.icons.count;
}

- (void)deselectAllItems {
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

%new
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    FXIcon *entry = self.iconEntries[indexPath.item];
    
    cell.entry = entry;
    
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"HideLauncherLabel"] boolValue]) {
        //no label
    } else {
        cell.textLabel.text = entry.application.displayName;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        SBBookmarkIcon *selectedIcon = self.icons[indexPath.item];
        if ([selectedIcon isBookmarkIcon]) {
            cell.textLabel.text = selectedIcon.displayName;
        }
    }
    
    UIView *newView = [[UIView alloc] initWithFrame:cell.frame];
    newView.backgroundColor = [UIColor clearColor];
    newView.layer.cornerRadius = 16;
    cell.selectedBackgroundView = newView;
    
    cell.layer.cornerRadius = 16;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        SBApplication *application = entry.application;
        UIImage *cellImage;
        NSMutableArray *bookmarkIcons = [NSMutableArray array];
        
        if (application.bundleIdentifier && ![application.bundleIdentifier isEqualToString:@""]) {
            cellImage = [UIImage _applicationIconImageForBundleIdentifier:application.bundleIdentifier format:10 scale:[UIScreen mainScreen].scale];
        } else {
            cellImage = [UIImage systemImageNamed:@"exclamationmark.circle"]; // no Bundle ID
            
            SBBookmarkIcon *selectedIcon = self.icons[indexPath.item];
            if ([selectedIcon isBookmarkIcon]) {
                UIImage *iconImage = [[selectedIcon webClip] iconImage];
                if (iconImage) {
                    [bookmarkIcons addObject:iconImage];
                } else {
                    UIImage *placeholderImage = [UIImage systemImageNamed:@"exclamationmark.circle"];
                    [bookmarkIcons addObject:placeholderImage];
                }
            } else {
                UIImage *placeholderImage = [UIImage systemImageNamed:@"exclamationmark.circle"];
                [bookmarkIcons addObject:placeholderImage];
            }
        }
        
        if (bookmarkIcons.count > 0) {
            NSUInteger index = indexPath.item % bookmarkIcons.count;
            cellImage = bookmarkIcons[index];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            FXCollectionViewCell *cell = (FXCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.imageView.image = cellImage;
            SBBookmarkIcon *selectedIcon = self.icons[indexPath.item];
            if ([selectedIcon isBookmarkIcon]) {
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 5;
                cell.imageView.clipsToBounds = YES;
            }
            [cell setNeedsLayout];
        });
    });
    
    if (entry.application.badgeValue != nil) {
        if (!cell.badgeView) {
            cell.badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
//            [cell setupBadgeView:@""]; //отображает цифры
            cell.badgeView.layer.cornerRadius = cell.badgeView.frame.size.width / 2;
            cell.badgeView.backgroundColor = [UIColor redColor];
            [collectionView addSubview:cell.badgeView];
        }
        
        cell.badgeTextLabel.text = [entry.application.badgeValue stringValue];
        [cell.badgeTextLabel sizeToFit];
        
        UICollectionViewLayout *layout = collectionView.collectionViewLayout;
        UICollectionViewLayoutAttributes *attributes = [layout layoutAttributesForItemAtIndexPath:indexPath];
        
        CGRect cellRect = attributes.frame;
        CGRect badgeRect = [cell.badgeView frame];
        badgeRect.origin = [collectionView convertPoint:cellRect.origin fromView:collectionView.superview];
        badgeRect.origin.x = CGRectGetMaxX(cellRect) - badgeRect.size.width - 4;
        badgeRect.origin.y = cellRect.origin.y + (cellRect.size.height - badgeRect.size.height) / 6 - badgeRect.size.height / 2;
        [cell.badgeView setFrame:badgeRect];
        cell.badgeView.hidden = NO;
    } else {
        cell.badgeView.hidden = YES;
    }
    
    return cell;
}

- (void)folderControllerWillClose:(id)arg1 { //Fix launcher and close folder
    %orig;
    [self dismissViewControllerAnimated:YES completion:nil];
}

%end

@interface SBIconLabelImageParameters : NSObject
@end

@interface SBMutableIconLabelImageParameters : SBIconLabelImageParameters
@property (nonatomic,retain) UIColor * textColor;
@end

static NSString *bid = @"";

%hook SBIconView
- (id)_labelImageParameters {
    NSDictionary *prefs =
        [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];

    if ([[prefs objectForKey:@"hidefoldertitlehs"] boolValue] &&
        [self.icon isKindOfClass:[%c(SBFolderIcon) class]]) {

        if (@available(iOS 26, *)) {
            SBIconLabelImageParameters *original = %orig;
            SBMutableIconLabelImageParameters *param = [original mutableCopy];

            SBFolderIcon *folderIcon = (SBFolderIcon*)self.icon;
            bid = folderIcon.nodeIdentifier;
            param.textColor = [UIColor clearColor];

            return param;
        } else {
            SBMutableIconLabelImageParameters *param = %orig;
            
            SBFolderIcon *folderIcon = (SBFolderIcon*)self.icon;
            bid = folderIcon.nodeIdentifier;
            param.textColor = [UIColor clearColor];

            return param;
        }
    }

    return %orig;
}

%end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, retain) NSString *type;
@end

static BOOL shouldHideFolderName;

//Hide Folder Name Shortcuts
%hook SBIconView
- (void)setApplicationShortcutItems:(NSArray *)arg1 {
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (SBSApplicationShortcutItem *item in arg1) {
        if ([item.type isEqual: @"com.apple.springboardhome.application-shortcut-item.rename-folder"]) {
            NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
            if ([[prefs objectForKey:@"hidefoldername"] boolValue]) {
                if (!shouldHideFolderName == NO) {
                    [newItems addObject: item];
                }
            } else {
                if (!shouldHideFolderName == YES) {
                    [newItems addObject: item];
                }
            }
            continue;
        }
        [newItems addObject:item];
    }
    %orig(newItems);
}
%end
