#!/usr/bin/env python
#
# parcing FIO json output to CSV keys of interest
# Example: python parse.py test-results.json

import json
import sys

json_data = open(sys.argv[1])
results = json.load(json_data)
json_data.close()


def print_clat(name, job_type, job):
    dict = job[job_type]['clat']['percentile']
    for k in sorted(dict.keys()):
        name += ',{}'.format(dict[k])

    print(name)

def print_base(name, job_type, job):
    print('{0}, {1}, {2}, {3}, {4}, {5}'.format(
          name,
          job[job_type]['iops'],
          job[job_type]['bw'],
          job[job_type]['lat']['mean'],
          job[job_type]['clat']['percentile']['90.000000'],
          job[job_type]['lat']['stddev'],
          job[job_type]['slat']['mean']
          ))


for job in results['jobs']:
    name = job['jobname']
    job_type = name.split('-')[1]
    print_base(name, job_type, job)

for job in results['jobs']:
    name = job['jobname']
    job_type = name.split('-')[1]
    if 'rand-write-16k' == name or 'rand-read-16k' == name:
        title = name
        for k in sorted(job[job_type]['clat']['percentile'].keys()):
            title += ',{}'.format(k)
        print(title)
        print_clat(name, job_type, job)

