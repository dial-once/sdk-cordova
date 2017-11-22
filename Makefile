ANDROID_API_KEY=OWNkY2RkODZiNDA1MjY5YjE2ZTc3ZDMzODEwNWZmNDM6OmIwMjYwMjllYWVhYjc5MzQxYjdkOWZjNDMyYzdlMTc3NDNjNTdjZTE=
BUILD_DIR=$(PWD)/build
TESTAPP_PATH=$(BUILD_DIR)/sample
TESTPLUGIN_PATH=$(BUILD_DIR)/plugin

.PHONY: prereq test sample build clean

deps:
	npm install -g cordova
	echo y | android update sdk --no-ui --all --filter tools
	echo y | $(ANDROID_HOME)/tools/bin/sdkmanager "platforms;android-26" "build-tools;26.0.1" "system-images;android-24;google_apis;armeabi-v7a" "extras;google;m2repository" tools emulator
	yes | $(ANDROID_HOME)/tools/bin/sdkmanager --licenses	

# plugin target need to avoid ENAMETOOLONG during plugin copy
$(TESTPLUGIN_PATH):
	mkdir -p $(TESTPLUGIN_PATH)
	cp -r src www package.json plugin.xml $(TESTPLUGIN_PATH)/

$(TESTAPP_PATH): $(TESTPLUGIN_PATH)
	mkdir -p $(TESTAPP_PATH)
	cordova create $(TESTAPP_PATH) com.dialonce.cordova.test DialCordova
	cd $(TESTAPP_PATH); cordova platform add android
	cd $(TESTAPP_PATH); cordova -d plugin add $(TESTPLUGIN_PATH) --variable ANDROID_API_KEY=$(ANDROID_API_KEY)

	# compatibility test
	cd $(TESTAPP_PATH); cordova plugin add cordova-plugin-splashscreen \
		cordova-plugin-device@1.1.1 \
		cordova-plugin-file-opener2@2.0.19 \
		cordova-plugin-geolocation@1.0.1 \
		cordova-plugin-inappbrowser@1.5.0 \
		cordova-plugin-network-information@1.2.1 \
		cordova-plugin-splashscreen@4.0.0 \
		cordova-plugin-statusbar@2.0.0 \
		cordova-plugin-whitelist@1.0.0 \
		cordova-plugin-file@4.3.3 \
		ionic-plugin-keyboard@2.0.1 \
		cordova-plugin-android-permissions@1.0.0 \
		cordova-plugin-apprate@1.3.0
	cd $(TESTAPP_PATH); cordova plugin add cordova-plugin-crosswalk-webview@2.2.0 --variable XWALK_VERSION=20 --variable XWALK_COMMANDLINE=--disable-pull-to-refresh-effect --variable XWALK_MODE=embedded

sample: $(TESTAPP_PATH)

build: sample
	cd $(TESTAPP_PATH); cordova build android
	mkdir -p $(PWD)/build/sdk
	zip build/sdk/cordova-plugin-dialonce-$(shell date "+%d-%m-%Y").zip -r src www package.json plugin.xml README.md

publish:
	npm login
	npm publish .

clean:
	rm -rf build
