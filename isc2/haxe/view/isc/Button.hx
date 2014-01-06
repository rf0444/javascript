package view.isc;

import lib.Bacon;

typedef Streams = {
	clicked: Bus<Void>,
};
typedef Factory = {
	create: Dynamic -> Dynamic
};
class Button implements View {
	public var view: Dynamic;
	public var streams: Streams;
	function new(button: Dynamic, streams: Streams) {
		this.view = button;
		this.streams = streams;
	}
	public static function create(factory: Factory, conf: Dynamic): Button {
		var streams = {
			clicked: Bacons.bus(),
		};
		var button: Dynamic = factory.create(params(conf, streams));
		return new Button(button, streams);
	}
	private static function params(conf: Dynamic, streams: Streams): Dynamic {
		var params: Dynamic = {};
		for (fname in Reflect.fields(conf)) {
			var val = Reflect.field(conf, fname);
			if (val != null) {
				Reflect.setField(params, fname, val);
			}
		}
		params.click = function() {
			streams.clicked.push(null);
		};
		if (conf.click != null) {
			streams.clicked.assign(conf.click);
		}
		return params;
	}
}
