#import "Headers.h"

#define HideFolderLabel(x) [x.location isEqualToString:@"SBIconLocationFolder"]

UIImageView* _folderIcon;
_UIBackdropView *blurView;

int NameColor = 1;
int TextColor = 1;
int IconColor = 1;
int FolderColor = 1;

static NSString *domain = @"com.lizynz.folderx";

%hook SBFolderTitleTextField
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        NameColor = [prefs objectForKey:@"NC"] ? [[prefs objectForKey:@"NC"] intValue] : NameColor;
    }
    
    if (NameColor == 1) {
        return %orig;
    }

    if (NameColor == 2) { //Color
        NSDictionary *nameColorDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameColorDict" inDomain:domain];
        
        [self setTextColor:[UIColor colorWithRed:[nameColorDict[@"red"] floatValue] green:[nameColorDict[@"green"] floatValue] blue:[nameColorDict[@"blue"] floatValue] alpha:[nameColorDict[@"alpha"] floatValue]]];
    }
    return %orig;
}

- (id)initWithFrame:(CGRect)arg1 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    
    if ([[prefs objectForKey:@"bfh"] boolValue]) { // Hide Background
        SBFolderTitleTextField *view = %orig;
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[_UIBackdropView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
        blurView.backgroundColor = [UIColor clearColor];
        blurView.alpha = 0.0;
        
        blurView.layer.masksToBounds = YES;
        
        if (@available(iOS 26, *)) {
            SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
            blurView.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
        } else {
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        }
        
        [view addSubview:blurView];
        
        return (SBFolderTitleTextField*)view;
    }
    
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    
    if (FolderColor == 3) { //Milk
        SBFolderTitleTextField *view = %orig;
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[_UIBackdropView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
        blurView.backgroundColor = [UIColor systemBackgroundColor];
        blurView.alpha = 0.2;
        
        blurView.layer.masksToBounds = YES;
        
        if (@available(iOS 26, *)) {
            SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
            blurView.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
        } else {
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        }
        
        [view addSubview:blurView];
        
        BOOL isInDarkMode = ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
        if (isInDarkMode) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[_UIBackdropView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            blurView.backgroundColor = [UIColor systemBackgroundColor];
            blurView.alpha = 0.2;
            
            blurView.layer.masksToBounds = YES;
            
            if (@available(iOS 26, *)) {
                SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
                blurView.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
            } else {
                blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
            }
            
            [view addSubview:blurView];
        }
        return (SBFolderTitleTextField*)view;
    }
    return %orig;
}
%end

%hook SBIconView
- (id)_legibilitySettingsWithParameters:(id)arg1 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        TextColor = [prefs objectForKey:@"TC"] ? [[prefs objectForKey:@"TC"] intValue] : TextColor;
    }
    
    if (TextColor == 1) {
        return %orig;
    }

    if (TextColor == 2) { //Color
        id view = %orig;
        
        NSDictionary *textColorDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"textColorDict" inDomain:domain];
        
        if (HideFolderLabel(self)) {
            view = [self _legibilitySettingsWithPrimaryColor:[UIColor colorWithRed:[textColorDict[@"red"] floatValue] green:[textColorDict[@"green"] floatValue] blue:[textColorDict[@"blue"] floatValue] alpha:[textColorDict[@"alpha"] floatValue]]];
        }
        return view;
    }
    return %orig;
}

%end

%hook SBFolderIconImageView
- (void)setBackgroundView:(UIView *)arg1 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        IconColor = [prefs objectForKey:@"IC"] ? [[prefs objectForKey:@"IC"] intValue] : IconColor;
    }
    if (IconColor == 1) {
        return %orig;
    }

    if (IconColor == 2) {
        NSDictionary *ficonColorDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"ficonColorDict" inDomain:domain];
        
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius = 13.5;
        
        [self.backgroundView setBackgroundColor:[UIColor colorWithRed:[ficonColorDict[@"red"] floatValue] green:[ficonColorDict[@"green"] floatValue] blue:[ficonColorDict[@"blue"] floatValue] alpha:[ficonColorDict[@"alpha"] floatValue]]];
    }
}

%end

%hook SBHLibraryAdditionalItemsIndicatorIconImageView
- (void)layoutSubviews {
    %orig;
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        IconColor = [prefs objectForKey:@"IC"] ? [[prefs objectForKey:@"IC"] intValue] : IconColor;
    }
    
    if (IconColor == 2) {
        [self.backgroundView setBackgroundColor:[UIColor clearColor]];
    }
}

%end

%hook SBFolderBackgroundView
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    
    if (FolderColor == 1) {
        return %orig;
    }
    
    if (FolderColor == 2) { //Color
        NSDictionary *fbackgroundColorDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbackgroundColorDict" inDomain:domain];
        
        self.layer.masksToBounds = YES;
        
        if (@available(iOS 26, *)) {
            SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
            self.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
        } else {
            self.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        }
        
        [self setBackgroundColor:[UIColor colorWithRed:[fbackgroundColorDict[@"red"] floatValue] green:[fbackgroundColorDict[@"green"] floatValue] blue:[fbackgroundColorDict[@"blue"] floatValue] alpha:[fbackgroundColorDict[@"alpha"] floatValue]]];
    }
    
    if (FolderColor == 3) {
        return ;
    }
}

- (id)initWithFrame:(CGRect)frame {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    
    if (FolderColor == 3) { //Milk
        SBFolderBackgroundView *view = %orig;
        
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[_UIBackdropView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2060];
        blurView.backgroundColor = [UIColor systemBackgroundColor];
        blurView.alpha = 0.2;
        
        blurView.layer.masksToBounds = YES;
        
        if (@available(iOS 26, *)) {
            SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
            blurView.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
        } else {
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        }
        
        CGRect newFrame = blurView.frame;
//        newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
        blurView.frame = newFrame;
        
        [view addSubview:blurView];
        
        BOOL isInDarkMode = ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
        if (isInDarkMode) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[_UIBackdropView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            blurView.backgroundColor = [UIColor systemBackgroundColor];
            blurView.alpha = 0.2;
            
            blurView.layer.masksToBounds = YES;
            
            if (@available(iOS 26, *)) {
                SBHFloatyFolderVisualConfiguration *configuration = [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];
                blurView.layer.cornerRadius = (CGFloat)configuration.continuousCornerRadius;
            } else {
                blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
            }
            
            CGRect newFrame = blurView.frame;
//            newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
            blurView.frame = newFrame;
            
            [view addSubview:blurView];
        }
        return (SBFolderBackgroundView*)view;
    }
    return %orig;
}
%end
