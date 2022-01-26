# Fipper-python-sdk
A client library for Swift (SDK)

Fipper.io - a feature toggle (aka feature flags) software. More info https://fipper.io

## Install via Swift Package Manager
Add a dependency into your project: `https://github.com/Fipper-io/fipper-swift-sdk`

## Example

A code snippet that describes how to obtain data from Fipper.io:
```swift
import fipper_swift_sdk

let rate = Rate.normal
let environment = "production"
let apiToken = "" // Replace with your API key
let projectId = 0 // Replace with your project id

let fipper = Fipper(rate: rate, environment: environment, apiToken: apiToken, projectId: projectId)

fipper.getConfig { config, error in
    if let config = config {
        print("Config: \(config)")
        
        guard let flag = config["my_feature_flag"] else {
            print("my_feature_flag is unavailable.")
            return
        }
        
        print("my_feature_flag is available: \(flag)")
    } else if let error = error {
        print("Error: \(error)")
    } else {
        fatalError("Config and error both are nil.")
    }
}
```

More information and more client libraries: https://docs.fipper.io
