#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getExperimentsResults = function(tasks) {

  cat(" @ Getting experiment results\n")
  aux = lapply(tasks$task.id, function(id) {
    cat(" - loading results from task:", id)
    res = OpenML::listOMLRunEvaluations(task.id = id, limit = 5000, offset = 0)
    res$task.id = id
    cat(" - ", nrow(res), " results found\n")
    return(res)
  })

  df = plyr::rbind.fill(aux)
  return(df)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
