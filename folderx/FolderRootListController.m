#import <Foundation/Foundation.h>
#import "FolderRootListController.h"
#import <spawn.h>

#import "ColourOptionsController.h"
#import "ColourOptionsIconController.h"
#import "ColourOptionsComentController.h"

@implementation FolderRootListController{
    BOOL _settingsChanged;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
        
        UIAction *titleA = [UIAction actionWithTitle:@"Respring" image:[UIImage systemImageNamed:@"rays"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
            [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
            spinner.color = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            [self.view addSubview:spinner];
            [spinner startAnimating];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                pid_t pid;
                int status;
                const char* args[] = { "killall", "-9", "SpringBoard", NULL };
                posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
                waitpid(pid, &status, WEXITED);
            });
        }];

        UIAction *cancelA = [UIAction actionWithTitle:@"Reset settings" image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
            NSString *path1 = @"/var/jb/var/mobile/Library/Preferences/com.lizynz.folderx.plist";
            NSString *path2 = @"/var/mobile/Library/Preferences/com.lizynz.folderx.plist";

            NSString *domain = @"com.lizynz.folderx";
            NSError *error;

            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:path1]) {
                [fileManager removeItemAtPath:path1 error:&error];
            }

            if ([fileManager fileExistsAtPath:path2]) {
                [fileManager removeItemAtPath:path2 error:&error];
            }
            
            pid_t pid;
            int status;
            const char* args[] = { "killall", "-9", "SpringBoard", NULL };
            posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
            waitpid(pid, &status, WEXITED);

            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domain];
        }];
        
        cancelA.attributes = UIMenuElementAttributesDestructive;

        UIMenu *menuActions = [UIMenu menuWithTitle:@"" children:@[titleA, cancelA]];
        UIBarButtonItem *optionsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"hand.tap"] menu:menuActions];
        optionsItem.tintColor = [UIColor systemBlueColor];

        self.navigationItem.rightBarButtonItems = @[optionsItem];
    }
    return _specifiers;
}

- (void)dealloc {
    [super dealloc];
}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/Lizynz1"] options:@{} completionHandler:nil];
}

- (void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Lizynz/FolderX"] options:@{} completionHandler:nil];
}
@end

@interface TitleStepperCell : PSControlTableCell
@property (nonatomic, retain) UIStepper *control;
@end

@implementation TitleStepperCell
@dynamic control;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        self.accessoryView = self.control;
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    self.control.minimumValue = [specifier.properties[@"min"] doubleValue];
    self.control.maximumValue = [specifier.properties[@"max"] doubleValue];
    [self _updateLabel];
}

- (void)setCellEnabled:(BOOL)cellEnabled {
    [super setCellEnabled:cellEnabled];
    self.control.enabled = cellEnabled;
}

- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    stepper.continuous = NO;
    
    stepper.minimumValue = 40;
    stepper.maximumValue = 60;
    
    stepper.stepValue = 5;
    stepper.value = 40;
    
    return stepper;
}

- (NSNumber *)controlValue {
    return @(self.control.value);
}

- (void)setValue:(NSNumber *)value {
    [super setValue:value];
    self.control.value = value.doubleValue;
}

- (void)controlChanged:(UIStepper *)stepper {
    [super controlChanged:stepper];
    [self _updateLabel];
}

- (void)_updateLabel {
    if (!self.control) {
        return;
    }
    NSString *labelText = [NSString stringWithFormat:@"%@ %d", self.specifier.name, (int)self.control.value];
    if (labelText != nil) {
        self.textLabel.text = labelText;
        [self setNeedsLayout];
    }
}

@end

@interface RadiusStepperCell : PSControlTableCell
@property (nonatomic, retain) UIStepper *control;
@end

@implementation RadiusStepperCell
@dynamic control;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        self.accessoryView = self.control;
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    self.control.minimumValue = [specifier.properties[@"min"] doubleValue];
    self.control.maximumValue = [specifier.properties[@"max"] doubleValue];
    [self _updateLabel];
}

- (void)setCellEnabled:(BOOL)cellEnabled {
    [super setCellEnabled:cellEnabled];
    self.control.enabled = cellEnabled;
}

- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    stepper.continuous = NO;
    
    stepper.minimumValue = 5;
    stepper.maximumValue = 30;
    
    stepper.stepValue = 5;
    stepper.value = 30;
    
    return stepper;
}

- (NSNumber *)controlValue {
    return @(self.control.value);
}

- (void)setValue:(NSNumber *)value {
    [super setValue:value];
    self.control.value = value.doubleValue;
}

- (void)controlChanged:(UIStepper *)stepper {
    [super controlChanged:stepper];
    [self _updateLabel];
}

- (void)_updateLabel {
    if (!self.control) {
        return;
    }
    NSString *labelText = [NSString stringWithFormat:@"%@ %d", self.specifier.name, (int)self.control.value];
    if (labelText != nil) {
        self.textLabel.text = labelText;
        [self setNeedsLayout];
    }
}

@end

@interface ColorListController : PSListController <UIPopoverPresentationControllerDelegate>
@end

@implementation ColorListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Color" target:self] retain];
        
        UIBarButtonItem *respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
        [[self navigationItem] setRightBarButtonItem:respringBtn animated:YES];
        [respringBtn release];
    }

    return _specifiers;
}

- (void)respring {
    pid_t pid;
    int status;
    const char* args[] = { "killall", "-9", "SpringBoard", NULL };
    posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

- (void)colorTitle {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        ColourOptionsComentController *colourOptionsComentController = [[ColourOptionsComentController alloc] init];
        UINavigationController *colourOptionsComentControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsComentController];
        colourOptionsComentControllerView.modalPresentationStyle = UIModalPresentationFullScreen;
        colourOptionsComentControllerView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:colourOptionsComentControllerView animated:YES completion:nil];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        ColourOptionsComentController *colourOptionsComentController = [[ColourOptionsComentController alloc] init];
        UINavigationController *colourOptionsComentControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsComentController];
        colourOptionsComentControllerView.modalPresentationStyle = UIModalPresentationPopover;

        UIPopoverPresentationController *popoverPresentationController = [colourOptionsComentControllerView popoverPresentationController];
        popoverPresentationController.delegate = self;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
        [self presentViewController:colourOptionsComentControllerView animated:YES completion:nil];
    }
}

- (void)colorIcon {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        ColourOptionsIconController *colourOptionsIconController = [[ColourOptionsIconController alloc] init];
        UINavigationController *colourOptionsIconControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsIconController];
        colourOptionsIconControllerView.modalPresentationStyle = UIModalPresentationFullScreen;
        colourOptionsIconControllerView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:colourOptionsIconControllerView animated:YES completion:nil];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        ColourOptionsIconController *colourOptionsIconController = [[ColourOptionsIconController alloc] init];
        UINavigationController *colourOptionsIconControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsIconController];
        colourOptionsIconControllerView.modalPresentationStyle = UIModalPresentationPopover;

        UIPopoverPresentationController *popoverPresentationController = [colourOptionsIconControllerView popoverPresentationController];
        popoverPresentationController.delegate = self;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
        [self presentViewController:colourOptionsIconControllerView animated:YES completion:nil];
    }
}

- (void)colorBackground {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        ColourOptionsController *colourOptionsController = [[ColourOptionsController alloc] init];
        UINavigationController *colourOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsController];
        colourOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;
        colourOptionsControllerView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:colourOptionsControllerView animated:YES completion:nil];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        ColourOptionsController *colourOptionsController = [[ColourOptionsController alloc] init];
        UINavigationController *colourOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsController];
        colourOptionsControllerView.modalPresentationStyle = UIModalPresentationPopover;

        UIPopoverPresentationController *popoverPresentationController = [colourOptionsControllerView popoverPresentationController];
        popoverPresentationController.delegate = self;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
        [self presentViewController:colourOptionsControllerView animated:YES completion:nil];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}

@end

@interface LauncherListController : PSListController
@end

@implementation LauncherListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Launcher" target:self] retain];
    }
    
    return _specifiers;
}

@end
