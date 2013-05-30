"use strict";
$(function() {
	var mkButton = {
		streams: function() {
			return {
				clicked: new Bacon.Bus(),
			};
		},
		view: function(properties, streams) {
			var button = $("<button />").css({ width: "80px" });
			properties.text.assign(function(text) { button.text(text); });
			streams.clicked.plug(button.asEventStream("click"));
			return {
				el: button,
				children: {},
	 		};
		},
	};
	var mkContent = {
		streams: function() {
			return {
				buttons: {
					b1: mkButton.streams(),
					b2: mkButton.streams(),
				},
			};
		},
		view: function(properties, streams) {
			var buttons = {
				b1: mkButton.view(properties.buttons.b1, streams.buttons.b1),
				b2: mkButton.view(properties.buttons.b2, streams.buttons.b2),
			};
			var el = $("<div />").attr("id", "content")
				.append(buttons.b1.el)
				.append("　-　")
				.append(buttons.b2.el);
			return {
				el: el,
				children: {
					buttons: buttons,
				},
	 		};
		},
	};
	var mkApp = function(f) {
		var streams = mkContent.streams();
		var properties = f(streams);
		var view = mkContent.view(properties, streams);
		return {
			view: view,
			streams: streams,
			properties: properties,
		};
	};
	var app = mkApp(function(streams) {
		var buttons = {
			b1: {
				text: streams.buttons.b2.clicked.map(1).scan(0, function(a, b) { return a + b; }).toProperty(),
			},
			b2: {
				text: streams.buttons.b1.clicked.map(1).scan(0, function(a, b) { return a + b; }).toProperty(),
			},
		};
		return {
			buttons: buttons,
		};
	});
	$("body").append(app.view.el);
	window.app = app;
});
