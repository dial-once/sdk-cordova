var exec = require('cordova/exec');

var dialonce = {
	isCallInterceptionEnabled: true,

    init: function(apiKey, displayInterstitial) {
        exec(null, null, "DialOnce", "init", [apiKey, displayInterstitial]);
    },

    /**
     * Request permissions to ensure the SDK to work properly
     */
    requestPermissions: function() {
        exec(null, null, "DialOnce", "requestPermissions", []);
    },

    setEnableCallInterception: function(enabled) {
    	exec(null, null, "DialOnce", "setEnableCallInterception", [enabled]);
    	this.isCallInterceptionEnabled = enabled;
    },

    setDebug: function(enabled) {
        exec(null, null, "DialOnce", "setDebug", [enabled]);
    }
};

module.exports = dialonce;
