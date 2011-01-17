// shortcut.m
// 
// compile:
// gcc shortcut.m -o shortcut.bundle -g -framework Foundation -framework Carbon -dynamiclib -fobjc-gc -arch i386 -arch x86_64

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface Shortcut : NSObject
{
    id delegate;
}
@property (assign) id delegate;
- (void) addShortcut;
- (void) hotkeyWasPressed:(NSString *)message;
@end
OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);


@implementation Shortcut
@synthesize delegate;

OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData)
{    
    EventHotKeyID hkCom;
    GetEventParameter(anEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,sizeof(hkCom),NULL,&hkCom);
    int l = hkCom.id;
    NSString* hkString = [NSString stringWithFormat:@"%d", l];
    NSLog(@"%@", hkString);
     
    if ( userData != NULL ) {
        id delegate = (id)userData;
        if ( delegate && [delegate respondsToSelector:@selector(hotkeyWasPressed:)] ) {
          [delegate hotkeyWasPressed:hkString];
        }
    }
    return noErr;
}

- (void) addShortcut
{
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID prevHotKeyID;
    EventHotKeyID nextHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    if ( delegate == nil )
      delegate = self;
    EventTargetRef eventTarget = (EventTargetRef) GetEventMonitorTarget();
    InstallEventHandler(eventTarget, &myHotKeyHandler, 1, &eventType, (void *)delegate, NULL);
    prevHotKeyID.signature='phk1';
    prevHotKeyID.id=1;
    nextHotKeyID.signature='nhk1';
    nextHotKeyID.id=2;
    RegisterEventHotKey(123, cmdKey+controlKey, prevHotKeyID, eventTarget, 0, &myHotKeyRef);
    RegisterEventHotKey(124, cmdKey+controlKey, nextHotKeyID, eventTarget, 0, &myHotKeyRef);
}

- (void) hotkeyWasPressed:(NSString *)message {
  NSLog(@"%@", message);
  NSLog(@"%@","AHHA");
};

@end

void Init_shortcut(void) {}