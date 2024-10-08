# -*- python -*-
# See LICENSE file for copyright and license details.
cimport cython

from libc.stdint cimport *
from libc.stdlib cimport malloc
from libc.stddef cimport size_t
from libc.errno cimport errno


cdef extern from "include-libgamma.h":
    ctypedef struct libgamma_gamma_ramps8 "struct libgamma_gamma_ramps8":
        # Gamma ramp structure for 8-bit gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        uint8_t *red      # The gamma ramp for the red channel
        uint8_t *green    # The gamma ramp for the green channel
        uint8_t *blue     # The gamma ramp for the blue channel

    ctypedef struct libgamma_gamma_ramps16 "struct libgamma_gamma_ramps16":
        # Gamma ramp structure for 16-bit gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        uint16_t *red     # The gamma ramp for the red channel
        uint16_t *green   # The gamma ramp for the green channel
        uint16_t *blue    # The gamma ramp for the blue channel

    ctypedef struct libgamma_gamma_ramps32 "struct libgamma_gamma_ramps32":
        # Gamma ramp structure for 32-bit gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        uint32_t *red     # The gamma ramp for the red channel
        uint32_t *green   # The gamma ramp for the green channel
        uint32_t *blue    # The gamma ramp for the blue channel

    ctypedef struct libgamma_gamma_ramps64 "struct libgamma_gamma_ramps64":
        # Gamma ramp structure for 64-bit gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        uint64_t *red     # The gamma ramp for the red channel
        uint64_t *green   # The gamma ramp for the green channel
        uint64_t *blue    # The gamma ramp for the blue channel

    ctypedef struct libgamma_gamma_rampsf "struct libgamma_gamma_rampsf":
        # Gamma ramp structure for `float` gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        float *red        # The gamma ramp for the red channel
        float *green      # The gamma ramp for the green channel
        float *blue       # The gamma ramp for the blue channel

    ctypedef struct libgamma_gamma_rampsd "struct libgamma_gamma_rampsd":
        # Gamma ramp structure for `double` gamma ramps
        size_t red_size   # The size of `red`
        size_t green_size # The size of `green`
        size_t blue_size  # The size of `blue`
        double *red       # The gamma ramp for the red channel
        double *green     # The gamma ramp for the green channel
        double *blue      # The gamma ramp for the blue channel

cdef extern int libgamma_gamma_ramps8_initialise(libgamma_gamma_ramps8 *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_ramps8_free(libgamma_gamma_ramps8 *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps8_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''

cdef extern int libgamma_gamma_ramps16_initialise(libgamma_gamma_ramps16 *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_ramps16_free(libgamma_gamma_ramps16 *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps16_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''

cdef extern int libgamma_gamma_ramps32_initialise(libgamma_gamma_ramps32 *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_ramps32_free(libgamma_gamma_ramps32 *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps32_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''

cdef extern int libgamma_gamma_ramps64_initialise(libgamma_gamma_ramps64 *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_ramps64_free(libgamma_gamma_ramps64 *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps64_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''

cdef extern int libgamma_gamma_rampsf_initialise(libgamma_gamma_rampsf *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_rampsf_free(libgamma_gamma_rampsf *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_rampsf_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''

cdef extern int libgamma_gamma_rampsd_initialise(libgamma_gamma_rampsd *this) nogil
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation

The input must have `red_size`, `green_size` and `blue_size`
set to the sizes of the gamma ramps that should be allocated

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly
'''

cdef extern void libgamma_gamma_rampsd_free(libgamma_gamma_rampsd *this) nogil
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_rampsd_initialise` or
otherwise initialises in the proper manner, as well as release
the pointer to the structure

@param  this  The gamma ramps
'''


def libgamma_native_gamma_ramps8_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment methods
    to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_ramps8))
    cdef libgamma_gamma_ramps8 *item = <libgamma_gamma_ramps8 *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_ramps8_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_ramps8_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps8_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void *><size_t>this
    cdef libgamma_gamma_ramps8 *item = <libgamma_gamma_ramps8 *>address
    libgamma_gamma_ramps8_free(item)


def libgamma_native_gamma_ramps8_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint8_t *ramp = <uint8_t *>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps8_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint8_t *ramp = <uint8_t *>address
    ramp[<size_t>index] = <uint8_t>value


def libgamma_native_gamma_ramps16_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment methods
    to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_ramps16))
    cdef libgamma_gamma_ramps16 *item = <libgamma_gamma_ramps16 *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_ramps16_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_ramps16_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps16_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void*><size_t>this
    cdef libgamma_gamma_ramps16 *item = <libgamma_gamma_ramps16 *>address
    libgamma_gamma_ramps16_free(item)


def libgamma_native_gamma_ramps16_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint16_t *ramp = <uint16_t *>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps16_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint16_t *ramp = <uint16_t *>address
    ramp[<size_t>index] = <uint16_t>value


def libgamma_native_gamma_ramps32_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment methods
    to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_ramps32))
    cdef libgamma_gamma_ramps32 *item = <libgamma_gamma_ramps32 *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_ramps32_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_ramps32_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps32_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void *><size_t>this
    cdef libgamma_gamma_ramps32 *item = <libgamma_gamma_ramps32 *>address
    libgamma_gamma_ramps32_free(item)


def libgamma_native_gamma_ramps32_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint32_t *ramp = <uint32_t *>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps32_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void*><size_t>this
    cdef uint32_t *ramp = <uint32_t *>address
    ramp[<size_t>index] = <uint32_t>value


def libgamma_native_gamma_ramps64_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment methods
    to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_ramps64))
    cdef libgamma_gamma_ramps64 *item = <libgamma_gamma_ramps64 *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_ramps64_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_ramps64_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps64_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void *><size_t>this
    cdef libgamma_gamma_ramps64 *item = <libgamma_gamma_ramps64 *>address
    libgamma_gamma_ramps64_free(item)


def libgamma_native_gamma_ramps64_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint64_t *ramp = <uint64_t *>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps64_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef uint64_t *ramp = <uint64_t *>address
    ramp[<size_t>index] = <uint64_t>value


def libgamma_native_gamma_rampsf_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment methods
    to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_rampsf))
    cdef libgamma_gamma_rampsf *item = <libgamma_gamma_rampsf *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_rampsf_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_rampsf_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_rampsf_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void *><size_t>this
    cdef libgamma_gamma_rampsf *item = <libgamma_gamma_rampsf *>address
    libgamma_gamma_rampsf_free(item)


def libgamma_native_gamma_rampsf_get(this : int, index : int) -> float:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef float *ramp = <float *>address
    return float(ramp[<size_t>index])


def libgamma_native_gamma_rampsf_set(this : int, index : int, value : float):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef float *ramp = <float *>address
    ramp[<size_t>index] = <float>value


def libgamma_native_gamma_rampsd_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void *allocation = malloc(sizeof(libgamma_gamma_rampsd))
    cdef libgamma_gamma_rampsd *item = <libgamma_gamma_rampsd *>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return int(errno)
    item.red_size   = red_size
    item.green_size = green_size
    item.blue_size  = blue_size
    if libgamma_gamma_rampsd_initialise(item) < 0:
        return int(errno)
    red   = <size_t><void *>(item.red)
    green = <size_t><void *>(item.green)
    blue  = <size_t><void *>(item.blue)
    return (int(<size_t>allocation), int(red), int(green), int(blue))


def libgamma_native_gamma_rampsd_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_rampsd_create` or
    otherwise created in the proper manner, as well as release the
    pointer to the structure
    
    @param  this  The gamma ramps
    '''
    cdef void *address = <void *><size_t>this
    cdef libgamma_gamma_rampsd *item = <libgamma_gamma_rampsd *>address
    libgamma_gamma_rampsd_free(item)


def libgamma_native_gamma_rampsd_get(this : int, index : int) -> float:
    '''
    Read a stop in a gamma ramp
    
    @param   this   The gamma ramp
    @param   index  The index of the gamma ramp stop
    @return         The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef double *ramp = <double *>address
    return float(ramp[<size_t>index])


def libgamma_native_gamma_rampsd_set(this : int, index : int, value : float):
    '''
    Modify a stop in a gamma ramp
    
    @param  this   The gamma ramp
    @param  index  The index of the gamma ramp stop
    @param  value  The value of the gamma ramp stop
    '''
    cdef void *address = <void *><size_t>this
    cdef double *ramp = <double *>address
    ramp[<size_t>index] = <double>value
