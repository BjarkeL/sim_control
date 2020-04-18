execute_process(COMMAND "/home/bjarke/DMP_project/sim_control/catkin_ws/build/python_controller/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/home/bjarke/DMP_project/sim_control/catkin_ws/build/python_controller/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
