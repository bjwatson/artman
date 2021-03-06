# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""A canonical example of a flow class supported by vkit pipeline."""

from pipeline.pipelines import pipeline_base
from pipeline.tasks import sample_tasks
from taskflow.patterns import linear_flow


class SamplePipeline(pipeline_base.PipelineBase):

    def __init__(self, **kwargs):
        super(SamplePipeline, self).__init__(**kwargs)

    def do_build_flow(self, **kwargs):
        sleep_secs = kwargs.get('sleep_secs')
        flow = linear_flow.Flow('sample-flow')
        flow.add(sample_tasks.SampleTask('SampleTask',
                                         inject={'sleep_secs': sleep_secs}))
        return flow

    def validate_kwargs(self, **kwargs):
        if 'sleep_secs' not in kwargs:
            raise ValueError('sleep_secs must be provided')
