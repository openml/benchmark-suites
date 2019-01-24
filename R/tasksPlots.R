#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

# Color blind palette (Dark2)
# http://colorbrewer2.org/
# ['#1b9e77','#d95f02','#7570b3']

tasksInfoPlot = function(data) {

  tasks = unique(data$task.id)

  aux = lapply(tasks, function(task){
    sub = data[which(data$task.id == task), ]
    max.acc  = max(sub$predictive.accuracy)
    max.auc  = max(sub$area.under.roc.curve)
    maj.prop = max(sub$perc.maj.class)
    ret = c(max.acc, max.auc, maj.prop)
    return(ret)
  })

  # df = [task | max.acc | max.auc | % maj class ]
  df = data.frame(do.call("rbind", aux))
  colnames(df) = c("max_acc", "max_auc", "perc_maj")
  df$tasks = tasks

  # sort increasing the % majclass (tasks)
  df = df[order(df$perc_maj, decreasing = FALSE),]
  df$tasks = factor(df$tasks, levels = df$tasks)

  df.final = melt(df, id.vars = 4)
  colnames(df.final) = c("task", "Measure", "value")
  df.final$task = as.numeric(df.final$task)

  g = ggplot(data = df.final, aes(x = task, y = value, group = Measure,
    colour = Measure, shape = Measure))
  g = g + geom_point() + scale_colour_brewer(palette = "Dark2")
  g = g + ylab(" Maximum value / Majority Class") + xlab("Tasks")
  g = g + scale_x_continuous(limits = c(1, length(tasks)))

  return(g)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

tasksOverview = function(data, measure = "predictive.accuracy", style = "boxplot") {

  if(!(style %in% c("boxplot", "violin"))) {
    stop("Please, provide a valid style: boxplot or violin ")
  }

  sub = dplyr::select(.data = data, data.name, task.id, measure)
  sub = sub[order(tolower(sub$data.name)),]
  colnames(sub) = c("dataset", "task", "value")
  sub$dataset = factor(sub$dataset, levels = unique(sub$dataset))

  g = ggplot(sub, mapping = aes(x = value, y = dataset))
  if(style == "boxplot") {
    g = g + stat_boxplot(geom ='errorbar')
    g = g + geom_boxplot(outlier.colour = "black", outlier.size = 0.5)
  } else {
    g = g + geom_violin(trim = TRUE, scale = "width")
    g = g + geom_boxplot(outlier.colour = "black", outlier.size = 0.5, width = 0.2, fill = "white")
  }
  g = g + scale_x_continuous(limits = c(0,1))
  g = g + theme(legend.position="none")
  return(g)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
