#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRuntimeData = function(data) {

  temp = dplyr::select(.data = data, task.id, learner.name,
    usercpu.time.millis.training, usercpu.time.millis.testing, usercpu.time.millis)

  algos = unique(temp$learner.name)
  aux = lapply(algos, function(alg) {
    # TO DO: how to handle missing data here?
    d = na.omit(temp[which(temp$learner.name == alg),])
    return(colMeans(d[,3:ncol(d)]))
  })

  ret = data.frame(do.call("rbind", aux))
  ret$alg = algos
  return(ret)
}


#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
