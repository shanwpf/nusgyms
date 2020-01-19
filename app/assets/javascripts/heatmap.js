const margin = { top: 50, right: 0, bottom: 100, left: 30 },
width = 860 - margin.left - margin.right,
height = 430 - margin.top - margin.bottom,
gridSize = Math.floor(width / 24),
legendElementWidth = gridSize*2,
buckets = 9,
colors = ["#ffffd9","#edf8b1","#c7e9b4","#7fcdbb","#41b6c4","#1d91c0","#225ea8","#253494","#081d58"], // alternatively colorbrewer.YlGnBu[9]
days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
times = ["6a", "7a", "8a", "9a", "10a", "11a", "12p", "1p", "2p", "3p", "4p", "5p", "6p", "7p", "8p", "9p", "10p", "11p"];
datasets = ["utown", "mpsh3", "usc"];

datasets.forEach(location => {
  const svg = d3.select(`#chart-${location}`).append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  const dayLabels = svg.selectAll(".dayLabel")
  .data(days)
  .enter().append("text")
  .text(function (d) { return d; })
  .attr("x", 0)
  .attr("y", (d, i) => i * gridSize)
  .style("text-anchor", "end")
  .attr("transform", "translate(-6," + gridSize / 1.5 + ")")
  .attr("class", "dayLabel mono axis axis-workweek");

  const timeLabels = svg.selectAll(".timeLabel")
  .data(times)
  .enter().append("text")
  .text((d) => d)
  .attr("x", (d, i) => i * gridSize)
  .attr("y", 0)
  .style("text-anchor", "middle")
  .attr("transform", "translate(" + gridSize / 2 + ", -6)")
  .attr("class", "timeLabel mono axis axis-worktime");


  const parseDate = d3.utcParse("%Y-%m-%d %H");
  const formatDay = d3.timeFormat("%w")
  const formatHour = d3.timeFormat("%H")
  const div = d3.select("body").append("div")
  .attr("class", "tooltip")
  .style("opacity", 0);
  const dayToIndex = function(day) {
    if (day == 0) {
      return 6;
    } 
    else {
      return day - 1;
    }
  }

  const heatmapChart = function(jsonData) {
    d3.json(jsonData).then(data => {
      data = data.map(d => {
        date = parseDate(d.date + " " + d.hour);
        d.hour = formatHour(date);
        d.day = formatDay(date);
        return d;
      }).filter(d => {
        return d.hour > 5;
      })
      
      const colorScale = d3.scaleQuantile()
      .domain([0, buckets - 1, d3.max(data, (d) => d.avg)])
      .range(colors);
      
      const cards = svg.selectAll(".hour")
      .data(data, (d) => {
        d.day+':'+d.hour;
      });
      
      cards.append("title");
      
      cards.enter().append("rect")
      .attr("x", (d) => (d.hour - 6) * gridSize)
      .attr("y", (d) => (dayToIndex(d.day)) * gridSize)
      .attr("rx", 4)
      .attr("ry", 4)
      .attr("class", "hour bordered")
      .attr("width", gridSize)
      .attr("height", gridSize)
      .style("fill", colors[0])
      .merge(cards)
      .transition()
      .duration(1000)
      .style("fill", (d) => colorScale(d.avg))
      
      svg.selectAll("rect").on("mouseover", (d) => {
        div.transition()		
        .duration(200)		
        .style("opacity", .9);
        div.html(d.avg)
        .style("left", (d3.event.pageX) + "px")		
        .style("top", (d3.event.pageY - 28) + "px");	
      });

      svg.selectAll("rect").on("mouseout", (d) => {
        div.transition()
        .duration(500)
        .style("opacity", 0);
      });
      
      cards.select("title").text((d) => d.avg);
      
      cards.exit().remove();
      
      const legend = svg.selectAll(".legend")
      .data([0].concat(colorScale.quantiles()), (d) => d);
      
      const legend_g = legend.enter().append("g")
      .attr("class", "legend");
      
      legend_g.append("rect")
      .attr("x", (d, i) => legendElementWidth * i)
      .attr("y", height)
      .attr("width", legendElementWidth)
      .attr("height", gridSize / 2)
      .style("fill", (d, i) => colors[i]);
      
      legend_g.append("text")
      .attr("class", "mono")
      .text((d) => "≥ " + Math.round(d))
      .attr("x", (d, i) => legendElementWidth * i)
      .attr("y", height + gridSize);
      
      legend.exit().remove();
    });
  };

  heatmapChart(`occupancies/${location}`);
});
