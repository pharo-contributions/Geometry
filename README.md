# Geometry

[![Coverage Status](https://coveralls.io/repos/github/pharo-contributions/Geometry/badge.svg?branch=master)](https://coveralls.io/github/pharo-contributions/Geometry?branch=master) [![CI](https://github.com/pharo-contributions/Geometry/actions/workflows/build.yml/badge.svg)](https://github.com/pharo-contributions/Geometry/actions/workflows/build.yml)

A library for representing basic geometry shapes (line, circle, ellipse, ...) and doing some computations of top (mainly intersection).

The original repository is: http://smalltalkhub.com/#!/~NataliaTymchuk/Geometry

## Install Geometry

To install Geometry on your Pharo image you can just execute the following script:

```Smalltalk
    Metacello new
    	githubUser: 'pharo-contributions' project: 'Geometry' commitish: 'v1.x.x' path: 'src';
    	baseline: 'Geometry';
    	load
```

To add Geometry to your baseline just add this:

```Smalltalk
    spec
    	baseline: 'Geometry'
    	with: [ spec repository: 'github://pharo-contributions/Geometry:v1.x.x/src' ]
```

Note that you can replace the v2.x.x tag by a branch as #master or #development or a tag as #v1.0.0, #v1.? or #v1.0.x or a commit SHA.

## Quick start

Once installed, the shapes are regular Smalltalk objects. Everything below is runnable in a Playground.

```Smalltalk
"Create some shapes"
aPoint := GPoint x: 0 y: 0.
aSegment := GSegment with: (GPoint x: 0 y: 0) with: (GPoint x: 3 y: 4).
aCircle := GCircle center: (GPoint x: 0 y: 0) radius: 5.

"Compute their intersections (answer is a collection of points)"
aCircle intersectionsWith: aSegment.   "a Set(a GPoint(3,4))"
aSegment intersectionsWith: aCircle.   "same result"

"Test membership and query metrics"
aCircle includes: (GPoint x: 3 y: 4).     "true: the point is on the circle"
aCircle perimeter.                        "31.41592653589793"
aSegment length.                          "5"
```

All elements share the same API (`includes:`, `intersectionsWith:`, `translateBy:`, `length`/`perimeter`/`area`, ...). The full guide, including a description of every shape, is in [resources/user_documentation.md](resources/user_documentation.md).

## Version management 

This project use semantic versionning to define the releases. This mean that each stable release of the project will get associate a version number of the form `vX.Y.Z`. 

- **X** define the major version number
- **Y** define the minor version number 
- **Z** define the patch version number

When a release contains only bug fixes, the patch number increase. When the release contains new features backward compatibles, the minor version increase. When the release contains breaking changes, the major version increase. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

