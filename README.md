# Dial Once - Cordova plugin

This is a plugin that allows your Cordova or PhoneGap app to easily integrate the Dial Once SDK.

## Supported platforms

- Android
- iOS (coming soon)


## Installation

The Dial Once SDK is brought in automatically. There is no need to change or add anything in your code source. 

### Cordova

To install the plugin in your Cordova app, run the following command:

    $ cordova plugin add cordova-plugin-dialonce --variable ANDROID_API_KEY='<ANDROID_API_KEY>'

### PhoneGap

To add the plugin to your PhoneGap app, add the following snippet to your `config.xml`:

```xml
<gap:plugin name="cordova-plugin-dialonce" source="npm">
  <param name="ANDROID_API_KEY" value="<ANDROID_API_KEY>" />
</gap:plugin>
```

## Getting Started with Cordova

The Cordova command line tooling is based on node.js so first you’ll need to install node then you can install Cordova by executing:

	$ npm install -g cordova

### Create the App

Create a new app by executing:

	$ cordova create <project-name> [app-id] [app-name]

### Add platform(s)

Specify a set of target platforms by executing:

	$ cordova platform add <platform>

> The only available platform at the moment is Android, iOS is coming soon.

### Install the plugin

Install the dialonce-cordova plugin by executing:

	$ cordova plugin add cordova-plugin-dialonce --variable ANDROID_API_KEY='<ANDROID_API_KEY>'


## Example

	# Create initial Cordova app
	$ cordova create myApp
	$ cd myApp/
	$ cordova platform add android
	$ cordova plugin add cordova-plugin-dialonce --variable ANDROID_API_KEY='<ANDROID_API_KEY>'
