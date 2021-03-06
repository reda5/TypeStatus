#import "HBTSConversationPreferences.h"
#import <IMCore/IMChat.h>
#import <IMCore/IMHandle.h>

HBTSConversationPreferences *preferences;

%hook CKConversation

- (void)setLocalUserIsTyping:(BOOL)isTyping {
	// if the local user is typing AND typing notifications are enabled, go ahead
	// and set it to YES. otherwise, they’re either not typing or have disabled
	// typing notifications.
	if ([preferences.class shouldEnable]) {
		%orig(isTyping && [preferences typingNotificationsEnabledForConversation:self]);
	} else {
		%orig;
	}
}

- (void)setLocalUserIsRecording:(BOOL)isRecording {
	// recording is pretty much the same thing as typing so we cover that too
	if ([preferences.class shouldEnable]) {
		%orig(isRecording && [preferences typingNotificationsEnabledForConversation:self]);
	} else {
		%orig;
	}
}

%end

%ctor {
	// only initialise these hooks if we’re allowed to
	if ([HBTSConversationPreferences shouldEnable]) {
		preferences = [[HBTSConversationPreferences alloc] init];
		%init;
	}
}
