"use strict";
$(function() {
	function View(el) {
		var me = this;
		me.property = Bacon.UI.textFieldValue(el, 0).map(Number);
		
		me.obus = new Bacon.Bus();
		me.obus.plug(me.property.sampledBy(me.property));
		
		me.ibus = new Bacon.Bus();
		me.ibus.assign(function(val) { el.val(val); });
	}
	function Model() {
		var me = this;
		me.a = new Bacon.Bus();
		me.b = new Bacon.Bus();
		me.c = new Bacon.Bus();
		me.c.plug(
			Bacon.combineWith(function(a, b) { return a + b; }, me.a, me.b)
				.sampledBy(me.a.merge(me.b))
				.skipDuplicates()
		);
		me.b.plug(
			Bacon.combineWith(function(a, c) { return c - a; }, me.a, me.c)
				.sampledBy(me.c)
				.skipDuplicates()
		);
	}
	function App(conf) {
		var model = conf.model;
		var views = conf.views;
		// output first
		views.a.ibus.plug(model.a);
		views.b.ibus.plug(model.b);
		views.c.ibus.plug(model.c);
		// input last
		model.a.plug(views.a.obus);
		model.b.plug(views.b.obus);
		model.c.plug(views.c.obus);
	}
	new App({
		model: new Model(),
		views: {
			a: new View($("#val1")),
			b: new View($("#val2")),
			c: new View($("#val3")),
		},
	});
});
