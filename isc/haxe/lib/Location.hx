package lib;

import lib.Bacon;

typedef LocationProperties = {
	public var hash: Property<String>;
}
typedef LocationStreams = {
	public var hash: Bus<String>;
}
typedef Conf = {
	public var properties: LocationProperties;
	public var streams: LocationStreams;
}
class Location {
	public static function streams(): LocationStreams {
		return {
			hash: Bacons.bus(),
		};
	}
	public static function assign(conf: Conf) {
		conf.streams.hash.plug(hashChanged());
		assignHash(conf.properties.hash);
	}
	private static function hashChanged(): EventStream<String> {
		return window().asEventStream("hashchange").map(function() {
			return js.Browser.window.location.hash.substring(1);
		});
	}
	private static function assignHash(property: Property<String>) {
		property.assign(function(hash) {
			var current = js.Browser.window.location.hash;
			if (current == hash || current == "#" + hash) {
				forceHashChanged();
				return;
			}
			js.Browser.window.location.hash = hash;
		});
	}
	private static function window(): Dynamic {
		return untyped __js__("$(window)");
	}
	public static function forceHashChanged() {
		window().trigger("hashchange");
	}
}
