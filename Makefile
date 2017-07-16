ANDROID_API_KEY=OWNkY2RkODZiNDA1MjY5YjE2ZTc3ZDMzODEwNWZmNDM6OmIwMjYwMjllYWVhYjc5MzQxYjdkOWZjNDMyYzdlMTc3NDNjNTdjZTE=
TESTAPP_PATH=$(PWD)/build/sample

.PHONY: prereq test sample build clean

prereq:
	npm install -g cordova

$(TESTAPP_PATH):
	mkdir -p $(TESTAPP_PATH)
	cordova create $(TESTAPP_PATH) com.dialonce.cordova.test DialCordova
	cd $(TESTAPP_PATH); cordova platform add android
	cd $(TESTAPP_PATH); cordova plugins add cordova-plugin-splashscreen
	cd $(TESTAPP_PATH); cordova plugin add $(PWD) --variable ANDROID_API_KEY=$(ANDROID_API_KEY)

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
