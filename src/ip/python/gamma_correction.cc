/**
 * @file python/ip/src/gamma_correction.cc
 * @date Sun Jun 26 18:59:21 2011 +0200
 * @author Laurent El Shafey <Laurent.El-Shafey@idiap.ch>
 *
 * @brief Binds gamma correction into python
 *
 * Copyright (C) 2011-2012 Idiap Research Institute, Martigny, Switzerland
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#include "core/python/ndarray.h"
#include "ip/gammaCorrection.h"

using namespace boost::python;

template <typename T, int N>
static void inner_gammaCorrection_c(bob::python::const_ndarray src, 
  bob::python::ndarray dst, const double g) 
{
  blitz::Array<double,N> dst_ = dst.bz<double,N>();
  bob::ip::gammaCorrection<T>(src.bz<T,N>(), dst_, g);
}

static void py_gamma_correction_c(bob::python::const_ndarray src,
  bob::python::ndarray dst, const double g)
{
  const bob::core::array::typeinfo& info = src.type();

  if (info.nd != 2) 
    PYTHON_ERROR(TypeError, 
      "bob.ip.gamma_correction() does not support input array with \
       " SIZE_T_FMT " dimensions.",
      info.nd);

  switch (info.dtype) {
    case bob::core::array::t_uint8: 
      return inner_gammaCorrection_c<uint8_t,2>(src, dst, g);
    case bob::core::array::t_uint16:
      return inner_gammaCorrection_c<uint16_t,2>(src, dst, g);
    case bob::core::array::t_float64:
      return inner_gammaCorrection_c<double,2>(src, dst, g);
    default:
      PYTHON_ERROR(TypeError, 
        "bob.ip.gamma_correction() does not support input array of \
         type '%s'.",
        info.str().c_str());
  }
}

template <typename T, int N>
static object inner_gammaCorrection_p(bob::python::const_ndarray src,
  const double g) 
{
  const bob::core::array::typeinfo& info = src.type();
  bob::python::ndarray dst(bob::core::array::t_float64, info.shape[0],
    info.shape[1]);
  blitz::Array<double,N> dst_ = dst.bz<double,N>();
  bob::ip::gammaCorrection<T>(src.bz<T,N>(), dst_, g);
  return dst.self();
}

static object py_gamma_correction_p(bob::python::const_ndarray src,
  const double g)
{
  const bob::core::array::typeinfo& info = src.type();

  if (info.nd != 2) 
    PYTHON_ERROR(TypeError, 
      "bob.ip.gamma_correction() does not support input array with \
       " SIZE_T_FMT " dimensions.",
      info.nd);

  switch (info.dtype) {
    case bob::core::array::t_uint8: 
      return inner_gammaCorrection_p<uint8_t,2>(src, g);
    case bob::core::array::t_uint16:
      return inner_gammaCorrection_p<uint16_t,2>(src, g);
    case bob::core::array::t_float64:
      return inner_gammaCorrection_p<double,2>(src, g);
    default:
      PYTHON_ERROR(TypeError, 
        "bob.ip.gamma_correction() does not support input array of \
         type '%s'.",
        info.str().c_str());
  }
}
void bind_ip_gamma_correction() 
{
  def("gamma_correction", 
    &py_gamma_correction_c, (arg("src"), arg("dst"), arg("gamma")), 
    "Performs a power-law gamma correction on a 2D blitz array/image.");
  def("gamma_correction", 
    &py_gamma_correction_p, (arg("src"), arg("gamma")), 
    "Performs a power-law gamma correction on a 2D blitz array/image. The output is allocated and returned.");
}