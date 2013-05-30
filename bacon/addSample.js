"use strict";
$(function() {
	var eq = function(x, y) {
		return x.a === y.a && x.b === y.b && x.c === y.c;
	};
	var mkField = {
		streams: function() {
			return {
				changed: new Bacon.Bus(),
			};
		},
		view: function(properties, streams) {
			var el = $("<input type='number' />");
			var value = function() {
				return Number(el.val());
			};
			var property = Bacon.UI.textFieldValue(el).map(value);
			properties.value.assign(function(val) { el.val(val); });
			streams.changed.plug(property.sampledBy(property));
			return {
				el: el,
				children: {},
				value: value,
	 		};
		},
	};
	var mkContent = {
		streams: function() {
			return {
				changed: new Bacon.Bus(),
				fields: {
					a: mkField.streams(),
					b: mkField.streams(),
					c: mkField.streams(),
				},
			};
		},
		view: function(properties, streams) {
			var fields = {
				a: mkField.view(properties.fields.a, streams.fields.a),
				b: mkField.view(properties.fields.b, streams.fields.b),
				c: mkField.view(properties.fields.c, streams.fields.c),
			};
			var el = $("<div />").attr("id", "content").append(
				$("<p />")
					.append(fields.a.el)
					.append("　+　")
					.append(fields.b.el)
					.append("　=　")
					.append(fields.c.el)
			);
			var value = function() {
				return {
					a: fields.a.value(),
					b: fields.b.value(),
					c: fields.c.value(),
				};
			};
			streams.changed.plug(
				streams.fields.a.changed
					.merge(streams.fields.b.changed)
					.merge(streams.fields.c.changed)
					.map(value)
			);
			return {
				el: el,
				children: {
					fields: fields,
				},
				value: value,
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
		var initValues = { a: 0, b: 0, c: 0 };
		var changes = streams.changed
			.skipDuplicates(eq)
			.scan(initValues, function(previous, current) {
				var diffs = {
					a: current.a - previous.a,
					b: current.b - previous.b,
					c: current.c - previous.c,
				};
				return {
					a: current.a + diffs.c,
					b: current.b,
					c: current.a + current.b + diffs.c,
				};
			});
		return {
			fields: {
				a: {
					value: changes.map(function(values) { return values.a; }).toProperty(),
				},
				b: {
					value: changes.map(function(values) { return values.b; }).toProperty(),
				},
				c: {
					value: changes.map(function(values) { return values.c; }).toProperty(),
				},
			},
		};
	});
	$("body").append(app.view.el);
	window.app = app;
});
