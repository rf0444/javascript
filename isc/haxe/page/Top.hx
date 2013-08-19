package page;

import lib.Bacon;
import lib.isc.*;

import page.Page;

using lib.Functions;

class Top {
	public static function create(conf: PageConf): Page {
		var mkButton = function(title) {
			var s = Button.streams();
			var button = Button.create({
				streams: s,
				properties: {
					text: Bacons.Bacon.constant("-> " + title),
					disable: Bacons.Bacon.never().toProperty(),
				},
				extra: { width: "100%", height: "80px" },
			});
			return {
				streams: s,
				button: button,
			};
		};
		var samples = {
			button: mkButton("button sample"),
			grid: mkButton("tree / grid sample"),
		};
		var isc: Dynamic = untyped __js__("window.isc");
		var view = isc.VLayout.create({
			width: "100%", height: "100%", visibility: "hidden",
			members: [
				samples.button.button,
				samples.grid.button,
			],
		});
		var hash = Bacons.Bacon.mergeAll([
			samples.button.streams.clicked.map(Functions.constant("/samples/buttons")),
			samples.grid.streams.clicked.map(Functions.constant("/samples/grids")),
		]);
		return { view: view, hashChange: hash };
	}
}
