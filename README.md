# TelstraProficiency
This is a simple facts project which uses MVVM pattern which makes a decoupled and testable architecture. 
It was developed on Xcode 12.2 and supports iOS version 12.

## Project Specifications
- iOS 12.0+
- Xcode 12.2
- Swift 5

## Externel Libraries used 
- No third party API's were consumed.

## Requirements
### iOS side
• Ingests a json feed https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json
• You can use a third party Json parser to parse this if desired.
• Displays the content (including image, title and description) in a table
• The title in the navbar should be updated from the json
• Each row should be the right height to display its own content and no taller. No content should be clipped. This means some rows will be larger than others.
• Don’t download all images at once, only as needed
• Refresh function, either a refresh button or use pull down to refresh.
• Should not block UI when loading the data from the json feed.
• Support all iOS versions from the latest back at least 2 versions

### Limitations:

1) All the codes are fully testable using Unit and UI testing. But, due to lack of time, haven't been tested.
2) Loading screen on the main service call and table image loading is missing due concentrating quickly on the functionalities.
3) Testing on all devices is not done due to time limitations.


