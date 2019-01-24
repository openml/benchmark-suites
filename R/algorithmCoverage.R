#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

algorithmCoverage = function(data) {

  all.algos = unique(data$learner.name)
  all.tasks = unique(data$task.id)

  aux = lapply(all.algos, function(alg){
    temp = dplyr::filter(.data = data, data$learner.name == alg)
    num = length(unique(temp$task.id))
    den = length(all.tasks)
    return(num/den)
  })

  df = data.frame(cbind(all.algos, unlist(aux)))
  df[,2] = as.numeric(as.character(df[,2]))
  colnames(df) = c("algo", "coverage")
  return(df)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
