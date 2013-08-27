package main;

import lib.Bacon;

import page.Page;

using Lambda;
using lib.Functions;

private typedef Conf = {
	public var contents: Map<String, PageConf -> Page>;
	public var defaultContent: String;
	public var hash: EventStream<String>;
}
class Main {
	public static function main() {
		var isc: Dynamic = untyped __js__("window.isc");
		isc.setAutoDraw(false);
		
		var location = lib.Location.streams();
		var pages = createTabs({
			contents: [
				"/samples/top" => page.Top.create,
				"/samples/buttons" => page.Buttons.create,
				"/samples/grids(/.*)?" => page.Grids.create,
			],
			defaultContent: "/samples/top",
			hash: location.hash,
		});
		lib.Location.assign({ properties: { hash: pages.hash }, streams: location });
		lib.Location.forceHashChanged();
		pages.view.draw();
	}
	static function createTabs(conf: Conf): Dynamic {
		var contents = conf.contents.keys().iterable().map(function(key) {
			var pattern = "^" + key + "$";
			var match = function(str) {
				var matched: Null<Array<String>> = untyped __js__("str.match(pattern)");
				return matched;
			};
			var create: PageConf -> Page = conf.contents.get(key);
			var params: Bus<Array<String>> = Bacons.bus();
			var sparams: EventStream<Array<String>> = params;
			var content = create({ properties: { params: sparams.toProperty() } });
			return { content: content, match: match, params: params };
		});
		var hashChanges = Bacons.Bacon.mergeAll(
			contents.map(function(content) { return content.content.hashChange; }).array()
		);
		
		var isc: Dynamic = untyped __js__("window.isc");
		var view = isc.Layout.create({
			width: "100%", height: "100%",
			members: contents
				.map(function(content) { return content.content.view; })
				.array(),
		});
		
		var getContent = function(path) {
			for (content in contents) {
				var matched = content.match(path);
				if (matched == null) {
					continue;
				}
				return { content: content, params: matched };
			}
			return null;
		};
		var currentContent = conf.hash.map(getContent);
		currentContent.filter(Functions.notNull).assign(function(content) {
			view.setVisibleMember(content.content.content.view);
			content.content.params.push(content.params);
		});
		var notFound = currentContent.filter(function(x) { return x == null; })
			.map(Functions.constant(conf.defaultContent))
		;
		return {
			view: view,
			hash: Bacons.Bacon.mergeAll([ notFound, hashChanges ]).toProperty(),
		};
	}
}
