Usage
=====

Don't use this yet
------------------

**N.B. For now, unless you are part of the googleapis development team, don't try to use this.**

These commands depend on tools that are not yet published, and will currently
 only work in the development environments of the development team.

In particular
- the installation prequisites described need to installed locally
- an as yet unpublished branch of googleapis containing the pipeline configuration should be available
- the pipelines rely on as yet unpublished code-generation tool

Prerequisites
-------------

The pipeline is used to create artifacts in a number of different programming
languages, and needs various tools to do this.

For day-to-day use, these tools should be installed locally.  There is a
Dockerfile_ that sets up the environment with all prerequisites installed, please
use that as a reference for setting up a local environment.

.. _`Dockerfile`: https://github.com/googleapis/artman/blob/master/Dockerfile

Try it out
----------

Local
*****

To execute a build pipeline locally, try the following example command:

  ::

     python execute_pipeline.py \
       --pipeline_kwargs={\'sleep_secs\':2} SamplePipeline

To execute a build pipeline remotely, start two consoles and run the following command
in one console:

  ::

     python start_conductor.py


And then run the following command for multiple times with different parameter:

  ::

     python execute_pipeline.py \
       --pipeline_kwargs={\'sleep_secs\':2} \
       --remote_mode SamplePipeline

Please note, there is no guarantee that your pipeline job will be claimed by the
conductor running on your machine. It can also be picked up by other conductor
processes. You can run the second command for multiple times, and chances are
good that your conductor will pick up one job at least.

Config generation
*****************

  ::

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default" \
        VkitConfigPipeline


Python (logging)
****************

  ::

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common|logging_python,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default|python" \
        PythonGrpcClientPipeline

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common|logging_python,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default|python" \
        PythonVkitClientPipeline


Java (pubsub)
*************

  ::

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_core.yaml:core,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default|java" \
        JavaCorePipeline

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_pubsub.yaml:pubsub_common|pubsub_java,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default|java" \
        JavaGrpcClientPipeline

     python execute_pipeline.py \
        --config "../googleapis/pipeline_config/pipeline_pubsub.yaml:pubsub_common|pubsub_java,\
        ../googleapis/pipeline_config/pipeline_common.yaml:default|java" \
        JavaVkitClientPipeline


Go (logging)
************

To run the Go pipeline, first the core protos have to be compiled into the
output directory.  Note: this won't be necessary once there is a public
repository for the core proto pb.go files.

  ::

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_core.yaml:core,\
       ../googleapis/pipeline_config/pipeline_logging.yaml:logging_go,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|go" \
       GoCoreProtoPipeline


The actual Go pipeline is as follows:

  ::

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common|logging_go|logging_type,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|go" \
       GoCoreProtoPipeline

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common|logging_go,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|go" \
       GoGrpcClientPipeline

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_logging.yaml:logging_common|logging_go,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|go" \
       GoVkitClientPipeline


C# (pubsub)
***********

  ::

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_pubsub.yaml:pubsub_common|pubsub_csharp,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|csharp" \
       CSharpCorePipeline

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_pubsub.yaml:pubsub_common|pubsub_csharp,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|csharp" \
       CSharpGrpcClientPipeline

     python execute_pipeline.py \
       --config "../googleapis/pipeline_config/pipeline_pubsub.yaml:pubsub_common|pubsub_csharp,\
       ../googleapis/pipeline_config/pipeline_common.yaml:default|csharp" \
       CSharpVkitClientPipeline


Pipeline configuration
----------------------

artman build pipelines are configured using yaml files with configuration data to
run pipeline tasks.

googleapis/pipeline_config/pipeline_common.yaml

- default: Default configuration for all pipelines
- {language}: Language specific configuration

googleapis/pipeline_config/pipeline_{API}.yaml

- {API}_common: cross language API specific configuration
- {API}_{language}: API x language configurations
