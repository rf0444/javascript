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
Ext.define('Sample.view.Window', {
	extend: 'Ext.window.Window',
	width: 600,
	height: 400,
	layout: 'fit',
	closable: true,
	closeAction: 'hide',
	plain: true,
	modal: true,
	title: 'Sample Window',
	items: [{
		xtype: 'panel',
		title: 'sample',
		bodyPadding: 10,
		layout: 'fit',
		items: [{
			xtype: 'SampleList',
			itemId: 'sampleList3',
			title: 'List 3',
		}]
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
		views.window = Ext.create('Sample.view.Window');
		return views;
	},
});
