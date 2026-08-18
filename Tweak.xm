#import <sys/utsname.h>
#import "Headers.h"

#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width - 20

int OLD = 1;

%hook SBFloatyFolderView

- (double)_titleFontSize { //title size
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id TitleSize = [prefs objectForKey:@"TitleSize"];
    if( [TitleSize intValue] >= 40 && [TitleSize intValue] <= 60 ) {
        return [TitleSize floatValue];
    }
    return %orig;
}

- (void)setCornerRadius:(double)arg1 {
    if (@available(iOS 26, *)) {
        SBHFloatyFolderVisualConfiguration *configuration =
            [[%c(SBHFloatyFolderVisualConfiguration) alloc] init];

        %orig(configuration.continuousCornerRadius);
    } else {
        arg1 = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        %orig(arg1);
    }
}

- (BOOL)_showsTitle {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"hidefoldername"] boolValue]) {
        return NO;
    }
    return %orig;
}

%end

#define HideFolderLabel(x) [x.location isEqualToString:@"SBIconLocationFolder"] //hide folder label

%hook SBIconView
%property (nonatomic, strong) SBIconListView *_atriaLastIconListView;
- (void)setAllowsLabelArea:(BOOL)allows {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"HideFolderLabel"] boolValue]) {
        if(HideFolderLabel(self)) {
            allows = NO;
        }
    }
    %orig(allows);
}

- (BOOL)allowsLabelArea {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"HideFolderLabel"] boolValue]) {
        if(HideFolderLabel(self)){
            return NO;
        }
    }
    return %orig;
}
%end

%hook SBHFloatyFolderVisualConfiguration
- (CGFloat)continuousCornerRadius { //folder radius #2
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id FolderRadius = [prefs objectForKey:@"FolderRadius"];
    if( [FolderRadius intValue] >= 5 && [FolderRadius intValue] <= 35 ) {
        return [FolderRadius floatValue];
    }
    return 35;
}
%end

%hook SBFolderBackgroundView
+ (double)cornerRadiusToInsetContent { //folder radius #3
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    id FolderRadius = [prefs objectForKey:@"FolderRadius"];
    if( [FolderRadius intValue] >= 5 && [FolderRadius intValue] <= 35 ) {
        return [FolderRadius floatValue];
    }
    return 35;
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

    if (TITLE == 2) {}

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
    
    if (TITLE == 2) {}
    
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
        [self setTextAlignment:NSTextAlignmentCenter];
    }

    if (TITLE == 3) {
        [self setTextAlignment:NSTextAlignmentRight];
    }

    if ([[prefs objectForKey:@"BoldTitle"] boolValue]) {
        [self setFont:[UIFont boldSystemFontOfSize:(self.font.pointSize)]];
    }
}

%end
