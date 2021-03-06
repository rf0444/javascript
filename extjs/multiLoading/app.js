"use strict";
Ext.Loader.setConfig({
	enabled: true,
	paths: {
		'Sample': '.'
	}
});
Ext.application({
	name: 'SampleMain',
	requires: ['Sample.views'],
	launch: function() {
		var views = Ext.create('Sample.views').create();
		var list1 = views.viewport.down('#sampleList1');
		var list2 = views.viewport.down('#sampleList2');
		var list3 = views.window.down('#sampleList3');
		list1.setLoading(true);
		list2.setLoading(true);
		views.window.show();
		list3.setLoading(true);
	}
});

