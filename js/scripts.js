/* Air Pollution in China Visualization
 * Created by Shannon Zhu
 * January 2015
 */

$(document).ready(function() {
	var width = 960,
	    height = 660;

	var svg = d3.select("body").append("svg")
	    .attr("width", width)
	    .attr("height", height);

	d3.json("china.json", function(error, china) {
		if (error) return console.error(error);

		var subunits = topojson.feature(china, china.objects.subunits);

		var projection = d3.geo.albers()
		    .center([-8, 16])
		    .rotate([-110, -20])
		    .parallels([21, 50])
		    .scale(1000)
		    .translate([width / 2, height / 2]);

		var path = d3.geo.path()
		    .projection(projection);

		svg.append("path")
	    	.datum(subunits)
	    	.attr("d", path);

	    svg.selectAll(".subunit")
	    	.data(topojson.feature(china, china.objects.subunits).features)
	    	.enter().append("path")
	    	.attr("class", function(d) { return "subunit " + d.id; })
	    	.attr("d", path);
	});
});