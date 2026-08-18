#import "Headers.h"

static SBIconController *iconController = nil;

//Auto Close
%hook SBUIController
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    iconController = [%c(SBIconController) sharedInstance];
    if ([[iconController _openFolderController] isOpen]) {
        %orig;
        if ([[prefs objectForKey:@"AutoClose"] boolValue]) {
            [iconController.iconManager closeFolderAnimated:YES withCompletion:nil];
        }
    } else {
        %orig;
  }
}
%end

//Tap Close
%hook SBFloatyFolderView
- (BOOL)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"TapClose"] boolValue]) {
        return YES;
    }
    return %orig;
}
%end

//add drag
%hook SBFolderIcon
- (BOOL)canBeAddedToMultiItemDrag {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"DragFolder"] boolValue]) {
        return YES;
    }
    return %orig;
}
%end

%hook SBWidgetIcon
- (BOOL)canBeAddedToMultiItemDrag {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kRWSettingsPath];
    if ([[prefs objectForKey:@"DragWidget"] boolValue]) {
        return YES;
    }
    return %orig;
}
%end
