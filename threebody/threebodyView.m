//
//  threebodyView.m
//  threebody
//
//  Created by Aidan Nash on 15/01/2025.
//

#import "threebodyView.h"

@implementation threebodyView

// returns a body with these parameters:
- (instancetype)initWithPosition:(CGPoint)position velocity:(CGPoint)velocity mass:(CGFloat)mass radius:(CGFloat)radius color:(NSColor *)color {
    
    self = [super init];
    if (self) {
        self.position = position;
        self.velocity = velocity;
        self.mass = mass;
        self.radius = radius;
        self.color = color;
    }
    return self;
}

// returns the force enacting on a body from another body
- (CGPoint)calculateForceFromBody:(threebodyView *)otherBody {
    // gravitational constant made bigger for visible eeffects
    static const CGFloat G = 6.67430;
    
    // calculate x and y differencees between bodies
    CGPoint positionDiff = CGPointMake(otherBody.position.x - self.position.x,
                                       otherBody.position.y - self.position.y);
    
    // find diagonal distance between bodies
    CGFloat r = sqrt(positionDiff.x * positionDiff.x + positionDiff.y * positionDiff.y);

    // find magnitude of gravitational force between bodies using F = G * (m1*m2) / r^2
    CGFloat forceMagnitude = G * (self.mass * otherBody.mass) / (r * r);

    
    // break force into x and y components by using their x and y distances as a ratio
    CGFloat forceX = forceMagnitude * (positionDiff.x / r);
    CGFloat forceY = forceMagnitude * (positionDiff.y / r);
    
    // return force as a point (x and y)
    return CGPointMake(forceX, forceY);
}

// updates the position of a body depending on the force acting on it
- (void)updateWithForce:(CGPoint)force timeStep:(CGFloat)dt {
    // calculate acceleration from force
    CGFloat accelerationX = force.x / self.mass;
    CGFloat accelerationY = force.y / self.mass;
    
    // update velocity using a = dv/dt
    self.velocity = CGPointMake(
                                self.velocity.x + accelerationX * dt,
                                self.velocity.y + accelerationY * dt
                                );
    
    // update position using v = dx/dt
    self.position = CGPointMake(
                                self.position.x + self.velocity.x * dt,
                                self.position.y + self.velocity.y * dt
                                );
}




@end
