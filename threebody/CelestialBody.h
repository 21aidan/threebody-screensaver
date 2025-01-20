//
//  CelestialBody.h
//  threebody
//
//  Created by Aidan Nash on 19/01/2025.
//


#import <Cocoa/Cocoa.h>

@interface CelestialBody: NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGFloat mass;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) NSColor *color;

//methods
- (instancetype)initWithPosition:(CGPoint)position
                        velocity:(CGPoint)velocity
                            mass:(CGFloat)mass
                          radius:(CGFloat)radius
                           color:(NSColor *)color;

- (CGPoint)calculateForceFromBody:(CelestialBody *)otherBody;

- (void)updateWithForce:(CGPoint)force timeStep:(CGFloat)dt;

@end
