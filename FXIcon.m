#import "FXIcon.h"

@interface SBApplication
- (NSString *)bundleIdentifier;
- (NSString *)displayName;
- (id)initWithApplicationInfo:(id)arg1 ;
@end

@implementation FXIcon
- (id)initWithApplication:(SBApplication *)application {
    if ((self = [super init])) {
        self.application = application;
    }
    return self;
}
@end
