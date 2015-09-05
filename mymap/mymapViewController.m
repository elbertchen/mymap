//
//  mymapViewController.m
//  mymap
//
//  Created by 陈洪 on 15/8/31.
//  Copyright (c) 2015年 chenhong. All rights reserved.
//

#import "mymapViewController.h"
@implementation CLLocationManager (TemporaryHack)

- (void)hackLocationFix
{
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    float latitude = 30.212112;
    float longitude = 120.10569199999998;  //这里可以是任意的经纬度值
    CLLocation *location= [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];
}

- (void)startUpdatingLocation
{
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
}
@end

@interface mymapViewController ()

@end

@implementation mymapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.mapType = MKMapTypeStandard;
    //mapView.mapType = MKMapTypeSatellite;
    //mapView.mapType = MKMapTypeHybrid;
    _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findMe:(id)sender {
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
    [_activity startAnimating];
    NSLog(@"start gps");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _latituduText.text = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
    _longitudeText.text = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
    //[mapView setRegion:viewRegion animated:YES];
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    manager.delegate = nil;
    [manager stopUpdatingLocation];
    
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geocoder.delegate = self;
    [geocoder start];
    
    [_activity stopAnimating];
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    
    MapLocation *annotation = [[MapLocation alloc] init];
    annotation.streetAddress = placemark.thoroughfare;
    annotation.city = placemark.locality;
    annotation.state = placemark.administrativeArea;
    annotation.zip = placemark.postalCode;
    annotation.coordinate = geocoder.coordinate;
    [_mapView addAnnotation:annotation];
    
    [annotation release];
    geocoder.delegate = nil;
    [geocoder autorelease];
    
    [_activity stopAnimating];
    _activity.hidden = YES;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"地理解码错误息"
                          message:@"地理代码不能识别"
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    geocoder.delegate = nil;
    [geocoder autorelease];
    
    [_activity stopAnimating];
}
#pragma mark Map View Delegate Methods
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if(annotationView == nil) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"PIN_ANNOTATION"] autorelease];
    }
    annotationView.canShowCallout = YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.animatesDrop = YES;
    annotationView.highlighted = YES;
    annotationView.draggable = YES;
    return annotationView;
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"地图加载错误"
                          message:[error localizedDescription]
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)findMe2:(id)sender {
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    [lm startUpdatingLocation];
    
    _activity.hidden = NO;
    [_activity startAnimating];
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}
@end
