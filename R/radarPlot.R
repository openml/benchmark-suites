#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

radarChart = function(data, sel.measures = c("area.under.roc.curve",
  "predictive.accuracy", "usercpu.time.millis", "recall", "f.measure",
  "precision")) {

  sel.measures = sel.measures[order(sel.measures)]
  sub = dplyr::select(.data = data, learner.name, sel.measures)

  aux = lapply(1:length(sel.measures), function(i) {
    ret = averagePerformance(data = sub, measure = sel.measures[i])
    ret$meas = sel.measures[i]
    colnames(ret)[2] = "value"

    # scalling runtime -> maximize (1 - runtime)
    if(sel.measures[i] == "usercpu.time.millis") {
      ret$value = 1 - ((ret$value - min(ret$value))/(max(ret$value) - min(ret$value)))
    }

    return(ret)
  })

  df = do.call("rbind", aux)

  g = ggplot(df, aes(x = meas, y = value, color = algo, group = algo, fill = algo,
    shape = algo, linetype = algo))
  g = g + geom_polygon(alpha = 0.1) + geom_point() + coord_polar()
  g = g + scale_y_continuous(limits = c(0,1))

  # TODO: facet by environment (R, JAVA, Python)
  # g = g + facet_wrap(~chart, ncol=, nrow=)

  g = g + theme_bw()
  g = g + labs(fill = "Algorithms", color = "Algorithms",
    shape = "Algorithms", linetype = "Algorithms")
  g = g + ylab("Average values in [0,1]") + xlab("")
  return(g)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
