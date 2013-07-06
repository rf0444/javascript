'use strict';
$(function() {
	var constant = function(x) { return function() { return x; }; };
	var mkButton = function(conf) {
		var el = $('<button />');
		var streams = {
			clicked: el.asEventStream('click'),
		};
		var properties = conf.f(streams);
		properties.text.assign(function(text) {
			el.text(text);
		});
		return { el: el };
	};
	var button = mkButton({
		f: function(streams) {
			return {
				text: streams.clicked
					.map(constant(1))
					.scan(0, function(a, b) { return a + b; }),
			};
		},
	});
	$('body').append(button.el);
});
