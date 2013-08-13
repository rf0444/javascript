package page;

import lib.Bacon;

typedef Page = {
	public var view: Dynamic;
	public var hashChange: EventStream<String>;
};
