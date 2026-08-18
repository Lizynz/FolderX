#import "FTColorCell.h"

@implementation FTColorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        self.accessoryView = self.control;
//        self.detailTextLabel.text = [specifier.properties objectForKey:@"subtitle"];
//        self.detailTextLabel.numberOfLines = 2;
//        [self setCellEnabled:[[[NSUserDefaults standardUserDefaults] objectForKey:@"textStyle" inDomain:domain] integerValue] == 2];
    }
    return self;
}
- (void)setCellEnabled:(BOOL)cellEnabled {
    [super setCellEnabled:cellEnabled];
    self.control.backgroundColor = cellEnabled ? [self selectedColor] : [UIColor secondaryLabelColor];
    // self.control.hidden = !cellEnabled;
}

//- (BOOL)cellEnabled {
//    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"textStyle" inDomain:domain] integerValue] == 2;
//}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    self.control.backgroundColor = [self cellEnabled] ? [self selectedColor] : [UIColor secondaryLabelColor];
}

- (UIButton *)newControl {
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton.frame = CGRectMake(0, 0, 30, 30);
    
    colorButton.backgroundColor = [self selectedColor];
    colorButton.layer.masksToBounds = NO;
    colorButton.layer.cornerRadius = colorButton.frame.size.width / 2;

    colorButton.layer.borderColor = UIColor.tertiaryLabelColor.CGColor;
    colorButton.layer.borderWidth = 2.0;

    [colorButton addTarget:self action:@selector(selectColor) forControlEvents:UIControlEventTouchUpInside];
    
    return colorButton;
}

- (void)selectColor {
    UIColorPickerViewController *colorPickerController = [[UIColorPickerViewController alloc] init];
    colorPickerController.delegate = self;
    colorPickerController.supportsAlpha = YES;
    colorPickerController.selectedColor = [self selectedColor];
    colorPickerController.view.tintColor = [UIColor labelColor];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        colorPickerController.modalPresentationStyle = UIModalPresentationPopover;

        UIPopoverPresentationController *popoverPresentationController = [colorPickerController popoverPresentationController];
        popoverPresentationController.delegate = self;
        
        popoverPresentationController.sourceView = self.contentView;
        popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds), 0, 0);
    } else {
        colorPickerController.modalPresentationStyle = UIModalPresentationPageSheet;
        colorPickerController.modalInPresentation = YES;
    }

    [[self _viewControllerForAncestor] presentViewController:colorPickerController animated:YES completion:nil];
}

- (UIColor *)selectedColor {
    NSDictionary *colorDict = [[NSUserDefaults standardUserDefaults] objectForKey:[self.specifier.properties[@"key"] stringByAppendingString:@"Dict"] inDomain:domain];
    return colorDict ? [UIColor colorWithRed:[colorDict[@"red"] floatValue] green:[colorDict[@"green"] floatValue] blue:[colorDict[@"blue"] floatValue] alpha:[colorDict[@"alpha"] floatValue]] : [UIColor grayColor];
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController {
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryForColor:viewController.selectedColor] forKey:[self.specifier.properties[@"key"] stringByAppendingString:@"Dict"] inDomain:domain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.control.backgroundColor = [self selectedColor];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.lizynz.folderx", nil, nil, true);
}

- (NSDictionary *)dictionaryForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSMutableDictionary *colorDict = [NSMutableDictionary new];
    [colorDict setObject:[NSNumber numberWithFloat:components[0]] forKey:@"red"];
    [colorDict setObject:[NSNumber numberWithFloat:components[1]] forKey:@"green"];
    [colorDict setObject:[NSNumber numberWithFloat:components[2]] forKey:@"blue"];
    [colorDict setObject:[NSNumber numberWithFloat:components[3]] forKey:@"alpha"];
    return colorDict;
}

@end
