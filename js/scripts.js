/* Air Pollution in China Visualization
 * Created by Shannon Zhu
 * January 2015
 */

 // map variables
window.map_width = 960;
window.map_height = 660;
window.svg = null;

// map projection function
window.projection = d3.geo.albers()
	.center([-8, 16])
	.rotate([-110, -20])
	.parallels([21, 50])
	.scale(1000)
	.translate([window.map_width/2, window.map_height/2]);

// current data type to display
window.data_type = 'pm25';

// create color scale
var scale_values = {
	'co': [0, 10],
	'dewpoint': [-20, 0],
	'humidity': [-15, 15],
	'no2': [-15, 15],
	'o3': [70, 130],
	'pm10': [-15, 0, 15],
	'pm25': [-15, 0, 15],
	'pressure': [-15, 0, 15],
	'so2': [-15, 0, 15],
	'temperature': [-15, 0, 15],
	'wind': [-15, 0, 15]
};
var color = d3.scale.linear()
    .domain(scale_values[window.data_type])
    .range(["blue", "yellow", "red"]);

// recoloring and display valid data function
function recolor() {
	window.svg.selectAll(".dot")
		.style("fill", function(d) {
			return color(d[window.data_type]);
		})
		.attr("r", function(d) {
			if (d[window.data_type] == "-") {
				return 0;
			}
			return 5;
		})
}

$(document).ready(function() {
	// read radio button for display data type
	$("input:radio[name=data_type]").click(function() {
		var new_value = $(this).val();
		if (window.data_type != new_value) {
	    	window.data_type = $(this).val();
	    	recolor();
	    }
	});

	// create map projection
	window.svg = d3.select("body").append("svg")
	    .attr("width", window.map_width)
	    .attr("height", window.map_height);

	d3.json("china.json", function(error, china) {
		if (error) return console.error(error);

		var subunits = topojson.feature(china, china.objects.subunits);

		var path = d3.geo.path()
		    .projection(projection);

		window.svg.append("path")
	    	.datum(subunits)
	    	.attr("d", path);

	    window.svg.selectAll(".subunit")
	    	.data(topojson.feature(china, china.objects.subunits).features)
	    	.enter().append("path")
	    	.attr("class", function(d) { return "subunit " + d.id; })
	    	.attr("d", path);
	});

	// add the tooltip area to the webpage
	var tooltip = d3.select("body").append("div")
		.attr("class", "tooltip")
		.attr("width", "100px")
		.style("opacity", 0);
	    
	// parse data, add dots to svg
	d3.csv("data/20150101170000/aqi.csv", function(data) {
		// draw dots
		window.svg.selectAll(".dot")
			.data(data)
			.enter().append("circle")
			.attr("class", "dot")
			.attr("r", function(d) {
				if (d[window.data_type] == "-") {
					return 0;
				}
				return 5;
			})
			.attr("transform", function(d) {
				return "translate(" + window.projection([parseFloat(d['longitude']), parseFloat(d['latitude'])]) + ")";
			})
			.style("fill", function(d) {
				return color(d[window.data_type]);
			})
			.style("stroke", "#fff")
			.style("border", 1)
			.style("opacity", .5)
			.on("mouseover", function(d) {
				d3.select(this).transition()
					.duration(100)
					.attr("r", 9);
				tooltip.transition()
					.duration(150)
					.style("opacity", .9);
				tooltip.html(d["stationname"] + "<br/>" + d[window.data_type])
					.style("left", 0 + "px")
					.style("top", 0 + "px");
			})
			.on("mouseout", function(d) {
				d3.select(this).transition()
					.duration(150)
					.attr("r", 5);
				tooltip.transition()
					.duration(500)
					.style("opacity", 0);
			});
	});
});