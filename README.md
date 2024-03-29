# Logbook

[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Logbook is a lightweight logging framework for iOS and iPadOS

## Features

- [x] Levels: Debug -> Error
- [x] Categories
- [x] Extendable Log Handler

## Basic usage

First setup `Logbook` by adding a LogSink

```
Logbook.add(sink: ConsoleLogSink())
```

Log some data

```
Logbook.debug("Hello Logbook")
Logbook.error("Hello Error")
```

## Advanced usage

Create a global variable for faster access.

```
let log = Logbook.self
```

```
log.debug("Hello Logbook")
```

### LogSinks

Filter logs by level.

```
ConsoleLogSink(level: .min(.warning))
ConsoleLogSink(level: .fix(.info))
```

Filter logs by category:

```
ConsoleLogSink(level: .min(.debug), categories: .include([.networking]))
```
or
```
ConsoleLogSink(level: .min(.debug), categories: .exclude([.networking]))
```

Add multiple sinks for different usecases:
```
// Log all with min level warning
Logbook.add(sink: ConsoleLogSink(level: .min(.warning)))

// Log only level error with category .networking
Logbook.add(sink: ConsoleLogSink(level: .fix(.error), categories: .include([.networking])))
```

### Formatting

Add custom dateFormatter to sink

```
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short

let console = ConsoleLogSink(level: .min(.debug), categories: .exclude([.networking]))
console.dateFormatter = dateFormatter
```

Add logging format to ConsoleLogSink

```
console.format = "\(LogPlaceholder.category) \(LogPlaceholder.date): \(LogPlaceholder.messages)"
```

### Custom LogSink

Create your custom sink by confirming LogSink protocol. 


### LogCategory

Extend LogCategory to create custom categories.

```
extension LogCategory {
    
    static let startup = LogCategory("startup", prefix: "🚦")
    static let bluetooth = LogCategory("bluetooth", prefix: "🖲")
    
}
```

```
log.debug("hello", category: .startup)
```


## Carthage

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "allaboutapps/Logbook"
```

Then run `carthage update`.

## Swift Package Manager

Use Xcode 11+:
Go to `Project > Swift Packages > +` and enter `https://github.com/allaboutapps/Logbook`

Or update your Package.swift file manually:

```swift
dependencies: [
.package(url: "git@github.com:allaboutapps/Logbook.git", from: "1.1"),
    ....
],
targets: [
    .target(name: "YourApp", dependencies: ["Logbook"]),
]
```

## Requirements

- Swift 5+

## Contributing

* Create something awesome, make the code better, add some functionality,
  whatever (this is the hardest part).
* [Fork it](http://help.github.com/forking/)
* Create new branch to make your changes
* Commit all your changes to your branch
* Submit a [pull request](http://help.github.com/pull-requests/)
