/**
 * @file src/python/sp/src/filters_new.cc 
 * @author <a href="mailto:Laurent.El-Shafey@idiap.ch">Laurent El Shafey</a> 
 *
 * @brief Binds new filters implementation to python 
 */

#include <boost/python.hpp>

#include "core/logging.h"
#include "ip/crop.h"
#include "ip/flipflop.h"
#include "ip/gammaCorrection.h"
#include "ip/rotate.h"
#include "ip/scale.h"
#include "ip/shear.h"
#include "ip/shift.h"

using namespace boost::python;

static const char* CROP2D_DOC = "Crop a 2D blitz array/image.";
static const char* CROP3D_DOC = "Crop a 3D blitz array/image.";
static const char* FLIP2D_DOC = "Flip a 2D blitz array/image upside-down.";
static const char* FLIP3D_DOC = "Flip a 3D blitz array/image upside-down.";
static const char* FLOP2D_DOC = "Flop a 2D blitz array/image left-right.";
static const char* FLOP3D_DOC = "Flop a 3D blitz array/image left-right.";
static const char* ROTATE2D_DOC = "Rotate a 2D blitz array/image with a given angle in degrees.";
static const char* RESCALE2D_DOC = "Rescale a 2D blitz array/image with the given dimensions.";
static const char* SHEARX2D_DOC = "Shear a 2D blitz array/image with the given shear parameter along the X-dimension.";
static const char* SHEARY2D_DOC = "Shear a 2D blitz array/image with the given shear parameter along the Y-dimension.";
static const char* SHIFT2D_DOC = "Shift a 2D blitz array/image.";
static const char* SHIFT3D_DOC = "Shift a 3D blitz array/image.";
static const char* GAMMACORRECTION2D_DOC = "Perform a power-law gamma correction on a 2D blitz array/image.";

#define FILTER_DECL(T,N) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(crop_overloads_ ## N, Torch::ip::crop<T>, 6, 8) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(rotate_overloads_ ## N, Torch::ip::rotate<T>, 3, 4) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(rescale_overloads_ ## N, Torch::ip::scale<T>, 4, 5) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(shearX_overloads_ ## N, Torch::ip::shearX<T>, 3, 4) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(shearY_overloads_ ## N, Torch::ip::shearY<T>, 3, 4) \
  BOOST_PYTHON_FUNCTION_OVERLOADS(shift_overloads_ ## N, Torch::ip::shift<T>, 4, 6)

#define FILTER_DEF(T,N) \
  def("crop", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const int, const int, const int, const int, const bool, const bool))&Torch::ip::crop<T>, crop_overloads_ ## N ((arg("src"), arg("dst"), arg("crop_x"), arg("crop_y"), arg("crop_w"), arg("crop_h"), arg("allow_out")="False", arg("zero_out")="False"), CROP2D_DOC)); \
  def("crop", (void (*)(const blitz::Array<T,3>&, blitz::Array<T,3>&, const int, const int, const int, const int, const bool, const bool))&Torch::ip::crop<T>, crop_overloads_ ## N ((arg("src"), arg("dst"), arg("crop_x"), arg("crop_y"), arg("crop_w"), arg("crop_h"), arg("allow_out")="False", arg("zero_out")="False"), CROP3D_DOC)); \
  def("flip", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&))&Torch::ip::flip<T>, (arg("src"), arg("dst")), FLIP2D_DOC); \
  def("flip", (void (*)(const blitz::Array<T,3>&, blitz::Array<T,3>&))&Torch::ip::flip<T>, (arg("src"), arg("dst")), FLIP3D_DOC); \
  def("flop", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&))&Torch::ip::flop<T>, (arg("src"), arg("dst")), FLOP2D_DOC); \
  def("flop", (void (*)(const blitz::Array<T,3>&, blitz::Array<T,3>&))&Torch::ip::flop<T>, (arg("src"), arg("dst")), FLOP3D_DOC); \
  def("rotate", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const double, const enum Torch::ip::Rotation::Algorithm))&Torch::ip::rotate<T>, rotate_overloads_ ## N ((arg("src"), arg("dst"), arg("angle"), arg("algorithm")="Shearing"), ROTATE2D_DOC)); \
  def("scale", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const int, const int, const enum Torch::ip::Rescale::Algorithm))&Torch::ip::scale<T>, rescale_overloads_ ## N ((arg("src"), arg("dst"), arg("new_width"), arg("new_height"), arg("algorithm")="BilinearInterp"), RESCALE2D_DOC)); \
  def("shearX", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const double, const bool))&Torch::ip::shearX<T>, shearX_overloads_ ## N ((arg("src"), arg("dst"), arg("angle"), arg("antialias")="True"), SHEARX2D_DOC)); \
  def("shearY", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const double, const bool))&Torch::ip::shearY<T>, shearY_overloads_ ## N ((arg("src"), arg("dst"), arg("angle"), arg("antialias")="True"), SHEARY2D_DOC)); \
  def("shift", (void (*)(const blitz::Array<T,2>&, blitz::Array<T,2>&, const int, const int, const bool, const bool))&Torch::ip::shift<T>, shift_overloads_ ## N ((arg("src"), arg("dst"), arg("shift_x"), arg("shift_y"), arg("allow_out")="False", arg("zero_out")="False"), SHIFT2D_DOC)); \
  def("shift", (void (*)(const blitz::Array<T,3>&, blitz::Array<T,3>&, const int, const int, const bool, const bool))&Torch::ip::shift<T>, shift_overloads_ ## N ((arg("src"), arg("dst"), arg("shift_x"), arg("shift_y"), arg("allow_out")="False", arg("zero_out")="False"), SHIFT3D_DOC)); \
  def("gammaCorrection", (void (*)(const blitz::Array<T,2>&, blitz::Array<double,2>&, const double))&Torch::ip::gammaCorrection<T>, (arg("src"), arg("dst"), arg("gamma")), GAMMACORRECTION2D_DOC);


/*
FILTER_DECL(bool,bool)
FILTER_DECL(int8_t,int8)
FILTER_DECL(int16_t,int16)
FILTER_DECL(int32_t,int32)
FILTER_DECL(int64_t,int64)
*/
FILTER_DECL(uint8_t,uint8)
FILTER_DECL(uint16_t,uint16)
/*
FILTER_DECL(uint32_t,uint32)
FILTER_DECL(uint64_t,uint64)
FILTER_DECL(float,float32)
*/
FILTER_DECL(double,float64)
/*
FILTER_DECL(std::complex<float>,complex64)
FILTER_DECL(std::complex<double>,complex128)
*/

void bind_ip_filters_new()
{
  enum_<Torch::ip::Rotation::Algorithm>("RotationAlgorithm")
    .value("Shearing", Torch::ip::Rotation::Shearing)
    .value("BilinearInterp", Torch::ip::Rotation::BilinearInterp)
    ;
 
  enum_<Torch::ip::Rescale::Algorithm>("RescaleAlgorithm")
    .value("NearesetNeighbour", Torch::ip::Rescale::NearestNeighbour)
    .value("BilinearInterp", Torch::ip::Rescale::BilinearInterp)
    ;
 
/*
  FILTER_DEF(bool,bool)
  FILTER_DEF(int8_t,int8)
  FILTER_DEF(int16_t,int16)
  FILTER_DEF(int32_t,int32)
  FILTER_DEF(int64_t,int64)
*/
  FILTER_DEF(uint8_t,uint8)
  FILTER_DEF(uint16_t,uint16)
/*
  FILTER_DEF(uint32_t,uint32)
  FILTER_DEF(uint64_t,uint64)
  FILTER_DEF(float,float32)
*/
  FILTER_DEF(double,float64)
/*
  FILTER_DEF(std::complex<float>,complex64)
  FILTER_DEF(std::complex<double>,complex128)
*/
}
