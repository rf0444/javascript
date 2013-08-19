package page;

import lib.Bacon;

typedef PageConf = {
	properties: {
		params: Property<Array<String>>,
	},
}
typedef Page = {
	public var view: Dynamic;
	public var hashChange: EventStream<String>;
}
