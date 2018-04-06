library(OpenML)                                        # requires at least package version 1.8
lrn = makeLearner('classif.rpart')                     # construct a simple CART classifier
bsuite = getOMLStudy('OpenML-CC18')                    # obtain the benchmark suite
task.ids = extractOMLStudyIds(bsuite, 'task.id')       # obtain the list of suggested tasks
for (task.id in task.ids) {                            # iterate over all tasks 
  task = getOMLTask(task.id)                           # download single OML task
  data = as.data.frame(task)                           # obtain raw data set 
  run = runTaskMlr(task, learner = lrn)                # run constructed learner
  setOMLConfig(apikey = 'FILL_IN_OPENML_API_KEY') 
  upload = uploadOMLRun(run)                           # upload and tag the run
}