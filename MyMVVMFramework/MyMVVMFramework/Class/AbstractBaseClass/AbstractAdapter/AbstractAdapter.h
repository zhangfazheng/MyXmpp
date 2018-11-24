//
//  AbstractAdapter.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/4.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractAdapter : NSObject
/**
 *  输入数据
 */
@property (nonatomic, strong) id inputData;

/**
 *  Start data transform.
 */
- (void)startDataTransform;

/**
 *  输出数据
 */
@property (nonatomic, strong) id outputData;

@end
