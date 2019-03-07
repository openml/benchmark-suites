#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

criticalDifferencePlot = function(data, measure = "predictive.accuracy", alpha = 0.05) {

  sub.df = dplyr::select(.data = data, task.id, learner.name, measure)
  tasks = unique(sub.df$task.id)
  algos = unique(sub.df$learner.name)
  colnames(sub.df) = c("taskId", "learnerName", "predictiveAcc")

  aux.task = lapply(tasks, function(task) {
    aux.algo = lapply(algos, function(algo) {
      tmp = dplyr::filter(.data = sub.df, taskId == task, learnerName == algo)
      return( mean(tmp$predictiveAcc))
    })
    return(unlist(aux.algo))
  })

  mat = do.call("rbind", aux.task)
  mat[is.nan(mat)] = -Inf
  rownames(mat) = tasks
  colnames(mat) = algos

  g = scmamp::plotCD(results.matrix = mat, alpha = alpha)
  return(g)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
