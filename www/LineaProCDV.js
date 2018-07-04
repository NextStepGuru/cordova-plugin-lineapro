var argscheck = require('cordova/argscheck'),
  channel = require('cordova/channel'),
  utils = require('cordova/utils'),
  exec = require('cordova/exec'),
  cordova = require('cordova');

 function LineaProCDV() {
  this.results = [];
  this.connCallback = null;
  this.errorCallback = null;
  this.cancelCallback = null;
  this.cardDataCallback = null;
  this.barcodeCallback = null;
}

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

LineaProCDV.prototype.onMagneticCardData = function(track1, track2, track3) {
  this.cardDataCallback({track1: track1, track2: track2, track3: track3});
  // this.barcodeStart();
};

LineaProCDV.prototype.onBarcodeData = function(barcodeScanArr, barcodeType) {
  this.barcodeCallback({ barcodeScanArr: barcodeScanArr, barcodeType: barcodeType });
};

module.exports = new LineaProCDV();
