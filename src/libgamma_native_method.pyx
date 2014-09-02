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

from libc.stdint cimport *
from libc.stdlib cimport malloc
from libc.stddef cimport size_t
from libc.errno cimport errno


cdef extern from "libgamma/libgamma-method.h":
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


cdef extern int libgamma_gamma_ramps8_initialise(libgamma_gamma_ramps8_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps.
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_ramps8_free(libgamma_gamma_ramps8_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps8_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''


cdef extern int libgamma_gamma_ramps16_initialise(libgamma_gamma_ramps16_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps.
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_ramps16_free(libgamma_gamma_ramps16_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps16_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''


cdef extern int libgamma_gamma_ramps32_initialise(libgamma_gamma_ramps32_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps.
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_ramps32_free(libgamma_gamma_ramps32_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps32_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''


cdef extern int libgamma_gamma_ramps64_initialise(libgamma_gamma_ramps64_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps.
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_ramps64_free(libgamma_gamma_ramps64_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_ramps64_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''


cdef extern int libgamma_gamma_rampsf_initialise(libgamma_gamma_rampsf_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps.
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_rampsf_free(libgamma_gamma_rampsf_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_rampsf_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''


cdef extern int libgamma_gamma_rampsd_initialise(libgamma_gamma_rampsd_t* this)
'''
Initialise a gamma ramp in the proper way that allows all adjustment
methods to read from and write to it without causing segmentation violation.

The input must have `red_size`, `green_size` and `blue_size` set to the
sizes of the gamma ramps that should be allocated.

@param   this  The gamma ramps
@return        Zero on success, -1 on allocation error, `errno` will be set accordingly.
'''

cdef extern void libgamma_gamma_rampsd_free(libgamma_gamma_rampsd_t* this)
'''
Release resources that are held by a gamma ramp strcuture that
has been allocated by `libgamma_gamma_rampsd_initialise` or otherwise
initialises in the proper manner, as well as release the pointer
to the structure.

@param  this  The gamma ramps.
'''



def libgamma_native_gamma_ramps8_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_ramps8_t))
    cdef libgamma_gamma_ramps8_t* item = <libgamma_gamma_ramps8_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_ramps8_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps8_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_ramps8_t* item = <libgamma_gamma_ramps8_t*>address
    libgamma_gamma_ramps8_free(item)


def libgamma_native_gamma_ramps8_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint8_t* ramp = <uint8_t*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps8_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint8_t* ramp = <uint8_t*>address
    ramp[<size_t>index] = <uint8_t>value



def libgamma_native_gamma_ramps16_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_ramps16_t))
    cdef libgamma_gamma_ramps16_t* item = <libgamma_gamma_ramps16_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_ramps16_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps16_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_ramps16_t* item = <libgamma_gamma_ramps16_t*>address
    libgamma_gamma_ramps16_free(item)


def libgamma_native_gamma_ramps16_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint16_t* ramp = <uint16_t*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps16_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint16_t* ramp = <uint16_t*>address
    ramp[<size_t>index] = <uint16_t>value



def libgamma_native_gamma_ramps32_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_ramps32_t))
    cdef libgamma_gamma_ramps32_t* item = <libgamma_gamma_ramps32_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_ramps32_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps32_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_ramps32_t* item = <libgamma_gamma_ramps32_t*>address
    libgamma_gamma_ramps32_free(item)


def libgamma_native_gamma_ramps32_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint32_t* ramp = <uint32_t*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps32_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint32_t* ramp = <uint32_t*>address
    ramp[<size_t>index] = <uint32_t>value



def libgamma_native_gamma_ramps64_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_ramps64_t))
    cdef libgamma_gamma_ramps64_t* item = <libgamma_gamma_ramps64_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_ramps64_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_ramps64_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_ramps64_t* item = <libgamma_gamma_ramps64_t*>address
    libgamma_gamma_ramps64_free(item)


def libgamma_native_gamma_ramps64_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint64_t* ramp = <uint64_t*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_ramps64_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef uint64_t* ramp = <uint64_t*>address
    ramp[<size_t>index] = <uint64_t>value



def libgamma_native_gamma_rampsf_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_rampsf_t))
    cdef libgamma_gamma_rampsf_t* item = <libgamma_gamma_rampsf_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_rampsf_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_rampsf_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_rampsf_t* item = <libgamma_gamma_rampsf_t*>address
    libgamma_gamma_rampsf_free(item)


def libgamma_native_gamma_rampsf_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef float* ramp = <float*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_rampsf_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef float* ramp = <float*>address
    ramp[<size_t>index] = <float>value



def libgamma_native_gamma_rampsd_create(red_size : int, green_size : int, blue_size : int):
    '''
    Create a gamma ramp in the proper way that allows all adjustment
    methods to read from and write to it without causing segmentation violation.
    
    @param   red_size       The size of the gamma ramp for the red channel
    @param   green_size     The size of the gamma ramp for the green channel
    @param   blue_size      The size of the gamma ramp for the blue channel
    @return  :(int){4}|int  The tuple that describes the created data, `errno` on failure:
                              Element 1:  The address of the gamma ramp structure
                              Element 2:  The address of the gamma ramp for the red channel
                              Element 3:  The address of the gamma ramp for the green channel
                              Element 4:  The address of the gamma ramp for the blue channel
    '''
    cdef void* allocation = malloc(sizeof(libgamma_gamma_rampsd_t))
    cdef libgamma_gamma_rampsd_t* item = <libgamma_gamma_rampsd_t*>allocation
    cdef size_t red, green, blue
    if item is NULL:
        return errno
    red   = <size_t><void*>(item.red)
    green = <size_t><void*>(item.green)
    blue  = <size_t><void*>(item.blue)
    return (int(<size_t>allocation), int(red), int(blue), int(blue))


def libgamma_native_gamma_rampsd_free(this : int):
    '''
    Release resources that are held by a gamma ramp strcuture that
    has been allocated by `libgamma_native_gamma_rampsd_create` or otherwise
    created in the proper manner, as well as release the pointer
    to the structure.
    
    @param  this  The gamma ramps.
    '''
    cdef void* address = <void*><size_t>this
    cdef libgamma_gamma_rampsd_t* item = <libgamma_gamma_rampsd_t*>address
    libgamma_gamma_rampsd_free(item)


def libgamma_native_gamma_rampsd_get(this : int, index : int) -> int:
    '''
    Read a stop in a gamma ramp.
    
    @param   this   The gamma ramp.
    @param   index  The index of the gamma ramp stop.
    @return         The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef double* ramp = <double*>address
    return int(ramp[<size_t>index])


def libgamma_native_gamma_rampsd_set(this : int, index : int, value : int):
    '''
    Modify a stop in a gamma ramp.
    
    @param  this   The gamma ramp.
    @param  index  The index of the gamma ramp stop.
    @param  value  The value of the gamma ramp stop.
    '''
    cdef void* address = <void*><size_t>this
    cdef double* ramp = <double*>address
    ramp[<size_t>index] = <double>value

