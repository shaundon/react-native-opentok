#import "TokBoxVideo.h"
#import "RCTBridge.h"

#import "TokBoxVideoManager.h"

@implementation TokBoxVideoManager

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (UIView *)view {
  return [[TokBoxVideo alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

//- (NSDictionary *)customDirectEventTypes {
//}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

//- (NSDictionary *)constantsToExport {
//  
//}

@end
