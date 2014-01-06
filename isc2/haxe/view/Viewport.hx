package view;

import view.isc.Button;

class Viewport implements View {
	public var view: Dynamic;
	public var button: Button;
	function new() {
		var isc: Dynamic = untyped __js__("window.isc");
		this.button = Button.create(isc.Button, {
			width: "100%", height: "100%",
			title: "Hello World!",
		});
		this.view = isc.VLayout.create({
			width: "100%", height: "100%",
			members: [
				button.view,
			],
		});
	}
	public static function createViewport(): Viewport {
		return new Viewport();
	}
}
