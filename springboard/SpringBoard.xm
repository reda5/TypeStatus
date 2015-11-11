#import "HBTSStatusBarAlertServer.h"
#import "HBTSStatusBarIconController.h"
#import "../client/HBTSPreferences.h"
#import <Cephei/HBPreferences.h>
#import <ChatKit/CKEntity.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <IMCore/IMHandle.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SpringBoard.h>
#include <dlfcn.h>

HBTSPreferences *preferences;

#pragma mark - Hide while Messages is open

BOOL HBTSShouldHide(HBTSStatusBarType type) {
	BOOL hideInMessages = NO;

	switch (type) {
		case HBTSStatusBarTypeTyping:
		case HBTSStatusBarTypeTypingEnded:
			hideInMessages = preferences.typingHideInMessages;
			break;

		case HBTSStatusBarTypeRead:
			hideInMessages = preferences.readHideInMessages;
			break;
	}

	if (hideInMessages) {
		SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];
		return !app.isLocked && [app._accessibilityFrontMostApplication.bundleIdentifier isEqualToString:@"com.apple.MobileSMS"];
	}

	return NO;
}

#pragma mark - Get contact name

NSString *HBTSNameForHandle(NSString *handle) {
	if ([handle isEqualToString:@"example@hbang.ws"]) {
		return @"Johnny Appleseed";
	} else {
		CKEntity *entity = [[%c(CKEntity) copyEntityForAddressString:handle] autorelease];

		if (!entity || ([entity respondsToSelector:@selector(handle)] && !entity.handle.person)) {
			return handle;
		}

		return entity.handle._displayNameWithAbbreviation ?: entity.name;
	}
}

#pragma mark - Show/hide

void HBTSShowAlert(HBTSStatusBarType type, NSString *sender, BOOL isTyping) {
	if (HBTSShouldHide(type)) {
		return;
	}

	HBTSNotificationType notificationType = HBTSNotificationTypeNone;

	switch (type) {
		case HBTSStatusBarTypeTyping:
		case HBTSStatusBarTypeTypingEnded:
			notificationType = preferences.typingType;
			break;

		case HBTSStatusBarTypeRead:
			notificationType = preferences.readType;
			break;
	}

	NSTimeInterval timeout = isTyping && preferences.useTypingTimeout ? kHBTSTypingTimeout : preferences.overlayDisplayDuration;

	switch (notificationType) {
		case HBTSNotificationTypeOverlay:
			[HBTSStatusBarAlertServer sendAlertType:type sender:HBTSNameForHandle(sender) timeout:timeout];
			break;

		case HBTSNotificationTypeIcon:
			[HBTSStatusBarIconController showIconType:type timeout:timeout];
			break;
	}
}

#pragma mark - Constructor

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/libstatusbar.dylib", RTLD_LAZY);
	dlopen("/Library/MobileSubstrate/DynamicLibraries/TypeStatusClient.dylib", RTLD_LAZY);

	preferences = [%c(HBTSPreferences) sharedInstance];

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:HBTSSpringBoardReceivedMessageNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		HBTSStatusBarType type = (HBTSStatusBarType)((NSNumber *)notification.userInfo[kHBTSMessageTypeKey]).intValue;
		NSString *sender = notification.userInfo[kHBTSMessageSenderKey];
		BOOL isTyping = ((NSNumber *)notification.userInfo[kHBTSMessageIsTypingKey]).boolValue;

		HBTSShowAlert(type, sender, isTyping);
	}];
}
