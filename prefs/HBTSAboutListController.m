#import "HBTSAboutListController.h"

@implementation HBTSAboutListController

+ (NSString *)hb_specifierPlist {
	return @"About";
}

#pragma mark - Callbacks

- (void)openTranslations {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.hbang.ws/translations/"]];
}

@end
