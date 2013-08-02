package hello;

import lib.Bacon;
import lib.Either;
import lib.Maybe;

using lib.Functions;
using lib.Either.Eithers;
using lib.Maybe.Maybes;

class Main {
	static function main() {
		trace(Either.Left(1).either(Functions.id, Functions.constant(10)));
		trace(Maybes.wrap(1).maybe(0, Functions.id));
		trace(Bacons.Bacon);
		trace(Bacons.bus());
		
		var isc: Dynamic = untyped __js__("window.isc");
		trace(isc);
		var button = isc.IButton.create({
			title: "hello",
		});
		trace(button);
	}
}
