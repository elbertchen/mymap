//
//  mymapViewController.h
//  mymap
//
//  Created by 陈洪 on 15/8/31.
//  Copyright (c) 2015年 chenhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapLocation.h"

@interface mymapViewController : UIViewController<CLLocationManagerDelegate,MKReverseGeocoderDelegate, MKMapViewDelegate>
@property (strong, nonatomic)    CLLocationManager* locationManager;
@property (retain, nonatomic) IBOutlet UILabel *longitudeText;
@property (retain, nonatomic) IBOutlet UILabel *latituduText;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
-(IBAction)findMe:(id)sender;
-(IBAction)webMap:(id)sender;
@end
