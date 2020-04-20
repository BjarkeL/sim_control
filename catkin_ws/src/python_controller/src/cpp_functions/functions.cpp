#include <boost/python.hpp>

float add(float in1, float in2) {
    return in1+in2;
}

BOOST_PYTHON_MODULE(functions) {
    boost::python::def("add",add);
}