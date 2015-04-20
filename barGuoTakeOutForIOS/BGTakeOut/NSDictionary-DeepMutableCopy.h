

#import <Foundation/Foundation.h>

/**
 * @brief NSDictionary 深拷贝分类
 */
@interface NSDictionary(DeepMutableCopy)

/**
 * @brief NSDictionary深拷贝
 */
-(NSMutableDictionary *)mutableDeepCopy;
@end
