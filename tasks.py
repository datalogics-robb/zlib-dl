from __future__ import print_function
from conans.client import tools
from dl_conan_build_tools.tasks import conan
from invoke import Collection, task, call
from invoke.tasks import Task
from sys import platform
import os
import shutil

@task
def distclean(ctx):
    """Clean up the project to its pristine distribution state. Undoes the effects of bootstrap."""
    paths = ['build', 'build_tools/build']
    for path in paths:
        if os.path.exists(path):
            print("Removing " + path)
            shutil.rmtree(path)


@task(pre=[conan.login])
def bootstrap(ctx):
    """Set up Conan, log in, and install Conan dependencies."""
    pass


# Make a top level task list for this module
tasks = [v for v in locals().values() if isinstance(v, Task)]

ns = Collection(conan, *tasks)

ns.configure({'run': {'echo': 'true'}})
