"use strict";
$(function() {
	var constant = function(x) { return function() { return x; }; };
	var mkButton = {
		streams: function() {
			return {
				clicked: new Bacon.Bus(),
			};
		},
		create: function(conf) {
			var el = $('<button />');
			conf.properties.text.assign(function(text) {
				el.text(text);
			});
			conf.streams.clicked.plug(el.asEventStream('click'));
			return { el: el };
		},
	};
	var streams1 = mkButton.streams();
	var streams2 = mkButton.streams();
	var logic = function(s) {
		return s.clicked
			.map(constant(1))
			.scan(0, function(a, b) { return a + b; });
	};
	var button1 = mkButton.create({
		properties: {
			text: logic(streams2),
		},
		streams: streams1,
	});
	var button2 = mkButton.create({
		properties: {
			text: logic(streams1),
		},
		streams: streams2,
	});
	$('body').append(button1.el).append(' ').append(button2.el);
});
