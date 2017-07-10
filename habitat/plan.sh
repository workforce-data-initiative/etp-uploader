pkg_origin=brighthive
pkg_name=etp-uploader
pkg_version=0.1.0
pkg_maintainer="jee@brighthive.io, aretha@brighthive.io, stanley@brighthive.io"
pkg_filename=${pkg_name}-${pkg_version}.tar.gz
pkg_upstream_url="https://github.com/workforce-data-initiative/etp-uploader.git"
pkg_exports=([port]=listening_port)
pkg_exposes=(port)
pkg_build_deps=(core/virtualenv)
pkg_deps=(core/python core/glibc)
pkg_interpreters=(bin/python3)
pkg_licence=('MIT')

do_verify () {
  return 0
}

do_clean() {
  return 0
}

do_unpack() {
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
  return 0
  # ./build.sh
}

do_install() {
  cd $pkg_prefix
  build_line "Creating a virtual environment ..."
  virtualenv venv -p python3
  source venv/bin/activate
  build_line "Installing requirements from requirements.txt ..."
  pip install -r requirements.txt
}
