package page;

import lib.Bacon;
import lib.isc.*;

import page.Page;

using lib.Functions;

private typedef Directory = {
	id: Int,
	parentId: Null<Int>,
	name: String,
}
private typedef Element = {
	name: String,
	status: String,
}
class Grids {
	public static function create(conf: PageConf): Page {
		conf.properties.params.log();
		var directories = [
			{ id: 1, parentId: null, name: "hoge" },
			{ id: 2, parentId: 1, name: "hoge hoge" },
			{ id: 3, parentId: null, name: "piyo" },
			{ id: 4, parentId: 1, name: "hoge piyo" },
			{ id: 5, parentId: 3, name: "piyo hoge" },
			{ id: 6, parentId: 2, name: "hoge hoge hoge" },
			{ id: 7, parentId: null, name: "bar" },
			{ id: 8, parentId: 3, name: "piyo piyo" },
			{ id: 9, parentId: 1, name: "hoge xxx" },
		];
		var lists = [
			1 => [
				{ name: "hoge", status: "normal" },
			],
			3 => [],
			4 => [
				{ name: "aaa", status: "normal" },
				{ name: "bbb", status: "error" },
				{ name: "ccc", status: "normal" },
				{ name: "ddd", status: "normal" },
				{ name: "eee", status: "error" },
			],
			7 => [
				{ name: "abcde", status: "normal" },
				{ name: "fg", status: "normal" },
			],
			9 => [
				{ name: "xxx", status: "error" },
			],
		];
		var directorySize = function(directory) {
			var list = lists.get(directory.id);
			return if (list == null) 0 else list.length; 
		};
		
		var treeSelected: Bus<Directory> = Bacons.bus();
		var listSelected: Bus<Element> = Bacons.bus();
		
		var isc: Dynamic = untyped __js__("window.isc");
		var treeView = isc.TreeGrid.create({
			data: isc.Tree.create({
				modelType: "parent",
				data: directories,
			}),
			nodeClick: function(viewer, node) {
				treeSelected.push(node);
			},
			fields: [
				{ name: "name", title: "Name" },
				{ name: "size", title: "List Size", width: "60px",
					formatCellValue: function(value, record) { return directorySize(record); }
				},
			],
			folderIcon: "[SKIN]folder.png",
			nodeIcon: "[SKIN]folder_open.png",
			width: "100%", height: "100%"
		});
		var listView = isc.ListGrid.create({
			fields: [
				{ name: "name", title: "Name" },
				{ name: "status", title: "Status" },
			],
			recordClick: function(viewer, record) {
				listSelected.push(record);
			},
			width: "100%", height: "100%",
		});
		var detailView = isc.ListGrid.create({
			fields: [
				{ name: "name", title: "Name" },
				{ name: "status", title: "Status" },
			],
			width: "100%", height: "100%",
		});
		
		treeSelected.assign(function(data) {
			var list = lists.get(data.id);
			listView.setData(if (list == null) [] else list);
			detailView.setData([]);
		});
		listSelected.assign(function(data) {
			detailView.setData([data]);
		});
		
		var view = isc.HLayout.create({
			width: "100%", height: "100%", visibility: "hidden",
			members: [
				isc.VLayout.create({
					width: "20%", height: "100%", showResizeBar: true,
					members: [ treeView ],
				}),
				isc.VLayout.create({
					width: "80%", height: "100%",
					members: [
						isc.HLayout.create({
							width: "100%", height: "90%", showResizeBar: true,
							members: [ listView ],
						}),
						isc.HLayout.create({
							width: "100%", height: "10%",
							members: [ detailView ],
						}),
					],
				}),
			],
		});
		return { view: view, hashChange: Bacons.Bacon.never() };
	}
}
