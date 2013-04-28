"use strict";
$(function() {
	function onChange() {
		var a = Number($("#val1").val());
		var b = Number($("#val2").val());
		var c = a + b;
		$("#val3").text(c);
	}
	$("#val1").change(onChange);
	$("#val2").change(onChange);
});
