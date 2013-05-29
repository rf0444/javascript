"use strict";
$(function() {
	var mkButton = function(property) {
		var button = $("<button />").css({ width: "80px" });
		property.assign(function(text) { button.text(text); });
		return button;
	};
	var p1 = Bacon.constant(0);
	var p2 = Bacon.constant(0);
	$("#content")
		.append(mkButton(p1))
		.append("　-　")
		.append(mkButton(p2))
});
