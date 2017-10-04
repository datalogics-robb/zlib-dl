# zlib-dl

ZLib latest binaries and tools to build them.

In the top level directory are two scripts.  A Windows batch file and a bourne shell script.  The bourne shell script will clone the upstream zlib repo, and checkout tag v1.2.11, which should be kept up to date to the latest release.  ZLib updates are typically security fixes, and our clients care about this.
The bourne shell scripts will create the binaries, and we should commit them to eliminate the need to do this over and over, as zlib doesn't change.

