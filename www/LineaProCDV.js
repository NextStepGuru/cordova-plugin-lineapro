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

LineaProCDV.prototype.onMagneticCardData = function(trackData) {
  var tracks = trackData.split(',')
  this.cardDataCallback({track1: tracks[0], track2: tracks[1], track3: tracks[2]});
};

LineaProCDV.prototype.onBarcodeData = function(barcodeScanArr) {
  var data = { barcode: barcodeScanArr[0] }
  this.barcodeCallback(data);
};

module.exports = new LineaProCDV();
