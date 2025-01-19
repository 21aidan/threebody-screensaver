//
//  threebodyView.h
//  threebody
//
//  Created by Aidan Nash on 15/01/2025.
//

#import <ScreenSaver/ScreenSaver.h>
#import "CelestialBody.h"

@interface threebodyView : ScreenSaverView

// array of the bodies
@property (nonatomic, strong) NSMutableArray<CelestialBody *> *bodies;

@end
