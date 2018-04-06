import openml
import sklearn.tree, sklearn.preprocessing
benchmark_suite = openml.study.get_study('OpenML-CC18','tasks') # obtain the benchmark suite
clf = sklearn.pipeline.Pipeline(steps=[('imputer',sklearn.preprocessing.Imputer()),  ('estimator',sklearn.tree.DecisionTreeClassifier())])                              # build a sklearn classifier
for task_id in benchmark_suite.tasks:                          # iterate over all tasks
  task = openml.tasks.get_task(task_id)                        # download the OpenML task
  X, y = task.get_X_and_y()                                    # get the data (not used in this example)
  openml.config.apikey = 'FILL_IN_OPENML_API_KEY'              # set the OpenML Api Key
  run = openml.runs.run_model_on_task(task,clf)                # run classifier on splits (requires API key)
  score = run.get_metric_fn(sklearn.metrics.accuracy_score) # print accuracy score
  print('Data set: %s; Accuracy: %0.2f' % (task.get_dataset().name,score.mean()))
  run.publish()                                                # publish the experiment on OpenML (optional)
  print('URL for run: %s/run/%d' %(openml.config.server,run.run_id))