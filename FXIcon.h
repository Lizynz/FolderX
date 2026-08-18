#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SBApplication;

@interface FXIcon : NSObject
@property (nonatomic, strong) SBApplication *application;
@property (nonatomic, strong) UIImage *image;
- (id)initWithApplication:(SBApplication *)application;
@end
