"use strict";
$(function() {
	function View(el) {
		this.property = Bacon.UI.textFieldValue(el, 0).map(Number);
		this.ibus = new Bacon.Bus();
		this.obus = new Bacon.Bus();
		this.ibus.plug(this.property.sampledBy(this.property));
		this.obus.assign(function(val) { el.text(val); });
	}
	function Model() {
		var me = this;
		me.a = new Bacon.Bus();
		me.b = new Bacon.Bus();
		me.c = new Bacon.Bus();
		var pc = Bacon.combineWith(function(a, b) { return a + b; }, me.a, me.b);
		me.c.plug(pc.sampledBy(pc));
	}
	function App(conf) {
		var model = conf.model;
		var views = conf.views;
		model.a.plug(views.a.ibus);
		model.b.plug(views.b.ibus);
		views.c.obus.plug(model.c);
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
