library(OpenML)
library(knitr)
tasks = listOMLTasks(tag = "OpenML-CC18")
cols = c("task.id", "name", "number.of.classes", "number.of.features", "number.of.instances", 
         "minority.class.size", "majority.class.size")
tasks = tasks[, cols]
tasks$ratioMinMaj = round(tasks$minority.class.size / tasks$majority.class.size, 2)
tasks$majority.class.size = tasks$minority.class.size = NULL

new.cols = c("Task id", "Name", "nClass", "nFeat", "nObs", "ratioMinMaj")
k1 = kable(tasks[1:38,], format = "latex", booktabs = TRUE, 
  col.names = new.cols, row.names = FALSE)
k2 = kable(tasks[39:76,], format = "latex", booktabs = TRUE,
  col.names = new.cols, row.names = FALSE)
