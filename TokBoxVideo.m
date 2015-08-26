#import "RCTConvert.h"
#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
#import "UIView+React.h"
#import <AVFoundation/AVFoundation.h>

#import "TokBoxVideo.h"
#import <OpenTok/OpenTok.h>

NSString *const RNTokEvent = @"event";

@interface TokBoxVideo ()
<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate>

@end

@implementation TokBoxVideo {
  OTSession* _session;
  OTPublisher* _publisher;
  OTSubscriber* _subscriber;
  
  // Required to publish events.
  RCTEventDispatcher *_eventDispatcher;
  
  double _widgetHeight;
  double _widgetWidth;
  
  NSString* _apiKey;
  NSString* _sessionId;
  NSString* _token;
  
  bool _subscribeToSelf;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher {
  if ((self = [super init])) {
    _eventDispatcher = eventDispatcher;
    
    _widgetHeight = 240;
    _widgetWidth = 320;
    
    // TODO.
    _apiKey = @"45193862";
    _sessionId = @"1_MX40NTE5Mzg2Mn5-MTQ0MDM2MDQzMjA3Mn55cTNQU2Rwd3Y1QUdLSkU4Mk1nYnYrRnZ-UH4";
    _token = @"T1==cGFydG5lcl9pZD00NTE5Mzg2MiZzaWc9NGEzYzA4ODU3MDMwNzBiZDY4NmM3MDU4YThiZGYwMWRkZjJjYjdkZTpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5URTVNemcyTW41LU1UUTBNRE0yTURRek1qQTNNbjU1Y1ROUVUyUndkM1kxUVVkTFNrVTRNazFuWW5ZclJuWi1VSDQmY3JlYXRlX3RpbWU9MTQ0MDM2MDQzOCZub25jZT0wLjgwNjg3MjEwODI0MTE3MTMmZXhwaXJlX3RpbWU9MTQ0MDM2NDAyMCZjb25uZWN0aW9uX2RhdGE9";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - App lifecycle handlers.

- (void)applicationWillResignActive:(NSNotification *)notification {
  // TODO.
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
  // TODO.
}

#pragma mark - React view management.

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex {
  RCTLogError(@"Cannot have any subviews.");
  return;
}

- (void)removeReactSubview:(UIView *)subview {
  RCTLogError(@"Cannot have any subviews.");
  return;
}

- (void)layoutSubviews {
  //[super layoutSubviews];
}

#pragma mark - Lifecycle.

- (void)removeFromSuperview {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventDispatcher = nil;
  [self removeFromSuperview];
}

#pragma mark - OpenTok methods

- (void)doConnect {
  OTError *error = nil;
  [_session connectWithToken:_token error:&error];
  if (error) {
    [self showAlert:[error localizedDescription]];
  }
}

///**
// * Asynchronously begins the session connect process. Some time later, we will
// * expect a delegate method to call us back with the results of this action.
// */
//- (void)doConnect
//{
//  OTError *error = nil;
//  
//  [_session connectWithToken:_token error:&error];
//  if (error)
//  {
//    [self showAlert:[error localizedDescription]];
//  }
//}
//
///**
// * Sets up an instance of OTPublisher to use with this session. OTPubilsher
// * binds to the device camera and microphone, and will provide A/V streams
// * to the OpenTok session.
// */
//- (void)doPublish
//{
//  _publisher =
//  [[OTPublisher alloc] initWithDelegate:self
//                                   name:[[UIDevice currentDevice] name]];
//  
//  OTError *error = nil;
//  [_session publish:_publisher error:&error];
//  if (error)
//  {
//    [self showAlert:[error localizedDescription]];
//  }
//  
//  [self.view addSubview:_publisher.view];
//  [_publisher.view setFrame:CGRectMake(0, 0, _widgetWidth, _widgetHeight)];
//}
//
///**
// * Cleans up the publisher and its view. At this point, the publisher should not
// * be attached to the session any more.
// */
//- (void)cleanupPublisher {
//  [_publisher.view removeFromSuperview];
//  _publisher = nil;
//  // this is a good place to notify the end-user that publishing has stopped.
//}
//
///**
// * Instantiates a subscriber for the given stream and asynchronously begins the
// * process to begin receiving A/V content for this stream. Unlike doPublish,
// * this method does not add the subscriber to the view hierarchy. Instead, we
// * add the subscriber only after it has connected and begins receiving data.
// */
//- (void)doSubscribe:(OTStream*)stream
//{
//  _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
//  
//  OTError *error = nil;
//  [_session subscribe:_subscriber error:&error];
//  if (error)
//  {
//    [self showAlert:[error localizedDescription]];
//  }
//}
//
///**
// * Cleans the subscriber from the view hierarchy, if any.
// * NB: You do *not* have to call unsubscribe in your controller in response to
// * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
// * be automatically removed from the session during cleanup of the stream.
// */
//- (void)cleanupSubscriber
//{
//  [_subscriber.view removeFromSuperview];
//  _subscriber = nil;
//}
//
//# pragma mark - OTSession delegate callbacks
//
- (void)sessionDidConnect:(OTSession*)session
{
  NSLog(@"sessionDidConnect (%@)", session.sessionId);
//  
//  // Step 2: We have successfully connected, now instantiate a publisher and
//  // begin pushing A/V streams into OpenTok.
//  [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
  NSString* alertMessage =
  [NSString stringWithFormat:@"Session disconnected: (%@)",
   session.sessionId];
  NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}
//
//
- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
  NSLog(@"session streamCreated (%@)", stream.streamId);
  
  // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
  // have seen on the OpenTok session.
//  if (nil == _subscriber && !_subscribeToSelf)
//  {
//    [self doSubscribe:stream];
//  }
}
//
- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
  NSLog(@"session streamDestroyed (%@)", stream.streamId);
//  
//  if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
//  {
//    [self cleanupSubscriber];
//  }
}
//
//- (void)  session:(OTSession *)session
//connectionCreated:(OTConnection *)connection
//{
//  NSLog(@"session connectionCreated (%@)", connection.connectionId);
//}
//
//- (void)    session:(OTSession *)session
//connectionDestroyed:(OTConnection *)connection
//{
//  NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
//  if ([_subscriber.stream.connection.connectionId
//       isEqualToString:connection.connectionId])
//  {
//    [self cleanupSubscriber];
//  }
//}
//
- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
  NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
//  NSLog(@"subscriberDidConnectToStream (%@)",
//        subscriber.stream.connection.connectionId);
//  assert(_subscriber == subscriber);
//  [_subscriber.view setFrame:CGRectMake(0, _widgetHeight, _widgetWidth,
//                                        _widgetHeight)];
//  [self.view addSubview:_subscriber.view];
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
//  NSLog(@"subscriber %@ didFailWithError %@",
//        subscriber.stream.streamId,
//        error);
}
//
//# pragma mark - OTPublisher delegate callbacks
//
//- (void)publisher:(OTPublisherKit *)publisher
//    streamCreated:(OTStream *)stream
//{
//  // Step 3b: (if YES == subscribeToSelf): Our own publisher is now visible to
//  // all participants in the OpenTok session. We will attempt to subscribe to
//  // our own stream. Expect to see a slight delay in the subscriber video and
//  // an echo of the audio coming from the device microphone.
//  if (nil == _subscriber && _subscribeToSelf)
//  {
//    [self doSubscribe:stream];
//  }
//}
//
//- (void)publisher:(OTPublisherKit*)publisher
//  streamDestroyed:(OTStream *)stream
//{
//  if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
//  {
//    [self cleanupSubscriber];
//  }
//  
//  [self cleanupPublisher];
//}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
  NSLog(@"publisher didFailWithError %@", error);
  //[self cleanupPublisher];
}

- (void)showAlert:(NSString *)string
{
  // show alertview on main UI
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil] ;
    [alert show];
  });
}

@end
