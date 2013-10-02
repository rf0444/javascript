package page;

import lib.Bacon;
import lib.isc.*;

import page.Page;

using Lambda;
using lib.Functions;

class BigGrid {
	public static function create(conf: PageConf): Page {
		var fieldNum = 300;
		var dataNum = 10000;
		
		var fields: Array<Dynamic> = [];
		for (i in 1 ... fieldNum + 1) {
			fields.push({ name: "column_" + i, title: i + "th field", width: "200px" });
		}
		var data: Array<Dynamic> = [];
		for (i in 1 ... dataNum + 1) {
			var x: Dynamic = { id: i };
			for (j in 1 ... fieldNum + 1) {
				Reflect.setField(x, "column_" + j, i + " - " + j);
			}
			data.push(x);
		}
		
		var isc: Dynamic = untyped __js__("window.isc");
		var toolbar: Dynamic = isc.Canvas.create({
			width: "100%", height: "60px",
		});
		var list: Dynamic = isc.ListGrid.create({
			fields: fields,
			width: "100%", height: "100%",
		});
		list.setData(data);
		
		var view = isc.VLayout.create({
			width: "100%", height: "100%",
			members: [
				toolbar,
				isc.HLayout.create({
					width: "100%", height: "100%",
					members: [ list ],
				}),
			],
		});
		return { view: view, hashChange: Bacons.Bacon.never() };
	}
}
