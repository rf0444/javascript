"use strict";
$(function() {
	var mkButton = function() {
		var button = $("<button />").css({ width: "80px" });
		var streams = {
			clicked: button.asEventStream("click"),
		};
		return {
			el: button,
			streams: streams,
			assignProperties: function(properties) {
				properties.text.assign(function(text) { button.text(text); });
			},
		};
	};
	var mkContent = function(f) {
		var b1 = mkButton();
		var b2 = mkButton();
		var streams = {
			b1: b1.streams,
			b2: b2.streams,
		};
		var properties = f(streams);
		b1.assignProperties(properties.b1);
		b2.assignProperties(properties.b2);
		var el = $("<div />").append(b1.el).append("　-　").append(b2.el);
		return {
			el: el,
			streams: streams,
			properties: properties,
		};
	};
	var f = function(streams) {
		return {
			b1: {
				text: streams.b2.clicked.map(1).scan(0, function(a, b) { return a + b; }).toProperty(),
			},
			b2: {
				text: streams.b1.clicked.map(1).scan(0, function(a, b) { return a + b; }).toProperty(),
			},
		};
	};
	var content = mkContent(f);
	$("#content").append(content.el);
	window.content = content;
});
