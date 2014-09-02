# -*- python -*-
'''
pylibgamma — Python 3 wrapper for libgamma
Copyright © 2014  Mattias Andrée (maandree@member.fsf.org)

This library is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this library.  If not, see <http://www.gnu.org/licenses/>.
'''

cimport cython

from libc.stddef cimport size_t
from libc.stdlib cimport malloc, free
from libc.stdint cimport int32_t, uint8_t, uint16_t, uint32_t, uint64_t


ctypedef int libgamma_subpixel_order_t
ctypedef int libgamma_connector_type_t


cdef extern from "libgamma/libgamma-method.h":
    
    ctypedef struct libgamma_method_capabilities_t:
        # Capabilities of adjustment methods.
        
        int32_t crtc_information
        # OR of the CRTC information fields in `libgamma_crtc_information_t`
        # that may (but can fail) be read successfully.
        
        unsigned default_site_known # : 1
        # Whether the default site is known, if true the site is integrated
        # to the system or can be determined using environment variables.
        
        unsigned multiple_sites # : 1
        # Whether the adjustment method supports multiple sites rather
        # than just the default site.
        
        unsigned multiple_partitions # : 1
        # Whether the adjustment method supports multiple partitions
        # per site.
        
        unsigned multiple_crtcs # : 1
        # Whether the adjustment method supports multiple CRTC:s
        # per partition per site.
        
        unsigned partitions_are_graphics_cards # : 1
        # Whether the partition to graphics card is a bijection.
        
        unsigned site_restore # : 1
        # Whether the adjustment method supports `libgamma_site_restore`.
        
        unsigned partition_restore # : 1
        # Whether the adjustment method supports `libgamma_partition_restore`.
        
        unsigned crtc_restore # : 1
        # Whether the adjustment method supports `libgamma_crtc_restore`.
        
        unsigned identical_gamma_sizes # : 1
        # Whether the `red_gamma_size`, `green_gamma_size` and `blue_gamma_size`
        # fields in `libgamma_crtc_information_t` will always have the same
        # values as each other for the adjustment method.
        
        unsigned fixed_gamma_size # : 1
        # Whether the `red_gamma_size`, `green_gamma_size` and `blue_gamma_size`
        # fields in `libgamma_crtc_information_t` will always be filled with the
        # same value for the adjustment method.
        
        unsigned fixed_gamma_depth # : 1
        # Whether the `gamma_depth` field in `libgamma_crtc_information_t`
        # will always be filled with the same value for the adjustment method.
        
        unsigned real # : 1
        # Whether the adjustment method will actually perform adjustments.
        
        unsigned fake # : 1
        # Whether the adjustment method is implement using a translation layer.
    
    
    ctypedef struct libgamma_site_state_t:
        # Site state.
        # 
        # On operating systems that integrate a graphical environment
        # there is usually just one site. However, one systems with
        # pluggable graphics, like Unix-like systems such as GNU/Linux
        # and the BSD:s, there can usually be any (feasible) number of
        # sites. In X.org parlance they are called displays.
        
        void* data
        # Adjustment method implementation specific data.
        # You as a user of this library should not touch this.
        
        int method
        # This field specifies, for the methods if this library,
        # which adjustment method (display server and protocol)
        # is used to adjust the gamma ramps.
        
        char* site
        # The site identifier. It can either be `NULL` or a string.
        # `NULL` indicates the default site. On systems like the
        # Unix-like systems, where the graphics are pluggable, this
        # is usually resolved by an environment variable, such as
        # "DISPLAY" for X.org.
        
        size_t partitions_available
        # The number of partitions that is available on this site.
        # Probably the majority of display server only one partition
        # per site. However, X.org can, and traditional used to have
        # on multi-headed environments, multiple partitions per site.
        # In X.org partitions are called 'screens'. It is not to be
        # confused with monitor. A screen is a collection of monitors,
        # and the mapping from monitors to screens is a surjection.
        # On hardware-level adjustment methods, such as Direct
        # Rendering Manager, a partition is a graphics card.
    
    
    ctypedef struct libgamma_partition_state_t:
        # Partition state.
        # 
        # Probably the majority of display server only one partition
        # per site. However, X.org can, and traditional used to have
        # on multi-headed environments, multiple partitions per site.
        # In X.org partitions are called 'screens'. It is not to be
        # confused with monitor. A screen is a collection of monitors,
        # and the mapping from monitors to screens is a surjection.
        # On hardware-level adjustment methods, such as Direct
        # Rendering Manager, a partition is a graphics card.
        
        void* data
        # Adjustment method implementation specific data.
        # You as a user of this library should not touch this.
        
        libgamma_site_state_t* site
        # The site this partition belongs to.
        
        size_t partition
        # The index of the partition.
        
        size_t crtcs_available
        # The number of CRTC:s that are available under this
        # partition. Note that the CRTC:s are not necessarily
        # online.
    
    
    ctypedef struct libgamma_crtc_state_t:
        # Cathode ray tube controller state.
        # 
        # The CRTC controls the gamma ramps for the
        # monitor that is plugged in to the connector
        # that the CRTC belongs to.
        
        void* data
        # Adjustment method implementation specific data.
        # You as a user of this library should not touch this.
        
        libgamma_partition_state_t* partition
        # The partition this CRTC belongs to.
        
        size_t crtc
        # The index of the CRTC within its partition.
    
    
    ctypedef struct libgamma_crtc_information_t:
        # Cathode ray tube controller information data structure.
        
        unsigned char* edid
        # The Extended Display Identification Data associated with
        # the attached monitor. This is raw byte array that is usually
        # 128 bytes long. It is not NUL-terminate, rather its length
        # is stored in `edid_length`.
        
        size_t edid_length
        # The length of `edid`.
        
        int edid_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        size_t width_mm
        # The phyical width, in millimetres, of the viewport of the
        # attached monitor, as reported by the adjustment method. This
        # value may be incorrect, which is a known issue with the X
        # server where it is the result of the X server attempting
        # the estimate the size on its own.
        # Zero means that its is not applicable, which is the case
        # for projectors.
        
        int width_mm_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        size_t height_mm
        # The phyical height, in millimetres, of the viewport of the
        # attached monitor, as reported by the adjustment method. This
        # value may be incorrect, which is a known issue with the X
        # server where it is the result of the X server attempting
        # the estimate the size on its own.
        # Zero means that its is not applicable, which is the case
        # for projectors.
        
        int height_mm_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        size_t width_mm_edid
        # The phyical width, in millimetres, of the viewport of the
        # attached monitor, as reported by it the monitor's Extended
        # Display Information Data. This value can only contain whole
        # centimetres, which means that the result is always zero
        # modulus ten. However, this could change with revisions of
        # the EDID structure.
        # Zero means that its is not applicable, which is the case
        # for projectors.
        
        int width_mm_edid_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        size_t height_mm_edid
        # The phyical height, in millimetres, of the viewport of the
        # attached monitor, as reported by it the monitor's Extended
        # Display Information Data. This value can only contain whole
        # centimetres, which means that the result is always zero
        # modulus ten. However, this could change with revisions of
        # the EDID structure.
        # Zero means that its is not applicable, which is the case
        # for projectors.
        
        int height_mm_edid_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        size_t red_gamma_size
        # The size of the encoding axis of the red gamma ramp.
        
        size_t green_gamma_size
        # The size of the encoding axis of the green gamma ramp.
        
        size_t blue_gamma_size
        # The size of the encoding axis of the blue gamma ramp.
        
        int gamma_size_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        signed gamma_depth
        # The bit-depth of the value axes of gamma ramps,
        # -1 for single precision floating point, and -2 for
        # double precision floating point.
        
        int gamma_depth_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        int gamma_support
        # Non-zero gamma ramp adjustments are supported.
        
        int gamma_support_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        libgamma_subpixel_order_t subpixel_order
        # The layout of the subpixels.
        # You cannot count on this value --- especially for CRT:s ---
        # but it is provided anyway as a means of distinguishing monitors.
        
        int subpixel_order_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        int active
        # Whether there is a monitors connected to the CRTC.
        
        int active_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        char* connector_name
        # The name of the connector as designated by the display
        # server or as give by this library in case the display
        # server lacks this feature.
        
        int connector_name_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        libgamma_connector_type_t connector_type
        # The type of the connector that is associated with the CRTC.
        
        int connector_type_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
        
        
        float gamma_red
        # The gamma characteristics of the monitor as reported
        # in its Extended Display Information Data. The value
        # holds the value for the red channel. If you do not have
        # and more accurate measurement of the gamma for the
        # monitor this could be used to give a rought gamma
        # correction; simply divide the value with 2.2 and use
        # the result for the red channel in the gamma correction.
        
        float gamma_green
        # The gamma characteristics of the monitor as reported
        # in its Extended Display Information Data. The value
        # holds the value for the green channel. If you do not have
        # and more accurate measurement of the gamma for the
        # monitor this could be used to give a rought gamma
        # correction; simply divide the value with 2.2 and use
        # the result for the green channel in the gamma correction.
        
        float gamma_blue
        # The gamma characteristics of the monitor as reported
        # in its Extended Display Information Data. The value
        # holds the value for the blue channel. If you do not have
        # and more accurate measurement of the gamma for the
        # monitor this could be used to give a rought gamma
        # correction; simply divide the value with 2.2 and use
        # the result for the blue channel in the gamma correction.
        
        int gamma_error
        # Zero on success, positive it holds the value `errno` had
        # when the reading failed, otherwise (negative) the value
        # of an error identifier provided by this library.
    
    
    ctypedef struct libgamma_gamma_ramps8_t:
        # Gamma ramp structure for 8-bit gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        uint8_t* red
        # The gamma ramp for the red channel.
        uint8_t* green
        # The gamma ramp for the green channel.
        uint8_t* blue
        # The gamma ramp for the blue channel.
    
    ctypedef struct libgamma_gamma_ramps16_t:
        # Gamma ramp structure for 16-bit gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        uint16_t* red
        # The gamma ramp for the red channel.
        uint16_t* green
        # The gamma ramp for the green channel.
        uint16_t* blue
        # The gamma ramp for the blue channel.
    
    ctypedef struct libgamma_gamma_ramps32_t:
        # Gamma ramp structure for 32-bit gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        uint32_t* red
        # The gamma ramp for the red channel.
        uint32_t* green
        # The gamma ramp for the green channel.
        uint32_t* blue
        # The gamma ramp for the blue channel.
    
    ctypedef struct libgamma_gamma_ramps64_t:
        # Gamma ramp structure for 64-bit gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        uint64_t* red
        # The gamma ramp for the red channel.
        uint64_t* green
        # The gamma ramp for the green channel.
        uint64_t* blue
        # The gamma ramp for the blue channel.
    
    ctypedef struct libgamma_gamma_rampsf_t:
        # Gamma ramp structure for `float` gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        float* red
        # The gamma ramp for the red channel.
        float* green
        # The gamma ramp for the green channel.
        float* blue
        # The gamma ramp for the blue channel.
    
    ctypedef struct libgamma_gamma_rampsd_t:
        # Gamma ramp structure for `double` gamma ramps.
        size_t red_size
        # The size of `red`.
        size_t green_size
        # The size of `green`.
        size_t blue_size
        # The size of `blue`.
        double* red
        # The gamma ramp for the red channel.
        double* green
        # The gamma ramp for the green channel.
        double* blue
        # The gamma ramp for the blue channel.


cdef extern size_t libgamma_list_methods(int* methods, size_t buf_size, int operation)
'''
List available adjustment methods by their order of preference based on the environment.

@param  methods    Output array of methods, should be able to hold `LIBGAMMA_METHOD_COUNT` elements.
@param  buf_size   The number of elements that fits in `methods`, it should be `LIBGAMMA_METHOD_COUNT`,
                   This is used to avoid writing outside the output buffer if this library adds new
                   adjustment methods without the users of the library recompiling.
@param  operation  Allowed values:
                     0: Methods that the environment suggests will work, excluding fake.
                     1: Methods that the environment suggests will work, including fake.
                     2: All real non-fake methods.
                     3: All real methods.
                     4: All methods.
                   Other values invoke undefined behaviour.
@return            The number of element that have been stored in `methods`, or should
                   have been stored if the buffer was large enough.
'''


cdef extern int libgamma_is_method_available(int method)
'''
Check whether an adjustment method is available, non-existing (invalid) methods will be
identified as not available under the rationale that the library may be out of date.

@param   method  The adjustment method.
@return          Whether the adjustment method is available.
'''


cdef extern void libgamma_method_capabilities(libgamma_method_capabilities_t* this, int method)
'''
Return the capabilities of an adjustment method.

@param  this    The data structure to fill with the method's capabilities
@param  method  The adjustment method (display server and protocol).
'''


cdef extern char* libgamma_method_default_site(int method)
'''
Return the capabilities of an adjustment method.

@param   method  The adjustment method (display server and protocol.)
@return          The default site, `NULL` if it cannot be determined or
                 if multiple sites are not supported by the adjustment
                 method. This value should not be `free`:d.
'''


cdef extern const char* libgamma_method_default_site_variable(int method)
'''
Return the capabilities of an adjustment method.

@param   method  The adjustment method (display server and protocol.)
@return          The environ variables that is used to determine the
                 default site. `NULL` if there is none, that is, if
                 the method does not support multiple sites.
                 This value should not be `free`:d.
'''



cdef extern int libgamma_site_initialise(libgamma_site_state_t* this, int method, char* site)
'''
Initialise an allocated site state.

@param   this    The site state to initialise.
@param   method  The adjustment method (display server and protocol.)
@param   site    The site identifier, unless it is `NULL` it must a
                 `free`:able. One the state is destroyed the library
                 will attempt to free it. There you should not free
                 it yourself, and it must not be a string constant
                 or allocate on the stack. Note however that it will
                 not be `free`:d if this function fails.
@return          Zero on success, otherwise (negative) the value of an
                 error identifier provided by this library.
'''


cdef extern void libgamma_site_free(libgamma_site_state_t* this)
'''
Release all resources held by a site state
and free the site state pointer.

@param  this  The site state.
'''


cdef extern int libgamma_site_restore(libgamma_site_state_t* this)
'''
Restore the gamma ramps all CRTC:s with a site to the system settings.

@param   this  The site state.
@return        Zero on success, otherwise (negative) the value of an
               error identifier provided by this library.
'''



cdef extern int libgamma_partition_initialise(libgamma_partition_state_t* this, libgamma_site_state_t* site, size_t partition)
'''
Initialise an allocated partition state.

@param   this       The partition state to initialise.
@param   site       The site state for the site that the partition belongs to.
@param   partition  The index of the partition within the site.
@return             Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
'''


cdef extern void libgamma_partition_free(libgamma_partition_state_t* this)
'''
Release all resources held by a partition state
and free the partition state pointer.

@param  this  The partition state.
'''


cdef extern int libgamma_partition_restore(libgamma_partition_state_t* this)
'''
Restore the gamma ramps all CRTC:s with a partition to the system settings.

@param   this  The partition state.
@return        Zero on success, otherwise (negative) the value of an
               error identifier provided by this library.
'''



cdef extern int libgamma_crtc_initialise(libgamma_crtc_state_t* this, libgamma_partition_state_t* partition, size_t crtc)
'''
Initialise an allocated CRTC state.

@param   this       The CRTC state to initialise.
@param   partition  The partition state for the partition that the CRTC belongs to.
@param   crtc       The index of the CRTC within the partition.
@return             Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
'''


cdef extern void libgamma_crtc_free(libgamma_crtc_state_t* this)
'''
Release all resources held by a CRTC state
and free the CRTC state pointer.

@param  this  The CRTC state.
'''


cdef extern int libgamma_crtc_restore(libgamma_crtc_state_t* this)
'''
Restore the gamma ramps for a CRTC to the system settings for that CRTC.

@param   this  The CRTC state
@return        Zero on success, otherwise (negative) the value of an
               error identifier provided by this library.
'''



cdef extern int libgamma_get_crtc_information(libgamma_crtc_information_t* this, libgamma_crtc_state_t* crtc, int32_t fields)
'''
Read information about a CRTC.

@param   this    Instance of a data structure to fill with the information about the CRTC.
@param   crtc    The state of the CRTC whose information should be read.
@param   fields  OR:ed identifiers for the information about the CRTC that should be read.
@return          Zero on success, -1 on error. On error refer to the error reports in `this`.
'''


cdef extern void libgamma_crtc_information_destroy(libgamma_crtc_information_t* this)
'''
Release all resources in an information data structure for a CRTC.

@param  this  The CRTC information.
'''



cdef extern int libgamma_crtc_get_gamma_ramps8(libgamma_crtc_state_t* this, libgamma_gamma_ramps8_t* ramps)
'''
Get current the gamma ramps for a CRTC, 8-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_set_gamma_ramps8(libgamma_crtc_state_t* this, libgamma_gamma_ramps8_t ramps)
'''
Set the gamma ramps for a CRTC, 8-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



cdef extern int libgamma_crtc_get_gamma_ramps16(libgamma_crtc_state_t* this, libgamma_gamma_ramps16_t* ramps)
'''
Get current the gamma ramps for a CRTC, 16-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_set_gamma_ramps16(libgamma_crtc_state_t* this, libgamma_gamma_ramps16_t ramps)
'''
Set the gamma ramps for a CRTC, 16-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



cdef extern int libgamma_crtc_get_gamma_ramps32(libgamma_crtc_state_t* this, libgamma_gamma_ramps32_t* ramps)
'''
Get current the gamma ramps for a CRTC, 32-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_set_gamma_ramps32(libgamma_crtc_state_t* this, libgamma_gamma_ramps32_t ramps)
'''
Set the gamma ramps for a CRTC, 32-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



cdef extern int libgamma_crtc_get_gamma_ramps64(libgamma_crtc_state_t* this, libgamma_gamma_ramps64_t* ramps)
'''
Get current the gamma ramps for a CRTC, 64-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_set_gamma_ramps64(libgamma_crtc_state_t* this, libgamma_gamma_ramps64_t ramps)
'''
Set the gamma ramps for a CRTC, 64-bit gamma-depth version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



cdef extern int libgamma_crtc_set_gamma_rampsf(libgamma_crtc_state_t* this, libgamma_gamma_rampsf_t ramps)
'''
Set the gamma ramps for a CRTC, `float` version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_get_gamma_rampsf(libgamma_crtc_state_t* this, libgamma_gamma_rampsf_t* ramps)
'''
Get current the gamma ramps for a CRTC, `float` version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



cdef extern int libgamma_crtc_get_gamma_rampsd(libgamma_crtc_state_t* this, libgamma_gamma_rampsd_t* ramps)
'''
Get current the gamma ramps for a CRTC, `double` version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to fill with the current values.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''


cdef extern int libgamma_crtc_set_gamma_rampsd(libgamma_crtc_state_t* this, libgamma_gamma_rampsd_t ramps)
'''
Set the gamma ramps for a CRTC, `double` version.

@param   this   The CRTC state.
@param   ramps  The gamma ramps to apply.
@return         Zero on success, otherwise (negative) the value of an
                error identifier provided by this library.
'''



def libgamma_native_list_methods(operation : int) -> list:
    '''
    List available adjustment methods by their order of preference based on the environment.
    
    @param  operation    Allowed values:
                           0: Methods that the environment suggests will work, excluding fake.
                           1: Methods that the environment suggests will work, including fake.
                           2: All real non-fake methods.
                           3: All real methods.
                           4: All methods.
                         Other values invoke undefined behaviour.
    @return  :list<int>  A list of available adjustment methods.
    '''
    cdef int* methods
    cdef size_t buf_size
    cdef size_t r
    buf_size = 6
    methods = <int*>malloc(buf_size * sizeof(size_t))
    if methods == NULL:
        raise MemoryError()
    r = libgamma_list_methods(methods, buf_size, operation)
    if r > buf_size:
        buf_size = r
        free(methods)
        methods = <int*>malloc(buf_size * sizeof(size_t))
        if methods == NULL:
            raise MemoryError()
        libgamma_list_methods(methods, buf_size, operation)
    rc = []
    for i in range(r):
        rc.append(methods[i])
    free(methods)
    return rc


def libgamma_native_is_method_available(method : int) -> int:
    '''
    Check whether an adjustment method is available, non-existing (invalid) methods will be
    identified as not available under the rationale that the library may be out of date.
    
    @param   method  The adjustment method.
    @return          Whether the adjustment method is available.
    '''
    return int(libgamma_is_method_available(<int>method))


def libgamma_native_method_capabilities(method : int) -> tuple:
    '''
    Return the capabilities of an adjustment method.
    
    @param   method       The adjustment method (display server and protocol).
    @return  :(int, int)  Input parameters for `MethodCapabilities.__init__`
    '''
    cdef libgamma_method_capabilities_t caps
    libgamma_method_capabilities(&caps, <int>method)
    booleans = 0
    crtc_information = int(caps.crtc_information)
    booleans |= (0 if caps.default_site_known            == 0 else 1) <<  0
    booleans |= (0 if caps.multiple_sites                == 0 else 1) <<  1
    booleans |= (0 if caps.multiple_partitions           == 0 else 1) <<  2
    booleans |= (0 if caps.multiple_crtcs                == 0 else 1) <<  3
    booleans |= (0 if caps.partitions_are_graphics_cards == 0 else 1) <<  4
    booleans |= (0 if caps.site_restore                  == 0 else 1) <<  5
    booleans |= (0 if caps.partition_restore             == 0 else 1) <<  6
    booleans |= (0 if caps.crtc_restore                  == 0 else 1) <<  7
    booleans |= (0 if caps.identical_gamma_sizes         == 0 else 1) <<  8
    booleans |= (0 if caps.fixed_gamma_size              == 0 else 1) <<  9
    booleans |= (0 if caps.fixed_gamma_depth             == 0 else 1) << 10
    booleans |= (0 if caps.real                          == 0 else 1) << 11
    booleans |= (0 if caps.fake                          == 0 else 1) << 12
    return (crtc_information, booleans)


def libgamma_native_method_default_site(method : int) -> str:
    '''
    Return the capabilities of an adjustment method.
    
    @param   method  The adjustment method (display server and protocol.)
    @return          The default site, `None` if it cannot be determined or
                     if multiple sites are not supported by the adjustment
                     method.
    '''
    cdef char* var
    cdef bytes bs
    var = libgamma_method_default_site(<int>method)
    bs = var
    return bs.decode('utf-8', 'strict')


def libgamma_native_method_default_site_variable(method : int) -> str:
    '''
    Return the capabilities of an adjustment method.
    
    @param   method  The adjustment method (display server and protocol.)
    @return          The environ variables that is used to determine the
                     default site. `None` if there is none, that is, if
                     the method does not support multiple sites.
    '''
    cdef const char* var
    cdef bytes bs
    var = libgamma_method_default_site_variable(<int>method)
    bs = var
    return bs.decode('utf-8', 'strict')



def libgamma_native_site_create(method : int, site : str) -> tuple:
    '''
    Create an allocated site state.
    
    @param   method                       The adjustment method (display server and protocol.)
    @param   site                         The site identifier, unless it is `NULL` it must a
                                          `free`:able. One the state is destroyed the library
                                          will attempt to free it. There you should not free
                                          it yourself, and it must not be a string constant
                                          or allocate on the stack. Note however that it will
                                          not be `free`:d if this function fails.
    @return  :(site:int, partitions:int)  First value:   The created site, zero on error
                                          Second value:  The number of partitions in the site, -1 on error
    '''
    cdef libgamma_site_state_t* this
    cdef char* site_
    cdef size_t this_address
    this = <libgamma_site_state_t*>malloc(sizeof(libgamma_site_state_t))
    if this is NULL:
        raise MemoryError()
    this_address = <size_t><void*>this
    site_ = NULL
    if site is not None:
        site_bs = site.encode('utf-8') + bytes([0])
        site_ = <char*>malloc(len(site_bs) * sizeof(char))
        if site_ is None:
            free(this)
            raise MemoryError()
        for i in range(len(site_bs)):
            site_[i] = <char>(site_bs[i])
    r = int(libgamma_site_initialise(this, <int>method, site_))
    if r < 0:
        libgamma_site_free(this)
        return (0, -1)
    return (int(this_address), int(this.partitions_available))


def libgamma_native_site_free(this : int):
    '''
    Release all resources held by a site state
    and free the CRTC state pointer.
    
    @param  this  The site state.
    '''
    cdef size_t this_address
    cdef libgamma_site_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_site_state_t*><void*>this_address
    libgamma_site_free(this_)


def libgamma_native_site_restore(this : int) -> int:
    '''
    Restore the gamma ramps all CRTC:s with a site to the system settings.
    
    @param   this  The site state.
    @return        Zero on success, otherwise (negative) the value of an
                   error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef libgamma_site_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_site_state_t*><void*>this_address
    return int(libgamma_site_restore(this_))



def libgamma_native_partition_create(site : int, partition : int) -> tuple:
    '''
    Create an allocated partition state.
    
    @param   site                         The site state for the site that the partition belongs to.
    @param   partition                    The index of the partition within the site.
    @return  :(site:int, partitions:int)  First value:   The created partition, zero on error
                                          Second value:  The number of CRTC:s in the partition, -1 on error
    '''
    cdef libgamma_partition_state_t* this
    cdef libgamma_site_state_t* site_
    cdef size_t this_address
    cdef size_t site_address
    site_address = <size_t>site
    site_ = <libgamma_site_state_t*><void*>site_address
    this = <libgamma_partition_state_t*>malloc(sizeof(libgamma_partition_state_t))
    if this is NULL:
        raise MemoryError()
    this_address = <size_t><void*>this
    r = int(libgamma_partition_initialise(this, site_, <size_t>partition))
    if r < 0:
        libgamma_partition_free(this)
        return (0, -1)
    return (int(this_address), int(this.crtcs_available))


def libgamma_native_partition_free(this : int):
    '''
    Release all resources held by a partition state
    and free the partition state pointer.
    
    @param  this  The partition state.
    '''
    cdef size_t this_address
    cdef libgamma_partition_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_partition_state_t*><void*>this_address
    libgamma_partition_free(this_)


def libgamma_native_partition_restore(this : int) -> int:
    '''
    Restore the gamma ramps all CRTC:s with a partition to the system settings.
    
    @param   this  The partition state.
    @return        Zero on success, otherwise (negative) the value of an
                   error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef libgamma_partition_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_partition_state_t*><void*>this_address
    return int(libgamma_partition_restore(this_))



def libgamma_native_crtc_create(partition : int, crtc : int) -> int:
    '''
    Create an allocated CRTC state.
    
    @param   partition  The partition state for the partition that the CRTC belongs to.
    @param   crtc       The index of the CRTC within the partition.
    @return             The created CRTC, zero on error
    '''
    cdef libgamma_crtc_state_t* this
    cdef libgamma_partition_state_t* partition_
    cdef size_t this_address
    cdef size_t partition_address
    partition_address = <size_t>partition
    partition_ = <libgamma_partition_state_t*><void*>partition_address
    this = <libgamma_crtc_state_t*>malloc(sizeof(libgamma_crtc_state_t))
    if this is NULL:
        raise MemoryError()
    this_address = <size_t><void*>this
    r = int(libgamma_crtc_initialise(this, partition_, <size_t>crtc))
    if r < 0:
        libgamma_crtc_free(this)
        return 0
    return int(this_address)


def libgamma_native_crtc_free(this : int):
    '''
    Release all resources held by a CRTC state
    and free the CRTC state pointer.
    
    @param  this  The CRTC state.
    '''
    cdef size_t this_address
    cdef libgamma_crtc_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_crtc_state_t*><void*>this_address
    libgamma_crtc_free(this_)


def libgamma_native_crtc_restore(this : int) -> int:
    '''
    Restore the gamma ramps for a CRTC to the system settings for that CRTC.
    
    @param   this  The CRTC state
    @return        Zero on success, otherwise (negative) the value of an
                   error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef libgamma_crtc_state_t* this_
    this_address = <size_t>this
    this_ = <libgamma_crtc_state_t*><void*>this_address
    return int(libgamma_crtc_restore(this_))



def libgamma_native_get_crtc_information(crtc : int, fields : int) -> tuple:
    '''
    Read information about a CRTC.
    
    @param   crtc           The state of the CRTC whose information should be read.
    @param   field          OR:ed identifiers for the information about the CRTC that should be read.
    @return  :(list, :int)  First value:   Input parametrs for `CRTCInformation.__init__`
                            Second value:  Zero on success, -1 on error. On error refer to the error reports in the return.
    '''
    cdef libgamma_crtc_information_t info
    cdef size_t crtc_address
    cdef libgamma_crtc_state_t* crtc_
    cdef bytes bs
    crtc_address = <size_t>crtc
    crtc_ = <libgamma_crtc_state_t*><void*>crtc_address
    r = int(libgamma_get_crtc_information(&info, crtc_, <int32_t>fields))
    rc = []
    connector_name = None
    if info.connector_name is not NULL:
        bs = info.connector_name
        connector_name = bs.decode('utf-8', 'strict')
    edid = None
    if info.edid is not NULL:
        bs = info.edid[:info.edid_length]
        edid = bs
    rc.append(edid)
    rc.append(int(info.edid_error))
    rc.append(int(info.width_mm))
    rc.append(int(info.width_mm_error))
    rc.append(int(info.height_mm))
    rc.append(int(info.height_mm_error))
    rc.append(int(info.width_mm_edid))
    rc.append(int(info.width_mm_edid_error))
    rc.append(int(info.height_mm_edid))
    rc.append(int(info.height_mm_edid_error))
    rc.append(int(info.red_gamma_size))
    rc.append(int(info.green_gamma_size))
    rc.append(int(info.blue_gamma_size))
    rc.append(int(info.gamma_size_error))
    rc.append(int(info.gamma_depth))
    rc.append(int(info.gamma_depth_error))
    rc.append(int(info.gamma_support))
    rc.append(int(info.gamma_support_error))
    rc.append(int(info.subpixel_order))
    rc.append(int(info.subpixel_order_error))
    rc.append(int(info.active))
    rc.append(int(info.active_error))
    rc.append(connector_name)
    rc.append(int(info.connector_name_error))
    rc.append(int(info.connector_type))
    rc.append(int(info.connector_type_error))
    rc.append(float(info.gamma_red))
    rc.append(float(info.gamma_green))
    rc.append(float(info.gamma_blue))
    rc.append(int(info.gamma_error))
    libgamma_crtc_information_destroy(&info)
    return (rc, r)



def libgamma_native_crtc_get_gamma_ramps8(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, 8-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps8_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps8_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_ramps8(this_, ramps_))


def libgamma_native_crtc_set_gamma_ramps8(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, 8-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps8_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps8_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_ramps8(this_, ramps_[0]))



def libgamma_native_crtc_get_gamma_ramps16(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, 16-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps16_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps16_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_ramps16(this_, ramps_))


def libgamma_native_crtc_set_gamma_ramps16(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, 16-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps16_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps16_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_ramps16(this_, ramps_[0]))



def libgamma_native_crtc_get_gamma_ramps32(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, 32-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps32_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps32_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_ramps32(this_, ramps_))


def libgamma_native_crtc_set_gamma_ramps32(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, 32-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps32_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps32_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_ramps32(this_, ramps_[0]))



def libgamma_native_crtc_get_gamma_ramps64(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, 64-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps64_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps64_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_ramps64(this_, ramps_))


def libgamma_native_crtc_set_gamma_ramps64(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, 64-bit gamma-depth version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_ramps64_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_ramps64_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_ramps64(this_, ramps_[0]))



def libgamma_native_crtc_get_gamma_rampsf(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, `float` version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_rampsf_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_rampsf_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_rampsf(this_, ramps_))


def libgamma_native_crtc_set_gamma_rampsf(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, `float` version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_rampsf_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_rampsf_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_rampsf(this_, ramps_[0]))



def libgamma_native_crtc_get_gamma_rampsd(this : int, ramps : int) -> int:
    '''
    Get current the gamma ramps for a CRTC, `double` version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to fill with the current values.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_rampsd_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_rampsd_t*><void*>ramps_address
    return int(libgamma_crtc_get_gamma_rampsd(this_, ramps_))


def libgamma_native_crtc_set_gamma_rampsd(this : int, ramps : int) -> int:
    '''
    Set the gamma ramps for a CRTC, `double` version.
    
    @param   this   The CRTC state.
    @param   ramps  The gamma ramps to apply.
    @return         Zero on success, otherwise (negative) the value of an
                    error identifier provided by this library.
    '''
    cdef size_t this_address
    cdef size_t ramps_address
    cdef libgamma_crtc_state_t* this_
    cdef libgamma_gamma_rampsd_t* ramps_
    this_address = <size_t>this
    ramps_address = <size_t>ramps
    this_ = <libgamma_crtc_state_t*><void*>this_address
    ramps_ = <libgamma_gamma_rampsd_t*><void*>ramps_address
    return int(libgamma_crtc_set_gamma_rampsd(this_, ramps_[0]))

