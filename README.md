# iOS Assessment Project

## Overview

You will be creating an app to ingest location data via HTTP encoded in [GeoJSON format](https://geojson.org), display the locations on a map as annotations/markers, and allow users to view information about them.

Your work is evaluated based on 1) overall software design, 2) code quality, and 3) conformity to requirements.

## Delivery

Fork this repo to your account and when you have completed the project, send an email to your recruiter or us with the URL to your fork to let us know that it's ready to review.

## Head start

The template project contains all the UI you'll need to fulfill the requirements:

- `MainViewController` contains:
	 - a `MKMapView`;
	 - a method for adding annotations/markers to the map;
	 - some basic implementation for presenting `DetailViewController` when the user taps on an annotation/marker.
- `DetailViewController` contains:
	- a `UITableView`;
	- some basic implementation for presenting a few cells.

## Requirements

- Ingest GeoJSON from the URL mentioned in [Resources](#resources) and render these markers on the map view when the app starts or resumes.
- A single tap on an marker should present the three nearest annotations/markers.
- The markers should be represented by their location name and their distance (in miles) to the tapped marker. Precision: two decimal places. Sorted: ascending by distance.
- Distances should be calculated using the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula).
- Handle network failure conditions and inform the user of failures and allow them to retry the request.

### Tests

- Unit tests are required.
- 100% code coverage is not required.
- UI tests are not required.

#### Test Dependencies

We have included the test dependencies we use on our project. If you are familiar with one or more of these, feel free to use them. Otherwise, use `XCTest` (your decision here will not affect your evaluation).

## <a name="resources"></a>External Resources

Please use this endpoint which returns a GeoJSON `FeatureCollection`: [https://assets.acmeaom.com/interview-project/locations.json](https://assets.acmeaom.com/interview-project/locations.json)

The GeoJSON content will always be a feature collection of features, with each feature having a geometry type of `Point`, a `name` property, and a unique `ID`.

### Example Feature from GeoJSON

```javascript
  {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [
        -67.09898354941409,
        45.042099781891125
      ]
    },
    "properties": {
      "name": "NAME"
    },
    "id": "UNIQUE_STRING"
  }
```

## Constraints:

- Use Swift.
- Use UIKit.
- Use Git.
- No third-party dependencies or code other than those included in the template project.
- No beta APIs.

## Assumptions:

- Custom-designed assets are not necessary.
- Caching or storage of data is not necessary.

## License

By delivering your completed project to us, you grant us a temporary license to use the code internally solely for reviewing/evaluating your work.
