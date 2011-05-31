#include <boost/python.hpp>

using namespace boost::python;

void bind_machine_base();
void bind_machine_exception();
void bind_machine_eigenmachine();
void bind_machine_linear();

BOOST_PYTHON_MODULE(libpytorch_machine)
{
  docstring_options docopt; 
# if !defined(TORCH_DEBUG)
  docopt.disable_cpp_signatures();
# endif
  scope().attr("__doc__") = "Torch classes and sub-classes for machine access";

  bind_machine_base();
  bind_machine_exception();
  bind_machine_eigenmachine();
  bind_machine_linear();
}
