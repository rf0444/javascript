package page;

import lib.Bacon;
import lib.isc.*;

using lib.Functions;

class Top {
	public static function create(): Page {
		var button = function(s, p, e: Dynamic) {
			return Button.create({
				streams: s,
				properties: {
					text: p,
					disable: Bacons.Bacon.never().toProperty(),
				},
				extra: e,
			});
		};
		var s1 = Button.streams();
		var button1 = button(s1, Bacons.Bacon.constant("-> button sample"), { width: "100%", height: "80px" });
		
		var isc: Dynamic = untyped __js__("window.isc");
		var view = isc.VLayout.create({
			width: "100%", height: "100%", visibility: "hidden",
			members: [
				button1,
			],
		});
		var hash = Bacons.Bacon.mergeAll([
			s1.clicked.map(Functions.constant("/samples/buttons")),
		]);
		return { view: view, hashChange: hash };
	}
}
