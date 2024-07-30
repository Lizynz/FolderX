#import <sys/utsname.h>
#import "Headers.h"

#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height - 170
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width - 20

int OLD = 1;

%hook SBFloatyFolderView
- (CGRect)_frameForScalingView {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                return (CGRect){{10, 150},{kScreenWidth, kScreenHeight}};
            }
    }
    return %orig;
}

- (BOOL)_shouldConvertToMultipleIconListsInLandscapeOrientation {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            return NO;
        }
    }
    return %orig;
}

- (double)_titleFontSize { //title size
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id TitleSize = [prefs objectForKey:@"TitleSize"];
    if( [TitleSize intValue] >= 40 && [TitleSize intValue] <= 60 ) {
        return [TitleSize floatValue];
    }
    return %orig;
}

- (void)setCornerRadius:(double)arg1 {
    arg1 = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
    %orig(arg1);
}

- (BOOL)_showsTitle {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hidefoldername"] boolValue]) {
        return NO;
    }
    return %orig;
}

%end

%hook SBIconListFlowLayout
- (NSUInteger)numberOfRowsForOrientation:(NSInteger)arg1 {
    NSInteger x = %orig(arg1);
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            if (x==1) {
                return %orig;
            }
            if (x==3) {
                return 5;
            }
            return %orig;
        }
    }
    return %orig;
}

- (NSUInteger)numberOfColumnsForOrientation:(NSInteger)arg1 {
    NSInteger x = %orig(arg1);
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            if (x==1) {
                return %orig;
            }
            if (x==3) {
                return 4;
            }
            return %orig;
        }
    }
    return %orig;
}

- (unsigned long long)maximumIconCount {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            return 30;
        }
    }
    return %orig;
}
%end

%hook SBDockIconListView
- (unsigned long long)maximumIconCount {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            return 4;
        }
    }
    return %orig;
}
%end

%hook _SBIconGridWrapperView
- (void)layoutSubviews {
    %orig;
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            CGAffineTransform originalIconView = (self.transform);
            self.transform = CGAffineTransformMake(
                                                   0.7,
                                                   originalIconView.b,
                                                   originalIconView.c,
                                                   0.7,
                                                   0.6,
                                                   0.7
                                                   );
        }
    }
    return %orig;
}
%end

%hook SBHFloatyFolderVisualConfiguration
- (CGFloat)continuousCornerRadius { //folder radius #2
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id FolderRadius = [prefs objectForKey:@"FolderRadius"];
    if( [FolderRadius intValue] >= 5 && [FolderRadius intValue] <= 30 ) {
        return [FolderRadius floatValue];
    }
    return %orig;
}
%end

%hook SBFolderBackgroundView
- (void)layoutSubviews { //hide background
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"bfh"] boolValue]) {
        self.alpha = 0;
        self.hidden = YES;
        return ;
    }
    return %orig;
}

+ (double)cornerRadiusToInsetContent { //folder radius #3
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id FolderRadius = [prefs objectForKey:@"FolderRadius"];
    if( [FolderRadius intValue] >= 5 && [FolderRadius intValue] <= 30 ) {
        return [FolderRadius floatValue];
    }
    return %orig;
}
%end

%hook SBFolderController
- (BOOL)_homescreenAndDockShouldFade { //iOS9 style
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        OLD = [prefs objectForKey:@"old"] ? [[prefs objectForKey:@"old"] intValue] : OLD;
    }
    
    if (OLD == 1) {
        return %orig;
    }
    
    if (OLD == 2) {
        return YES;
    }
    
    if (OLD == 3) {
        return YES;
    }
    return %orig;
}

- (void)_addFakeStatusBarView { //add status bar
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        OLD = [prefs objectForKey:@"old"] ? [[prefs objectForKey:@"old"] intValue] : OLD;
    }
    
    if (OLD == 1) {
        return %orig;
    }
    
    if (OLD == 2) {
        return ;
    }
    
    if (OLD == 3) {
        return ;
    }
    return %orig;
}

%end

%hook SBFolderControllerBackgroundView
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        OLD = [prefs objectForKey:@"old"] ? [[prefs objectForKey:@"old"] intValue] : OLD;
    }
    
    if (OLD == 1) {
        return %orig;
    }
    
    if (OLD == 2) {
        return %orig;
    }
    
    if (OLD == 3) {
        return ;
    }
    return %orig;
}

%end

%hook SBFolderIconZoomAnimator
- (void)_performAnimationToFraction:(CGFloat)arg0 withCentralAnimationSettings:(id)arg1 delay:(CGFloat)arg2 alreadyAnimating:(BOOL)arg3 sharedCompletion:(id)arg4 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hideanimation"] boolValue]) {
        arg2 = 0;
        arg3 = YES;
        %orig(arg0,arg1,arg2,arg3,arg4);
    }
    return %orig;
}

- (unsigned long long)_numberOfSignificantAnimations {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hideanimation"] boolValue]) {
        return 0;
    }
    return %orig;
}
%end

%hook _SBInnerFolderIconZoomAnimator
- (unsigned long long)_numberOfSignificantAnimations {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hideanimation"] boolValue]) {
        return 0;
    }
    return %orig;
}
%end

int TITLE = 2;

%hook SBFolderTitleTextField
- (CGRect)clearButtonRectForBounds:(CGRect)frame {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        TITLE = [prefs objectForKey:@"title"] ? [[prefs objectForKey:@"title"] intValue] : TITLE;
    }
    if (TITLE == 1) {
    }
    if (TITLE == 2) {
    }
    if (TITLE == 3) {
        if ([[prefs objectForKey:@"fullfolder"] boolValue]) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                UIEdgeInsets insets = UIEdgeInsetsMake(0, -285, 0, 0);
                CGRect insetRect = UIEdgeInsetsInsetRect(frame, insets);
                return insetRect;
            }
        }
    }
    return %orig;
}

- (CGRect)textRectForBounds:(CGRect)frame {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        TITLE = [prefs objectForKey:@"title"] ? [[prefs objectForKey:@"title"] intValue] : TITLE;
    }

    if (TITLE == 1) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 0);
        CGRect insetRect = UIEdgeInsetsInsetRect(frame, insets);
        return insetRect;
    }

    if (TITLE == 2) {
    }

    if (TITLE == 3) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 20);
        CGRect insetRect = UIEdgeInsetsInsetRect(frame, insets);
        return insetRect;
    }
    return %orig;
}

- (CGRect)editingRectForBounds:(CGRect)frame {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        TITLE = [prefs objectForKey:@"title"] ? [[prefs objectForKey:@"title"] intValue] : TITLE;
    }
    if (TITLE == 1) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 0);
        CGRect insetRect = UIEdgeInsetsInsetRect(frame, insets);
        return insetRect;
    }
    
    if (TITLE == 2) {
    }
    
    if (TITLE == 3) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 20);
        CGRect insetRect = UIEdgeInsetsInsetRect(frame, insets);
        return insetRect;
    }
    return %orig;
}

- (void)layoutSubviews {
    %orig;
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        TITLE = [prefs objectForKey:@"title"] ? [[prefs objectForKey:@"title"] intValue] : TITLE;
    }

    if (TITLE == 1) {
        [self setTextAlignment:NSTextAlignmentLeft];
    }

    if (TITLE == 2) {
    }

    if (TITLE == 3) {
        [self setTextAlignment:NSTextAlignmentRight];
    }

    if ([[prefs objectForKey:@"BoldTitle"] boolValue]) {
        [self setFont:[UIFont boldSystemFontOfSize:(self.font.pointSize)]];
    }
}

%end
