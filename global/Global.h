#pragma mark - ARC macros

#if __has_feature(objc_arc)
	#define RETAIN(thing) thing
	#define AUTORELEASE(thing) thing
#else
	#define RETAIN(thing) [thing retain]
	#define AUTORELEASE(thing) [thing autorelease]
#endif

#pragma mark - Types

typedef NS_ENUM(NSUInteger, HBTSStatusBarType) {
	HBTSStatusBarTypeTyping,
	HBTSStatusBarTypeTypingEnded,
	HBTSStatusBarTypeRead
};

typedef NS_ENUM(NSUInteger, HBTSNotificationType) {
	HBTSNotificationTypeNone,
	HBTSNotificationTypeOverlay,
	HBTSNotificationTypeIcon
};

typedef NS_ENUM(NSUInteger, HBTSStatusBarAnimation) {
	HBTSStatusBarAnimationSlide,
	HBTSStatusBarAnimationFade
};

typedef NS_ENUM(NSUInteger, HBTSStatusBarFormat) {
	HBTSStatusBarFormatNatural,
	HBTSStatusBarFormatTraditional,
	HBTSStatusBarFormatNameOnly
};

#pragma mark - Constants

static NSTimeInterval const kHBTSTypingTimeout = 60.0;

// old values may be used here for compatibility with other tweaks that listen
// for typestatus notifications

static NSString *const HBTSClientSetStatusBarNotification = @"HBTSClientSetStatusBar";
static NSString *const HBTSSpringBoardReceivedMessageNotification = @"HBTSSpringBoardReceivedMessageNotification";

static NSString *const kHBTSMessageTypeKey = @"Type";
static NSString *const kHBTSMessageSenderKey = @"Name";
static NSString *const kHBTSMessageIsTypingKey = @"IsTyping";

static NSString *const kHBTSMessageIconNameKey = @"IconName";
static NSString *const kHBTSMessageContentKey = @"Content";
static NSString *const kHBTSMessageBoldRangeKey = @"BoldRange";
static NSString *const kHBTSMessageDirectionKey = @"Direction";

static NSString *const kHBTSMessageTimeoutKey = @"Duration";
static NSString *const kHBTSMessageSendDateKey = @"Date";
