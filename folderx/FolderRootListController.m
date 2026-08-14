#import <Foundation/Foundation.h>
#import "FolderRootListController.h"
#import <spawn.h>

static NSString *saveSettings = @"/var/jb/var/mobile/Library/Preferences/com.lizynz.folderx.plist";

static NSBundle *tweakBundle = nil;
#define LOCALIZED(str) [tweakBundle localizedStringForKey:str value:@"" table:nil]

@implementation FolderRootListController{
    BOOL _settingsChanged;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        tweakBundle = [NSBundle bundleWithPath:@"/var/jb/Library/PreferenceBundles/FolderX.bundle"];
    }
    return self;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
        
        UIAction *titleA = [UIAction actionWithTitle:LOCALIZED(@"Respring") image:[UIImage systemImageNamed:@"rays"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
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

        UIAction *cancelA = [UIAction actionWithTitle:LOCALIZED(@"Reset settings") image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
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

- (void)twitter {
    [[UIApplication sharedApplication]
        openURL:[NSURL URLWithString:@"https://x.com/Lizynz1"]];
}

- (void)github {
    [[UIApplication sharedApplication]
        openURL:[NSURL URLWithString:@"https://github.com/Lizynz/FolderX"]];
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

    self.accessoryView = self.control;

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

    self.accessoryView = self.control;

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

@interface ColorListController : PSListController <UIPopoverPresentationControllerDelegate>
@end

@implementation ColorListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Color" target:self];
        
        UIAction *titleA = [UIAction actionWithTitle:LOCALIZED(@"Respring") image:[UIImage systemImageNamed:@"rays"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
            
            pid_t pid;
            int status;
            const char* args[] = { "killall", "-9", "SpringBoard", NULL };
            posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
            waitpid(pid, &status, WEXITED);
            
        }];

        UIAction *cancelA = [UIAction actionWithTitle:LOCALIZED(@"Reset color") image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction *_Nonnull action) {
            
            NSString *domain = saveSettings;
            NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:domain];
            
            [defaults removeObjectForKey:@"nameColorDict"];
            [defaults removeObjectForKey:@"textColorDict"];
            [defaults removeObjectForKey:@"ficonColorDict"];
            [defaults removeObjectForKey:@"fbackgroundColorDict"];
            
            [defaults synchronize];

            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domain];
            
            double delayInSeconds = 0.5;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                exit(0);
            });
        }];
        
        cancelA.attributes = UIMenuElementAttributesDestructive;

        UIMenu *menuActions = [UIMenu menuWithTitle:@"" children:@[titleA, cancelA]];
        UIBarButtonItem *optionsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"hand.tap"] menu:menuActions];
        optionsItem.tintColor = [UIColor systemBlueColor];

        self.navigationItem.rightBarButtonItems = @[optionsItem];
    }
    return _specifiers;
}

@end

typedef NS_ENUM(NSInteger, XXDynamicSpecifierOperatorType) {
  XXEqualToOperatorType,
  XXNotEqualToOperatorType,
  XXGreaterThanOperatorType,
  XXLessThanOperatorType,
};

@interface LauncherListController : PSListController
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
- (void)collectDynamicSpecifiersFromArray:(NSArray *)array;
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier;
- (XXDynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string;
@end

@implementation LauncherListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Launcher" target:self];
        
        [self collectDynamicSpecifiersFromArray:_specifiers];
    }
    
    return _specifiers;
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];
    [self collectDynamicSpecifiersFromArray:self.specifiers];
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];
    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }
    
    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        
        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];
                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }
            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }
    
    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}

#pragma mark - Observing Opposing Specifier Value Changes

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    
    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];
        
        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}

#pragma mark - Override Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;
        
        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];
                
                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        
        if (shouldHide) {
            return 0;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
        
        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];
        
        if ([opposingValue isKindOfClass:NSNumber.class]) {
            XXDynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];
            
            switch(operatorType) {
                case XXEqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;
                    
                case XXNotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;
                    
                case XXGreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;
                    
                case XXLessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }
        
        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }
        
        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }
    
    return NO;
}

- (XXDynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(XXEqualToOperatorType), @"!=" : @(XXNotEqualToOperatorType), @">" : @(XXGreaterThanOperatorType), @"<" : @(XXLessThanOperatorType) };
    return [operatorValues[string] intValue];
}
@end
