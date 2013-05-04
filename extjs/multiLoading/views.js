"use strict";
Ext.define('Sample.view.Viewport', {
	extend: 'Ext.container.Viewport',
	layout: 'border',
	items: [{
		xtype: 'SampleList',
		itemId: 'sampleList1',
		title: 'List 1',
		region: 'west',
		flex: 1,
	}, {
		xtype: 'SampleList',
		itemId: 'sampleList2',
		title: 'List 2',
		region: 'center',
		flex: 1,
	}],
});
Ext.define('Sample.view.SampleList', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.SampleList',
	store: {
		fields: ['item'],
	},
	columns: [{
		header: 'item',
		dataIndex: 'item',
		flex: 1,
	}],
});
Ext.define('Sample.views', {
	create: function() {
		var views = {};
		views.viewport = Ext.create('Sample.view.Viewport');
		return views;
	},
});
