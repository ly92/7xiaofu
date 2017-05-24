#import "BasicMapAnnotation.h"
#import "MHTransformCorrdinate.h"

@interface BasicMapAnnotation()

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end

@implementation BasicMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize titles = _titles;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
    
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
    
    coordinate =  [MHTransformCorrdinate getGoogleLocFromBaiduLocLat:self.latitude lng:self.longitude] ;

	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    newCoordinate =  [MHTransformCorrdinate transformFromWGSToGCJ:newCoordinate] ;
    
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
