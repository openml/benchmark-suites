import argparse
import logging
import openml


def read_cmd():
    parser = argparse.ArgumentParser()
    parser.add_argument('--server', default='https://www.openml.org/api/v1/xml/', type=str)
    parser.add_argument('--apikey', default=None, type=str)
    parser.add_argument('--alias', default='16', type=str)
    parser.add_argument('--entity_type', default='run_implicit', type=str)
    args_, misc = parser.parse_known_args()

    return args_


def run(args):
    root = logging.getLogger()
    root.setLevel(logging.INFO)
    
    openml.config.server = args.server
    openml.config.apikey = args.apikey
    
    source_study = openml.study.get_study(args.alias)
    logging.info('[source] data %s tasks %s flows %s setups %s runs %s' % 
                 (len(source_study.data), len(source_study.tasks), 
                  len(source_study.flows),
                  len(source_study.setups), len(source_study.runs)))
    logging.info('Got study with id = %s' % source_study.id)
    # set alias to None, as chances are that the study alias already exists
    if args.entity_type == 'task':
        target_study = openml.study.create_benchmark_suite(
            alias=None, 
            name=source_study.name, 
            description=source_study.description, 
            task_ids=source_study.tasks
        )
    elif args.entity_type == 'run':
        target_study = openml.study.create_study(
            alias=None, 
            benchmark_suite=source_study.benchmark_suite,
            name=source_study.name, 
            description=source_study.description, 
            run_ids=source_study.runs
        )
    elif args.entity_type == 'run_implicit':
        runs = openml.runs.list_runs(setup=source_study.setups, 
                                     task=source_study.tasks)
        target_study = openml.study.create_study(
            alias=None, 
            benchmark_suite=source_study.benchmark_suite,
            name=source_study.name, 
            description=source_study.description, 
            run_ids=list(runs.keys())
        )
    else:
        raise ValueError('Expected run or task. Got: something else. ')
    
    study_id = target_study.publish()
    logging.info('Uploaded with id = %s' % study_id)
    study = openml.study.get_study(study_id)
    logging.info('[uploaded] data %s tasks %s flows %s setups %s runs %s' % 
                 (len(study.data), len(study.tasks), len(study.flows),
                  len(study.setups), len(study.runs)))


if __name__ == '__main__':
    run(read_cmd())
