"use strict";
$(function() {
	var mkButton = function(f) {
		var button = $("<button />").css({ width: "80px" });
		var streams = {
			clicked: button.asEventStream("click"),
		};
		var properties = f(streams);
		properties.text.assign(function(text) { button.text(text); });
		return button;
	};
	var f1 = function(streams) {
		return {
			text: streams.clicked.map(1).scan(0, function(a, b) { return a + b; }).toProperty(),
		};
	};
	var f2 = function(streams) {
		return {
			text: streams.clicked.map(2).scan(1, function(a, b) { return a * b; }).toProperty(),
		};
	};
	$("#content")
		.append(mkButton(f1))
		.append("　-　")
		.append(mkButton(f2))
});
