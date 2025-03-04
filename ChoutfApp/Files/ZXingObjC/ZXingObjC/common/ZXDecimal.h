/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Drop-in replacement for `NSDecimalNumber`.
 * @see ZXPDF417DecodedBitStreamParser.m#L696
 */
#import <Foundation/Foundation.h>

@interface ZXDecimal : NSObject

@property (nonatomic, strong, readonly) NSString *value;

- (id)initWithValue:(NSString *)value;

+ (ZXDecimal *)zero;
+ (ZXDecimal *)decimalWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
+ (ZXDecimal *)decimalWithString:(NSString *)string;
+ (ZXDecimal *)decimalWithInt:(int)integer;

- (ZXDecimal *)decimalByMultiplyingBy:(ZXDecimal *)number;
- (ZXDecimal *)decimalByAdding:(ZXDecimal *)number;

@end
