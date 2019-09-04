# zlib-dl

ZLib latest binaries and tools to build them.

In the top level directory are two scripts.  A Windows batch file and a bourne shell script.  The bourne shell script will clone the upstream zlib repo, and checkout tag v1.2.11, which should be kept up to date to the latest release.  ZLib updates are typically security fixes, and our clients care about this.
The bourne shell scripts will create the binaries, and we should commit them to eliminate the need to do this over and over, as zlib doesn't change.

## Conan

This project can build Conan packages for the following platforms:

- macOS 10.7 and up, using Xcode 9.4.1
- Windows, using Visual Studio 14 (2015) and Visual Studio 15 (2017)
- Linux, using [devtoolset-7](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7/)

### Prerequisites

- Python 3.6.5
- pipenv

If building cross architecture on a RedHat/CentOS system, make sure to install the i686 support:

```bash
@ -16,3 +29,28 @@ yum install glibc-devel.i686
```

See: https://unix.stackexchange.com/a/198282

### Building

First, update the version in the `conanfile.py` as necessary.

Then, the following commands will build all the configurations and upload them to Artifactory.

```bash
$ pipenv install
$ pipenv shell
$ invoke conan.login
$ invoke conan.package
```

### More platforms

General outline.

- Define a [Conan profile](https://docs.conan.io/en/latest/reference/profiles.html) to describe the OS and compiler. You can start with the default profile that Conan makes for the build host. Put the profile in the [conan-config](https://octocat.dlogics.com/datalogics/conan-config) project.
- Tell `dl-conan-build-tools` how to create a name for the system and determine the version in [config.py](https://octocat.dlogics.com/datalogics/dl-conan-build-tools/blob/develop/dl_conan_build_tools/config.py#L28).
- You might have to add OS settings to the `settings.yml` file in `conan-config`, too.
- Add configuration for the platform to the `dlproject.yaml` file in the project.
- Define settings for the platform in the `build()` method of the `conanfile.py`.

**Note:** Unlike current DL conventions which use a platform name, Conan separates that into different combinations of OS, architecture, and compiler, via the build settings.
