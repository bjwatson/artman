"""formatting requirements class."""

import os

from pipeline.utils import pipeline_util
from task_requirement_base import TaskRequirementBase


class JavaFormatRequirement(TaskRequirementBase):

    DIR = '/usr/local/bin/'
    FILENAME = 'google-java-format-0.1-alpha.jar'

    @classmethod
    def install(cls):
        pipeline_util.download(
            'http://github.com/google/google-java-format/releases/download/'
            'google-java-format-0.1-alpha/' + cls.FILENAME,
            cls.DIR)

    @classmethod
    def require(cls):
        return []

    @classmethod
    def is_installed(cls):
        return os.path.isfile(
            os.path.join(cls.DIR, cls.FILENAME))
