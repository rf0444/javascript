package main;

import lib.Bacon;

using Lambda;
using lib.Functions;

private typedef Conf = {
	public var contents: Map<String, Dynamic>;
	public var defaultContent: String;
	public var stream: EventStream<String>;
}
class Main {
	public static function main() {
		var samples = {
			top: page.Top.create(),
			buttons: page.Buttons.create(),
			grids: page.Grids.create(),
		};
		var pages = createTabs({
			contents: [
				"/samples/top" => samples.top.view,
				"/samples/buttons" => samples.buttons.view,
				"/samples/grids" => samples.grids.view,
			],
			defaultContent: "/samples/top",
			stream: lib.jquery.Hash.changed(),
		});
		lib.jquery.Hash.assignTo(
			Bacons.Bacon.mergeAll([
				samples.top.hashChange,
				samples.buttons.hashChange,
				samples.grids.hashChange,
				pages.redirect,
			]).toProperty()
		);
		lib.jquery.Hash.forceChanged();
	}

	static function createTabs(conf: Conf): Dynamic {
		var isc: Dynamic = untyped __js__("window.isc");
		var view = isc.Layout.create({
			width: "100%", height: "100%",
			members: conf.contents.array(),
		});
		conf.stream
			.map(function(path) { return conf.contents.get(path); })
			.filter(function(content) { return content != null; })
			.assign(function(content) { view.setVisibleMember(content); })
		;
		return {
			view: view,
			redirect: conf.stream
				.filter(function(path) { return !conf.contents.exists(path); })
				.map(Functions.constant(conf.defaultContent)),
		};
	}
}
