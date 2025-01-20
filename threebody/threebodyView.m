//
//  threebodyView.m
//  threebody
//
//  Created by Aidan Nash on 15/01/2025.
//

#import "threebodyView.h"
#import "CelestialBody.h"

@implementation threebodyView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        // set it to 60 fps
        [self setAnimationTimeInterval:1/60.0];
        
        // initialise the bodies array
        self.bodies = [NSMutableArray array];
        
        // initialise the bodies (in a triangle)
        CelestialBody *body1 = [[CelestialBody alloc] initWithPosition:CGPointMake(600, 600)
                                                               velocity:CGPointMake(0, 120)
                                                                   mass:500
                                                                 radius:20
                                                                  color:[NSColor redColor]];
        
        CelestialBody *body2 = [[CelestialBody alloc] initWithPosition:CGPointMake(800, 600)
                                                               velocity:CGPointMake(0, 0)
                                                                   mass:700
                                                                 radius:30
                                                                  color:[NSColor blueColor]];
        
        CelestialBody *body3 = [[CelestialBody alloc] initWithPosition:CGPointMake(1000, 600)
                                                               velocity:CGPointMake(0, -120)
                                                                   mass:500
                                                                 radius:25
                                                                  color:[NSColor greenColor]];
        
        [self.bodies addObjectsFromArray:@[body1, body2, body3]];
    }
    return self;
}


- (void)animateOneFrame {
    
    NSRect bounds = [self bounds]; // Get the bounds of the view

    
    CelestialBody *body1 = self.bodies[0];
    CelestialBody *body2 = self.bodies[1];
    CelestialBody *body3 = self.bodies[2];
    
    
    // BODY 1
    // calculate force on A from B
    CGPoint ForceOnAFromB = [body1 calculateForceFromBody:self.bodies[1]];
    
    // calculate force on A from C
    CGPoint ForceOnAFromC = [body1 calculateForceFromBody:self.bodies[2]];
    
    // resolve the forces
    CGPoint ForceA = CGPointMake(ForceOnAFromB.x + ForceOnAFromC.x, ForceOnAFromB.y + ForceOnAFromC.y);
    
    // update the position of A
    [body1 updateWithForce:ForceA timeStep:1.0/60.0];
    
    
    //BODY 2
    // calculate force on B from A
    CGPoint ForceOnBFromA = [body2 calculateForceFromBody:self.bodies[0]];
    
    // calculate force on B from C
    CGPoint ForceOnBFromC = [body2 calculateForceFromBody:self.bodies[2]];
    
    // resolve the forces
    CGPoint ForceB = CGPointMake(ForceOnBFromA.x + ForceOnBFromC.x, ForceOnBFromA.y + ForceOnBFromC.y);
    
    // update the position of B
    [body2 updateWithForce:ForceB timeStep:1.0/60.0];
    
    
    // BODY 3
    // calculate force on C from B
    CGPoint ForceOnCFromB = [body3 calculateForceFromBody:self.bodies[1]];
    
    // calculate force on C from A
    CGPoint ForceOnCFromA = [body3 calculateForceFromBody:self.bodies[0]];
    
    // resolve the forces
    CGPoint ForceC = CGPointMake(ForceOnCFromB.x + ForceOnCFromA.x, ForceOnCFromB.y + ForceOnCFromA.y);
    
    // update the position of C
    [body3 updateWithForce:ForceC timeStep:1.0/60.0];
    
    
    
    for (CelestialBody *body in self.bodies) {
        
        [body updateTrail];
        
        // Check for boundary collisions and adjust the position if necessary
        if (body.position.x - body.radius < -400) {
            body.position = CGPointMake(body.radius, body.position.y);
            body.velocity = CGPointMake(-body.velocity.x / 10, body.velocity.y); // Reverse X velocity
        } else if (body.position.x + body.radius > bounds.size.width + 400) {
            body.position = CGPointMake(bounds.size.width - body.radius, body.position.y);
            body.velocity = CGPointMake(-body.velocity.x / 10, body.velocity.y); // Reverse X velocity
        }
        
        if (body.position.y - body.radius < -400) {
            body.position = CGPointMake(body.position.x, body.radius);
            body.velocity = CGPointMake(body.velocity.x, -body.velocity.y / 10); // Reverse Y velocity
        } else if (body.position.y + body.radius > bounds.size.height + 400) {
            body.position = CGPointMake(body.position.x, bounds.size.height - body.radius);
            body.velocity = CGPointMake(body.velocity.x, -body.velocity.y / 10); // Reverse Y velocity
        }
    }

    // tell the view it needs to redraw
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    CelestialBody *body1 = self.bodies[0];
    CelestialBody *body2 = self.bodies[1];
    CelestialBody *body3 = self.bodies[2];
    
    // create and fill a circle at the body's position
    [self drawTrailForBody:body1];
    [self drawTrailForBody:body2];
    [self drawTrailForBody:body3];
    NSRect body1Rect = NSMakeRect(body1.position.x - body1.radius,
                                  body1.position.y - body1.radius,
                                  body1.radius *2,
                                  body1.radius * 2);
    [body1.color set];
    [[NSBezierPath bezierPathWithOvalInRect:body1Rect] fill];
    
    
    NSRect body2Rect = NSMakeRect(body2.position.x - body2.radius,
                                  body2.position.y - body2.radius,
                                  body2.radius *2,
                                  body2.radius * 2);
    [body2.color set];
    [[NSBezierPath bezierPathWithOvalInRect:body2Rect] fill];

    
    NSRect body3Rect = NSMakeRect(body3.position.x - body3.radius,
                                  body3.position.y - body3.radius,
                                  body3.radius *2,
                                  body3.radius * 2);
    [body3.color set];
    [[NSBezierPath bezierPathWithOvalInRect:body3Rect] fill];
    
}

- (void)drawTrailForBody:(CelestialBody *)body {
    NSBezierPath *trailPath = [NSBezierPath bezierPath];
    
    // Only use every nth point to draw the path
    NSInteger step = 5; // Draw every 5th point
    for (NSInteger i = 0; i < body.trailPositions.count; i += step) {
        CGPoint position = [body.trailPositions[i] pointValue];
        if (i == 0) {
            [trailPath moveToPoint:position];
        } else {
            [trailPath lineToPoint:position];
        }
    }
    
    [body.color set];
    [trailPath stroke];
}




@end
