var argscheck = require('cordova/argscheck');
var channel = require('cordova/channel');
var utils = require('cordova/utils');
var exec = require('cordova/exec');
var cordova = require('cordova');
console.log('linea start')
function LineaProCDV() {
  this.results = [];
  this.connCallback = null;
  this.errorCallback = null;
  this.cancelCallback = null;
  this.cardDataCallback = null;
  this.barcodeCallback = null;
}

console.log('linea 2')
LineaProCDV.prototype.initDT = function(connectionCallback, cardCallback, barcCallback, cancelCallback, errorCallback) {
  this.results = [];
  this.connCallback = connectionCallback;
  this.cardDataCallback = cardCallback;
  this.barcodeCallback = barcCallback;
  exec(null, errorCallback, "LineaProCDV", "initDT", []);
};

LineaProCDV.prototype.barcodeStart = function() {
  exec(null, null, "LineaProCDV", "startBarcode", []);
};

LineaProCDV.prototype.barcodeStop = function() {
  exec(null, null, "LineaProCDV", "stopBarcode", []);
};

LineaProCDV.prototype.connectionChanged = function(state) {
  this.connCallback(state);
};

LineaProCDV.prototype.onMagneticCardData = function(jsonStringData) {
  this.cardDataCallback(JSON.parse(jsonStringData));
};

LineaProCDV.prototype.onBarcodeData = function(jsonStringData) {
  this.barcodeCallback(JSON.parse(jsonStringData));
};

/*
  getters
    getAutoOffWhenIdle
    getBatteryCapacity
    getBatteryInfo
    getConnectedDeviceBatteryInfo
    getConnectedDeviceInfo
    getKioskMode
    getCharging
    getPassThroughSync
    getUSBChargeCurrent
    getSupportedFeature
    getTimeRemainingToPowerOff
 */
LineaProCDV.prototype.getData = function(dataType, callbackFunction = null) {
  exec(callbackFunction, callbackFunction, "LineaProCDV", 'get' + dataType, []);
};

/*
  setters
    setAutoOffWhenIdle
    setKioskMode
    setCharging
    setPassThroughSync
    setUSBChargeCurrent
 */
LineaProCDV.prototype.setData = function(dataType, dataValue) {
  exec(null, null, "LineaProCDV", 'set' + dataType, [dataValue]);
};
console.log('linea 3')

module.exports = new LineaProCDV();
console.log('linea 4')
