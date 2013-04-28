"use strict";
$(function() {
	function InputView(el, bus) {
		var me = this;
		me.el = el;
		bus.plug(
			me.el.asEventStream("change")
				.map(function() { return me.el.val(); })
				.merge(Bacon.once(me.el.val()))
				.map(Number)
		);
	}
	function OutputView(el, bus) {
		var me = this;
		me.el = el;
		bus.assign(function(val) {
			me.el.text(val);
		});
	}
	function Model() {
		var me = this;
		me.a = new Bacon.Bus();
		me.b = new Bacon.Bus();
		me.c = new Bacon.Bus();
		me.c.plug(
			Bacon.combineWith(function(a, b) { return a + b; }, me.a, me.b).changes()
		);
	}
	var model = new Model();
	var a = new InputView($("#val1"), model.a);
	var b = new InputView($("#val2"), model.b);
	var c = new OutputView($("#val3"), model.c);
});
