class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    series_1 = @get('series_1')
    if series_1
      series_1[series_1.length - 1].y

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    series = [{color: "#fff",data: [{x:0, y:0}]}]
    if @get("graphseries")
      series.push({color: "#999", data: [{x:0, y:0}]})
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: @get("graphtype")
      series: series,
      padding: {top: 0.02, left: 0.02, right: 0.02, bottom: 0.02}
    )
    @graph.series[0].data = @get('series_1') if @get('series_1')
    @graph.series[1].data = @get('series_2') if @get('series_2')

    @hoverDetail = new Rickshaw.Graph.HoverDetail(graph: @graph)

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    x_axis.render()
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    y_axis.render()
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.series_1
      if data.series_2
        @graph.series[1].data = data.series_2
      @graph.render()
