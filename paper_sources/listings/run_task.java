public static void runTasksAndUpload() throws Exception {
  OpenmlConnector openml = new OpenmlConnector();
  Study benchmarksuite = openml.studyGet("OpenML-CC18", "tasks");             // obtain the benchmark suite
  Classifier tree = new REPTree();                                          // build a Weka classifier
  for (Integer taskId : benchmarksuite.getTasks()) {                        // iterate over all tasks
    Task t = openml.taskGet(taskId);                                        // download the OpenML task
    Instances d = InstancesHelper.getDatasetFromTask(openml, t);            // obtain the dataset
    openml.setApiKey("FILL_IN_OPENML_API_KEY");
    int runId = RunOpenmlJob.executeTask(openml, new WekaConfig(), taskId, tree);
    Run run = openml.runGet(runId);}}                                       // retrieve the uploaded run