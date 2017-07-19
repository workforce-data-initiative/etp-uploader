pkg_origin=brighthive
pkg_name=etp-uploader
pkg_version=0.1.0
pkg_licence=('MIT')
pkg_maintainer="jee@brighthive.io, aretha@brighthive.io, stanley@brighthive.io"
pkg_filename=${pkg_name}-${pkg_version}.tar.gz
pkg_upstream_url="https://github.com/workforce-data-initiative/etp-uploader.git"
pkg_build_deps=(core/virtualenv core/gcc core/gcc-libs core/glibc)
pkg_deps=(core/bash core/coreutils core/python)
pkg_exports=([port]=listening_port)
pkg_exposes=(port)


do_verify () {
  return 0
}

do_clean() {
  return 0
}

do_unpack() {
  # build_line "Exporting LD_RUN_PATH ..."
  # export LD_RUN_PATH=/usr/local/lib
  # create a env variable for the project root
  PROJECT_ROOT="${PLAN_CONTEXT}/.."
  mkdir -p $pkg_prefix
  # copy the contents of the source directory to the habitat cache path
  build_line "Copying project data /src to $pkg_prefix ..."
  build_line "Starting with web components, config and theme ..."
  mkdir -p $pkg_prefix/web
  cp -vr $PROJECT_ROOT/web $pkg_prefix
  build_line "Copying factory file ..."
  cp -vr $PROJECT_ROOT/web/factory.py $pkg_prefix/web/factory.py
  build_line "Copying tests ..."
  cp -vr $PROJECT_ROOT/tests $pkg_prefix/
  cp -vr $PROJECT_ROOT/*.py $pkg_prefix/
  build_line "Copying requirements ..."
  cp -vr $PROJECT_ROOT/requirements $pkg_prefix/
  cp -vr $PROJECT_ROOT/requirements.txt $pkg_prefix/
  build_line "Copying build file and bower.json ..."
  cp -vr $PROJECT_ROOT/build.sh $pkg_prefix
  cp -vr $PROJECT_ROOT/bower.json $pkg_prefix
}

do_build() {
  # build_line "Building python with shared libraries ..."
  # PYTHON_VERSION=3.4.0
  # mkdir -p /usr/src/python \
  #   && wget -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" \
  #   && tar -xJf "Python-$PYTHON_VERSION.tar.xz" -C /usr/src/python --strip-components=1 \
  #   && cd /usr/src/python \
  #   && ./configure \
  #   && make -j$(nproc) \
  #   && make install \
  # && cd / \
  # && rm -rf /usr/src/python
  return 0
}

do_install() {
  cd $pkg_prefix
  build_line "Creating a virtual environment ..."
  python3 -m venv venv
  . venv/bin/activate
  build_line "Installing requirements from requirements.txt ..."
  pip install -r requirements.txt
}
