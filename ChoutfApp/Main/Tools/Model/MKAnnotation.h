//
//  MKAnnotation.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/8/30.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MKAnnotation : NSObject<MKAnnotation>


@property(nonatomic,assign)CLLocationCoordinate2D coordinate;

@property(nonatomic,copy)NSString*title;

@property(nonatomic,copy)NSString*subtitle;



@end

NS_ASSUME_NONNULL_END
