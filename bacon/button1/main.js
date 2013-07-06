'use strict';
$(function() {
	var constant = function(x) { return function() { return x; }; };
	var mkButton = function(conf) {
		var el = $('<button />').text(conf.text);
		return {
			el: el,
			streams: {
				clicked: el.asEventStream('click'),
			},
		};
	};
	var mkText = function(conf) {
		var el = $('<span />');
		conf.text.assign(function(text) {
			el.text(text);
		});
		return { el: el };
	};
	var button = mkButton({
		text: 'click',
	});
	var text = mkText({
		text: button.streams.clicked
			.map(constant(1))
			.scan(0, function(a, b) { return a + b; }),
	});
	$('body').append(button.el).append(' ').append(text.el);
});
