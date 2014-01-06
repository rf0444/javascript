package main;

import view.Viewport;

using lib.Functions;

class Main {
	public static function main() {
		var isc: Dynamic = untyped __js__("window.isc");
		isc.setAutoDraw(false);
		var app = App.createApp();
		app.draw();
		untyped __js__("window.app = app");
	}
}

class App {
	public var viewport: Viewport;
	function new() {
		this.viewport = Viewport.createViewport();
	}
	public static function createApp(): App {
		var app = new App();
		control(app);
		return app;
	}
	static function control(app: App) {
		var clickCount = app.viewport.button.streams.clicked
			.map(Functions.constant(1))
			.scan(0, function(a, b) { return a + b; })
			.changes()
			.map(Std.string)
		;
		var titleOf = DSL.titleOf;
		
		titleOf(app.viewport.button).is(clickCount);
	}
	public function draw() {
		this.viewport.view.draw();
	}
}
class DSL {
	public static function titleOf(view: view.View) {
		var toTitle = function(text) { view.view.setTitle(text); };
		return {
			is: function(property) { property.assign(toTitle); }
		}
	}
}
