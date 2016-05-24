# AtomicPropertiesPlayground

## Overview
Swift doesn't have atomic properties like Objective C does. This implementation uses
Grand Central Dispatch serial queues to synchronize read and writes to the protected variable. 
Each instance is randomly assigned a serial queue when it's instantiated and all reads and writes to the 
underlying protected variable is synchronized through the serial queue.

## Usage
```Swift

let atomic = AtomicProperty("Foo")
atomic.value //"Foo"
atomic.value = "Bar"
atomic.value //"Bar"

let atomic_opt = AtomicOptionalProperty<String>()
atomic_opt.value //nil
atomic_opt.value = "Foo Bar"
atomic_opt.value //"Foo Bar"
```
