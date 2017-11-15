library(OpenML)
library(batchtools)

s = getOMLStudy("OpenML100")

tids = s$tasks$task.id
# tids = tids[1:3]
# populateOMLCache(task.ids = tids)

unlink("bench5learner", recursive = TRUE)

reg = makeExperimentRegistry(file.dir = "bench5learner",
  packages = c("mlr", "OpenML", "BBmisc", "parallelMap"), seed = 123)

for (tid in tids) {
  addProblem(name = as.character(tid), data = list(tid = tid), seed = tid)
}

addAlgorithm("run", fun = function(job, instance, data, lrn) {
  otask = getOMLTask(data$tid)
  otask$input$evaluation.measures = "predictive_accuracy"
  r = runTaskMlr(otask, lrn, measures = ber)
  list(run = r)
})

lrn.ridge = makeLearner("classif.cvglmnet", predict.type = "prob", alpha = 0)

ades = data.table(
  lrn = list(
    makeLearner("classif.featureless"),
    makeLearner(id = "classif.rpart.stump", "classif.rpart", maxdepth = 1L, predict.type = "prob"),
    makeLearner("classif.rpart", predict.type = "prob"),
    makeLearner("classif.naiveBayes", predict.type = "prob"),
    makeImputeWrapper(lrn.ridge, classes = list(numeric = imputeMedian(), factor = imputeMode()), dummy.classes = c("numeric", "factor"))
  )
)

addExperiments(algo.designs = list(run = ades))

resources = list(walltime = 3*3600, memory = 2*1024, measure.memory = TRUE)
submitJobs(ids = findNotSubmitted(), resources = resources, reg = reg)
