#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

checkMeasure = function(measure) {

  #TODO: replace with checkmate commands
  allowed.measures = c("f.measure", "kappa", "precision", "recall",
    "usercpu.time.millis", "area.under.roc.curve", "predictive.accuracy")

  if (!( measure %in% allowed.measures)) {
    stop(paste0(" - Please, choose one of the following measures: ",
      paste(allowed.measures, collapse=', '), " \n"))
  }
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
