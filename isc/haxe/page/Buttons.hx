package page;

import lib.Bacon;
import lib.isc.*;

import page.Page;

using lib.Functions;

class Buttons {
	public static function create(conf: PageConf): Page {
		var s1 = Button.streams();
		var s2 = Button.streams();
		var s3 = Button.streams();
		var p = function(s: Button.Streams, t) {
			return s.clicked
				.map(Functions.constant(1))
				.scan(0, function(a, b) { return a + b; })
				.map(Std.string)
				.map(function(str) { return t + str; })
			;
		};
		var p1 = p(s3, "header: ");
		var p2 = p(s1, "nav: ");
		var p3 = p(s2, "content: ");
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
		var button1 = button(s1, p1, { width: "100%", height: "40px" });
		var button2 = button(s2, p2, { width: "20%", height: "100%", showResizeBar: true });
		var button3 = button(s3, p3, { width: "100%", height: "100%" });
		
		var isc: Dynamic = untyped __js__("window.isc");
		var view = isc.VLayout.create({
			width: "100%", height: "100%", visibility: "hidden",
			members: [
				button1,
				isc.HLayout.create({
					members: [ button2, button3 ],
				})
			],
		});
		return { view: view, hashChange: Bacons.Bacon.never() };
	}
}
