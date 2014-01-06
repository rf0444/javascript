package main;

class Main {
	public static function main() {
		var isc: Dynamic = untyped __js__("window.isc");
		isc.setAutoDraw(false);
		
		var button = isc.Button.create({
			width: "100%", height: "100%",
			title: "Hello World!",
		});
		var view = isc.VLayout.create({
			width: "100%", height: "100%",
			members: [
				button,
			],
		});
		view.draw();
	}
}
