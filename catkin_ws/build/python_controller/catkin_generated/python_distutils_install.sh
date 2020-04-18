#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/bjarke/DMP_project/sim_control/catkin_ws/src/python_controller"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/bjarke/DMP_project/sim_control/catkin_ws/install/lib/python2.7/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/bjarke/DMP_project/sim_control/catkin_ws/install/lib/python2.7/dist-packages:/home/bjarke/DMP_project/sim_control/catkin_ws/build/lib/python2.7/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/bjarke/DMP_project/sim_control/catkin_ws/build" \
    "/usr/bin/python2" \
    "/home/bjarke/DMP_project/sim_control/catkin_ws/src/python_controller/setup.py" \
    build --build-base "/home/bjarke/DMP_project/sim_control/catkin_ws/build/python_controller" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/bjarke/DMP_project/sim_control/catkin_ws/install" --install-scripts="/home/bjarke/DMP_project/sim_control/catkin_ws/install/bin"
