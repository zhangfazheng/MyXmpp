//
//  PhyUtility.h
//  AretePop
//
//  Created by Asterisk on 13. 6. 19..
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//无法用xcode进行调试，或者用GDB查看NSLog的输出,通过重定向，将标准的错误输出stderr定向到文件
@interface Utility : NSObject

@end

@interface NSString (NSStringHexToBytes)
- (NSData*) hexStringToBytes;
@end
@interface NSString (NSStringToHex)
- (NSData*) stringToHex;
@end

@interface NSData (NSDataToHexString)
- (NSString*) bytesToHexString;
@end

@interface UIApplication (Logging)
+ (void) redirectConsoleLogToDocumentFolder:(NSString*)filename;
@end
