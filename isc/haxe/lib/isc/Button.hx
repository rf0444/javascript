package lib.isc;

import lib.Bacon;

typedef Streams = {
	clicked: Bacon.Bus<Void>,
};
typedef Config = {
	streams: Streams,
	properties: {
		text: Bacon.Property<String>,
		disable: Bacon.Property<Bool>,
	},
	extra: Dynamic,
};
class Button {
	public static function streams(): Streams {
		return {
			clicked: Bacons.bus(),
		};
	}
	public static function create(conf: Config): Dynamic {
		var isc: Dynamic = untyped __js__("window.isc");
		var button: Dynamic = isc.IButton.create(params(conf));
		conf.properties.text.assign(function(text) {
			button.setTitle(text);
		});
		conf.properties.disable.assign(function(disable) {
			button.setDisabled(disable);
		});
		return button;
	}
	private static function params(conf: Config): Dynamic {
		var params: Dynamic = {};
		if (conf.extra != null) {
			for (fname in Reflect.fields(conf.extra)) {
				var val = Reflect.field(conf.extra, fname);
				if (val != null) {
					Reflect.setField(params, fname, val);
				}
			}
		}
		params.click = function() {
			conf.streams.clicked.push(null);
		};
		return params;
	}
}
