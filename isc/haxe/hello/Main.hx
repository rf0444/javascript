package hello;

import lib.Bacon;

using lib.Bacon.Bacons;

class Main {
	static function main() {
		var bacon: Bacon = untyped __js__("window.Bacon");
		var isc: Dynamic = untyped __js__("window.isc");
		
		trace(bacon.bus());
		
		trace(isc);
		var button = isc.IButton.create({
			title: "hello",
		});
		trace(button);
	}
}
