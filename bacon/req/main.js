"use strict";
$(function() {
	var constant = function(x) { return function() { return x; }; };
	var id = function(x) { return x; };
	var left = function(x) { return function(f, g) { return f(x); }; };
	var right = function(x) { return function(f, g) { return g(x); }; };
	
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
			conf.properties.enable.assign(function(enable) {
				el.attr('disabled', !enable);
			});
			conf.streams.clicked.plug(el.asEventStream('click'));
			return { el: el };
		},
	};
	var mkTextarea = function(conf) {
		var el = $('<textarea />');
		conf.val.assign(function(text) {
			el.val(text);
		});
		return { el: el };
	};
	
	var input = $('<input type="text" />').width(400);
	var bs = mkButton.streams();
	var request = bs.clicked.map(function() { return input.val(); });
	var response = request.flatMapLatest(function(url) {
		return Bacon.fromPromise($.get(url))
			.map(right)
			.mapError(function(e) { return left(e.responseText); })
		;
	});
	var button = mkButton.create({
		properties: {
			text: Bacon.constant('request'),
			enable: Bacon.once(true)
				.merge(request.map(constant(false)))
				.merge(response.map(constant(true)))
				.toProperty(),
		},
		streams: bs,
	});
	var output = mkTextarea({
		val: response.map(function(r) { return r(function(msg) { return 'error - ' + msg; }, id); })
			.toProperty(),
	});
	$('body')
		.append($('<p />')
			.append(input)
			.append(' ')
			.append(button.el)
		)
		.append($('<p />').append(output.el.width(500).height(200)))
	;
});
