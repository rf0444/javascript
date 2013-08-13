package lib.jquery;

import lib.Bacon;

class Hash {
	public static function changed(): EventStream<String> {
		return window().asEventStream("hashchange").map(function() {
			return js.Browser.window.location.hash.substring(1);
		});
	}
	public static function assignTo(property: Property<String>) {
		property.assign(function(hash) {
			var current = js.Browser.window.location.hash;
			if (current == hash || current == "#" + hash) {
				forceChanged();
				return;
			}
			js.Browser.window.location.hash = hash;
		});
	}
	private static function window(): Dynamic {
		return untyped __js__("$(window)");
	}
	public static function forceChanged() {
		window().trigger("hashchange");
	}
}
