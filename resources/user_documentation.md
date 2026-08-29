# User documentation

## About

Geometry is a Pharo library for representing basic geometric shapes (point, line, segment, ray, arc, circle, ellipse, polygon, rectangle, triangle, ...) and computing properties of them.

## Core concepts

Two families of entities exist:

- **Points and vectors** live in `Geometry-Core`: `GPoint`, `GVector`, `GMatrix`, `GAngle`, with Euclidean coordinates handled by `GCoordinates`, `G2DCoordinates` and `G3DCoordinates`.
- **Elements** are subclasses of `GElement`. 1D elements are subclasses of `G1DElement` (`GLine`, `GSegment`, `GRay`, `GArc`, `GPoint`); 2D shapes are subclasses of `GShape` (`GEllipse` and its subclass `GCircle`, `GPolygon` and its subclasses `GRectangle` and `GTriangle`).

## Points and vectors

```Smalltalk
p := GPoint x: 3 y: 4.                       "a GPoint(3,4)"
q := GPoint x: 0 y: 0.
p distanceTo: q.                             "5"
p + (GVector x: 1 y: 1).                     "a GPoint(4,5) — translated copy"
p - q.                                       "a GVector(3,4) — difference of two points"
(p x) -> (p y).                              "3 -> 4"
p asPoint.                                   "3@4 — convert to a plain Pharo point"
(1 @ 2) asGPoint.                            "convert a plain Pharo point"
```

Points are also elements, so you can ask `p1 segment: p2` to build a segment, and compute `p1 intersectionsWith: p2`.

Vectors support the usual arithmetic (`+`, `-`, `*`, `/`), `length`, `dotProduct:`, `angleWith:` and `nonOrientedAngleWith:`.

```Smalltalk
v1 := GVector x: 3 y: 4.
v2 := GVector x: 1 y: 0.
v1 length.                     "5"
v1 dotProduct: v2.             "3"
```

### Angles

`GAngle` wraps an angle in radians. Construction accepts degrees or radians (`rads` is used for radians; `radians` is deprecated to avoid a conflict with the `Units` package).

```Smalltalk
straight := GAngle degrees: 180.
right := GAngle radians: Float pi / 2.
right rads.                    "1.5707963267948966"
right isRight.                 "true"
straight isStraight.           "true"
straight isAcute. isObtuse. isReflex.
right sin, right cos, right tan.   "trigonometry"
```

### Matrices

`GMatrix` stores a 2D array of numbers.

```Smalltalk
m := GMatrix rows: { {1. 2}. {3. 4} }.
m at: 1 at: 1.                 "1"
m at: 2 at: 2.                 "4"
m determinant.                 "-2"
```

## 1D elements

`GLine`, `GSegment`, `GRay` and `GArc` are the 1D elements (points are covered above). Common API: `length`, `distanceTo:`, `translateBy:`, `intersectionsWith:`, `includes:`.

### Line

A line goes through two points and extends **infinitely** in both directions. `through:and:` only picks two points it passes through, the points do not bound it. Since it is infinite, `length` answers `Float infinity`.

```Smalltalk
line := GLine through: (GPoint x: 0 y: 0) and: (GPoint x: 3 y: 4).
vertical := GLine a: 1 b: 0 c: -1.     "general form a*x + b*y + c = 0 : x - 1 = 0"
line isParallelTo: vertical.
line angleWith: vertical.
```

### Segment

A segment is the **finite** piece of a line between two points: it starts at its first point (`v1`) and stops at its second (`v2`). `length` is the distance between the two points.

```Smalltalk
s := GSegment with: (GPoint x: 0 y: 0) with: (GPoint x: 3 y: 4).
s length.            "5"
s midPoint.          "a GPoint(3/2, 2)"
s perpendicularBisector.
s distanceTo: (GPoint x: 0 y: 2).
```

### Ray

A ray starts at its origin point (`initialPoint`) and goes **infinitely** in the direction of its `directionPoint` (the direction from `initialPoint` towards `directionPoint`). `length` answers `Float infinity`; `flipped` answers the opposite ray (same origin, reversed direction).

```Smalltalk
r := GRay origin: (GPoint x: 0 y: 0) direction: (GPoint x: 1 y: 1).
r flipped.           "the opposite ray"
r includes: (GPoint x: 2 y: 2).   "true"
```

### Arc

An arc is a **finite** portion of a circle's circumference: it lies on the circle of `center` with the arc's `origin` point on it, and spans the given `angle` (the angle between the vectors `center-origin` and `center-endPoint`). `length` is `radius * centralAngle`.

```Smalltalk
a := GArc center: (GPoint x: 0 y: 0) origin: (GPoint x: 3 y: 4) angle: (GAngle degrees: 90).
a radius.            "5"
a endPoint.          "the point at the end of the arc"
a centralAngle.
a length.            "arc length"
```

## 2D shapes

Shapes are closed 2D surfaces, so unlike 1D elements they have a `perimeter` and appear in an `encompassingRectangle`. Common `GShape` API: `perimeter`, `semiperimeter`, `center`, `extent`, `encompassingRectangle`, `fitInExtent:` and the inherited `translateBy:` / `intersectionsWith:`.

### Ellipse

An ellipse is the set of points whose sum of distances to two foci is constant. It is defined by a `center`, a `vertex` (an extremity of the major axis) and a `coVertex` (an extremity of the minor axis).

```Smalltalk
ellipse := GEllipse center: (GPoint x: 0 y: 0) vertex: (GPoint x: 5 y: 0) coVertex: (GPoint x: 0 y: 3).
ellipse area.                        "π * 5 * 3"
ellipse foci, fociLocation.
ellipse majorAxis, minorAxis.
ellipse semiMajorAxisLength, semiMinorAxisLength.
ellipse encompassingRectangle.
```

### Circle

A circle is the special case of an ellipse where both axes are equal: the set of points at a fixed `radius` from a `center`. `GCircle` is a subclass of `GEllipse`, so everything documented on the ellipse also works on a circle.

```Smalltalk
circle := GCircle center: (GPoint x: 0 y: 0) radius: 5.
circle perimeter.    "31.41592653589793"
circle radius.
circle includes: (GPoint x: 3 y: 4).   "true (boundaries included)"
```

### Polygon

A polygon is a closed chain of segments (the `edges`) between an ordered list of `vertices`: each edge goes from one vertex to the next, and the last vertex is joined back to the first. The vertices keep the order you give them with `GPolygon vertices: aCollection`.

```Smalltalk
polygon := GPolygon vertices: {
	(GPoint x: 0 y: 0).
	(GPoint x: 4 y: 0).
	(GPoint x: 4 y: 3).
	(GPoint x: 0 y: 3) }.
polygon edges.       "an OrderedCollection of GSegment"
polygon perimeter.   "14"
polygon encompassingRectangle.
```

Note:
- The convex hull of a collection of points is computed with `GPolygon convexHullOn: aCollection`.

### Rectangle

A rectangle is a polygon with four vertices whose edges are perpendicular and axis-aligned, defined by an origin and a corner (or its left/right/top/bottom bounds). It is a subclass of `GPolygon`.

```Smalltalk
rect := GRectangle origin: (GPoint x: 0 y: 0) corner: (GPoint x: 4 y: 3).
rect area.           "12"
rect width, rect height, rect extent, rect center.
rect diagonals.
```

### Triangle

A triangle is a polygon with exactly three vertices. It is a subclass of `GPolygon`.

```Smalltalk
triangle := GTriangle with: (GPoint x: 0 y: 0) with: (GPoint x: 4 y: 0) with: (GPoint x: 2 y: 3).
triangle area.                   "6"
triangle circumscribedCircle.
triangle isDegenerate.
```

## Intersections

Every element can compute its intersection points with any other element:

```Smalltalk
segment := GSegment with: (GPoint x: 0 y: 0) with: (GPoint x: 3 y: 4).
circle intersectionsWith: segment.     "a Set(a GPoint(3,4))"
segment intersectionsWith: circle.     "same result: double dispatch"
line intersectionsWith: line.
ellipse intersectionsWith: (GCircle center: (GPoint x: 0 y: 0) radius: 5).
```

- The message is symmetric: `a intersectionsWith: b` and `b intersectionsWith: a` answer the same collection of points.
- When there is no intersection the answer is an **empty collection** `{}` (not `nil`).
- Perform a membership test instead when you only need to know if a *point* lies on an element: `element includes: aPoint`.

## Membership tests

All `GElement`s answer the following point queries:

```Smalltalk
element includes: aPoint.            "true if the point is on the element, boundaries included"
element boundaryContains: aPoint.    "true if the point is on the boundary"
element contains: aPoint.            "true if included but NOT on the boundary"
```

`boundaryContainsAny:`, `boundaryContainsWhichOf:` accept collections of points. Note that for 1D elements (lines, segments, rays, arcs, points) `boundaryContains:` is equivalent to `includes:`, so `contains:` answers `false` always.

## Transformations

Be careful: `translateBy:` and `scaleBy:` **modify the receiver** in place. If you need to keep the original, work on a copy (`element copy translateBy: ...`). The exception is point arithmetic and rotation: `GPoint >> +` and `rotatedBy:` / `rotatedBy:about:` return a new point, while `rotateBy:` / `rotateBy:about:` change the receiver.

```Smalltalk
element translateBy: (GPoint x: 1 y: 1).   "or a GVector: any object with coordinates"
point rotatedBy: (GAngle degrees: 90).     "rotates around the origin; see rotatedBy:about: for an arbitrary center"
point rotateBy: (GAngle degrees: 90).      "same rotation, but changes the point"
polygon scaleBy: 2.                        "polygons only (rect, triangle); scales about center"
polygon fitInExtent: (10 @ 10).            "polygons and ellipses: rescale to fit inside a given extent"
```

`fitInExtent:` also modifies the receiver. Note `scaleBy:` exists only on `GPolygon`/`GRectangle`/`GTriangle`; ellipses expose no `scaleBy:`.

## Converting to and from plain Pharo objects

- `Point` is extended with `asGPoint` and `asGVector`, `Number` with the `=~` close-to operator.
- `GPoint >> asPoint` and `GCoordinates >> asGPoint` / `asGVector` convert back.

## A note on equality and floating point

Do not compare coordinates with `=`. Because results come from float arithmetic, equality is answered with the `=~` operator (a close-to comparison extended on `Number` and reused by `GPoint`, `GVector`, `GAngle`...):

```Smalltalk
(result x =~ expectedX) and: [ result y =~ expectedY ].
```