#import "Headers.h"

UIColor *titleHexColour;
UIColor *iconHexColour;
UIColor *backgroundHexColour;

UIImageView* _folderIcon;
_UIBackdropView *blurView;

int NameColor = 1;
int IconColor = 1;
int FolderColor = 1;

//Milk
%hook SBFolderBackgroundView
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    
    if (FolderColor == 1) {
        return %orig;
    }
    
    if (FolderColor == 2) {
        return %orig;
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
    
    if (FolderColor == 3) {
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
        blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
        
        CGRect newFrame = blurView.frame;
        newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
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
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
            
            CGRect newFrame = blurView.frame;
            newFrame.size = [%c(SBFolderBackgroundView) folderBackgroundSize];
            blurView.frame = newFrame;
            
            [view addSubview:blurView];
        }
        return (SBFolderBackgroundView*)view;
    }
    return %orig;
}
%end

%hook SBFolderTitleTextField
- (id)initWithFrame:(CGRect)arg1 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    
    if (FolderColor == 3) {
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
        blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
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
            blurView.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
            
            [view addSubview:blurView];
        }
        return (SBFolderTitleTextField*)view;
    }
    return %orig;
}
%end

//Title Color
%group TC
%hook SBFolderTitleTextField
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        NameColor = [prefs objectForKey:@"NC"] ? [[prefs objectForKey:@"NC"] intValue] : NameColor;
    }
    
    if (NameColor == 1) {
        return %orig;
    }

    if (NameColor == 2) {
        [self setTextColor:titleHexColour];
    }
    return %orig;
}
%end
%end

//Icon Color
%group IC
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
        [self.backgroundView setBackgroundColor:iconHexColour];
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius = 13.5;
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
%end

//Background Color
%group BC
%hook SBFolderBackgroundView
- (void)layoutSubviews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if (prefs) {
        FolderColor = [prefs objectForKey:@"FC"] ? [[prefs objectForKey:@"FC"] intValue] : FolderColor;
    }
    if (FolderColor == 1) {

        return %orig;
    }

    if (FolderColor == 2) {
        [self setBackgroundColor:backgroundHexColour];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = [%c(SBFolderBackgroundView) cornerRadiusToInsetContent];
    }
}
%end
%end

%ctor {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"/var/mobile/Library/Preferences/com.lizynz.folderx.plist"];
    
    NSData *colorData1 = [defaults objectForKey:@"kTitleColor"];
    NSKeyedUnarchiver *unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData1 error:nil];
    [unarchiver1 setRequiresSecureCoding:NO];
    NSString *hexString1 = [unarchiver1 decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    if (hexString1 != nil) {
        titleHexColour = [unarchiver1 decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        %init(TC);
    }
        
    NSData *colorData2 = [defaults objectForKey:@"kIconColor"];
    NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData2 error:nil];
    [unarchiver2 setRequiresSecureCoding:NO];
    NSString *hexString2 = [unarchiver2 decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    if (hexString2 != nil) {
        iconHexColour = [unarchiver2 decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        %init(IC);
    }
        
    NSData *colorData = [defaults objectForKey:@"kBackgroundColor"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    if (hexString != nil) {
        backgroundHexColour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        %init(BC);
    }
    
    //Send from rootful in rootless directories
    NSString *originalPath = @"/var/mobile/Library/Preferences/com.lizynz.folderx.plist";
    NSString *newPath = @"/var/jb/var/mobile/Library/Preferences/com.lizynz.folderx.plist";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:originalPath]) {
        NSError *error;
        if (![fileManager copyItemAtPath:originalPath toPath:newPath error:&error]) {
            NSLog(@"Failed to copy file: %@", error);
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:originalPath];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                          object:fileHandle
                                                           queue:nil
                                                      usingBlock:^(NSNotification *notification) {
            [fileHandle readInBackgroundAndNotify];
            NSError *error;
            if (![fileManager removeItemAtPath:newPath error:&error]) {
                NSLog(@"Failed to copy file: %@", error);
            }
            if (![fileManager copyItemAtPath:originalPath toPath:newPath error:&error]) {
                NSLog(@"Failed to copy file: %@", error);
            }
            [fileHandle waitForDataInBackgroundAndNotify];
        }];
        [fileHandle waitForDataInBackgroundAndNotify];
    } else {
        NSLog(@"Failed to copy file: %@", originalPath);
    }
    
    %init(_ungrouped);
}
