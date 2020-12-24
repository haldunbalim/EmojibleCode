//
//  OpenCVWrapper.h
//  EmojibleIOS
//
//  Created by Haldun Balim on 23.12.2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSMutableArray *) extractRois:(UIImage*)inputImage;
@end

NS_ASSUME_NONNULL_END
