package page;

import lib.Bacon;
import lib.isc.*;

import page.Page;

using Lambda;
using lib.Functions;

private typedef Directory = {
	id: Int,
	parentId: Null<Int>,
	name: String,
}
private typedef Element = {
	id: Int,
	name: String,
	status: String,
	directoryId: Int,
}
class Grids {
	public static function create(conf: PageConf): Page {
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
		var lists = createLists([
			{ id: 1, name: "hoge", status: "normal", directoryId: 1 },
			{ id: 2, name: "aaa", status: "normal", directoryId: 4 },
			{ id: 3, name: "bbb", status: "error", directoryId: 4 },
			{ id: 4, name: "ccc", status: "normal", directoryId: 4 },
			{ id: 5, name: "ddd", status: "normal", directoryId: 4 },
			{ id: 6, name: "eee", status: "error", directoryId: 4 },
			{ id: 7, name: "abcde", status: "normal", directoryId: 7 },
			{ id: 8, name: "fg", status: "normal", directoryId: 7 },
			{ id: 9, name: "xxx", status: "error", directoryId: 9 },
		]);
		
		var treeSelected: Bus<Directory> = Bacons.bus();
		var listSelected: Bus<Element> = Bacons.bus();
		
		var isc: Dynamic = untyped __js__("window.isc");
		var directorySize = function(directory) {
			var list = lists.get(directory.id);
			return if (list == null) 0 else list.length; 
		};
		var treeView: Dynamic = isc.TreeGrid.create({
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
		var listView: Dynamic = isc.ListGrid.create({
			fields: [
				{ name: "name", title: "Name" },
				{ name: "status", title: "Status" },
			],
			recordClick: function(viewer, record) {
				listSelected.push(record);
			},
			width: "100%", height: "100%",
		});
		var detailView: Dynamic = isc.ListGrid.create({
			fields: [
				{ name: "name", title: "Name" },
				{ name: "status", title: "Status" },
			],
			width: "100%", height: "100%",
		});
		var expandAncestors = Functions.fix(function(rec) {
			return function(tree: Directory) {
				if (tree.parentId == null) {
					return;
				}
				var parent: Directory = treeView.data.findById(tree.parentId);
				treeView.openFolder(parent);
				rec(parent);
			};
		});
		var setList = function(list: List<Element>) {
			listView.setData(if (list == null) [] else list.array());
			detailView.setData([]);
		};
		conf.properties.params.changes()
			.map(function(params) { return params[1]; })
			.filter(Functions.notNull)
			.map(function(param) {
				var ps = param.split("/");
				var node = treeView.data.findById(ps[1]);
				return { tree: node, list: ps[2] };
			})
			.filter(function(eles) { return eles.tree != null; })
			.doAction(function(eles) {
				var tree = eles.tree;
				expandAncestors(tree);
				treeView.selectSingleRecord(tree);
				treeView.openFolder(tree);
				setList(lists.get(tree.id));
			})
			.map(function(eles) {
				var list = listView.data.find("id", eles.list);
				return { tree: eles.tree, list: list };
			})
			.filter(function(eles) { return eles.list != null; })
			.doAction(function(eles) {
				listView.selectSingleRecord(eles.list);
				detailView.setData([eles.list]);
			})
			.assign()
		;
		
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
		var hash = Bacons.Bacon.mergeAll([
			treeSelected.map(function(data) { return '/samples/grids/${data.id}'; }),
			listSelected.map(function(data) { return '/samples/grids/${data.directoryId}/${data.id}'; }),
		]);
		return { view: view, hashChange: hash };
	}
	private static function createLists(eles: Array<Element>): Map<Int, List<Element>> {
		var ret = new Map();
		for (ele in eles) {
			var key = ele.directoryId;
			var list = ret.get(key);
			if (list == null) {
				list = new List();
				ret.set(key, list);
			}
			list.add(ele);
		}
		return ret;
	}
}
