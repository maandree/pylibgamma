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

from posix.unistd cimport gid_t
from libc.string cimport strerror as c_strerror


cdef extern gid_t libgamma_group_gid_get()
cdef extern void libgamma_group_gid_set(gid_t)
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned.
'''

cdef extern const char* libgamma_group_name_get()
cdef extern void libgamma_group_name_set(const char*)
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
`NULL` if the name of the group `libgamma_group_gid`
cannot be determined.
'''


cdef extern void libgamma_perror(const char* name, int error_code)
'''
Prints an error to stderr in a `perror` fashion,
however this function will not translate the `libgamma`
errors into human-readable strings, it will simply
print the name of the error. If the value `error_code`
is the value of `LIBGAMMA_ERRNO_SET`, `perror` will be
used to print the current error stored in `errno`.
If `error_code` is non-negative (an `errno` value`), that
value will be stored in `errno` and `perror` will be
used to print it. Additionally, if the `error_code` is
the value of `LIBGAMMA_DEVICE_REQUIRE_GROUP` the
required group will be printed with its numerical value
and, if known, its name.

@param  name   The text to add at the beginning.
@param  value  The error code, may be an `errno` value.
'''

cdef extern const char* libgamma_name_of_error(int value)
'''
Returns the name of the definition associated with a `libgamma` error code.

@param   value  The error code.
@return         The name of the definition associated with the error code,
                `NULL` if the error code does not exist. The return string
                should not be `free`:d.
'''

cdef extern int libgamma_value_of_error(const char* name)
'''
Return the value of a `libgamma` error definition refered to by name.

@param   name  The name of the definition associated with the error code.
@return        The error code, zero if the name does is `NULL`
               or does not refer to a `libgamma` error.
'''



def libgamma_native_get_group_gid() -> int:
    '''
    Getter.
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned.
    '''
    return int(libgamma_group_gid_get())

def libgamma_native_set_group_gid(gid : int):
    '''
    Setter.
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned.
    '''
    libgamma_group_gid_set(<int>gid)


def libgamma_native_get_group_name() -> str:
    '''
    Getter.
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
    `None` if the name of the group `libgamma_group_gid`
    cannot be determined.
    '''
    cdef const char* group_name
    cdef bytes bs
    group_name = libgamma_group_name_get()
    if group_name is NULL:
        return None
    bs = group_name
    return bs.decode('utf-8', 'strict')

def libgamma_native_set_group_name(name : str):
    '''
    Setter.
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
    `None` if the name of the group `libgamma_group_gid`
    cannot be determined.
    '''
    cdef const char* group_name
    cdef bytes bs
    if name is None:
        libgamma_group_name_set(<char*>NULL)
        return
    bs = name.encode('utf-8') + bytes([0])
    group_name = bs
    libgamma_group_name_set(group_name)


def libgamma_native_perror(name : str, error_code : int):
    '''
    Prints an error to stderr in a `perror` fashion,
    however this function will not translate the `libgamma`
    errors into human-readable strings, it will simply
    print the name of the error. If the value `error_code`
    is the value of `LIBGAMMA_ERRNO_SET`, `perror` will be
    used to print the current error stored in `errno`.
    If `error_code` is non-negative (an `errno` value`), that
    value will be stored in `errno` and `perror` will be
    used to print it. Additionally, if the `error_code` is
    the value of `LIBGAMMA_DEVICE_REQUIRE_GROUP` the
    required group will be printed with its numerical value
    and, if known, its name.
    
    @param  name   The text to add at the beginning.
    @param  value  The error code, may be an `errno` value.
    '''
    cdef bytes bs
    bs = name.encode('utf-8') + bytes([0])
    libgamma_perror(bs, <int>error_code)


def libgamma_native_name_of_error(value : int) -> str:
    '''
    Returns the name of the definition associated with a `libgamma` error code.
    
    @param   value  The error code.
    @return         The name of the definition associated with the error code,
                    `None` if the error code does not exist.
    '''
    cdef const char* name
    cdef bytes bs
    name = libgamma_name_of_error(<int>value)
    if name is NULL:
        return None
    bs = name
    return bs.decode('utf-8', 'strict')


def libgamma_native_value_of_error(name : str) -> int:
    '''
    Return the value of a `libgamma` error definition refered to by name.
    
    @param   name  The name of the definition associated with the error code.
    @return        The error code, zero if the name is `None`,
                   or does not refer to a `libgamma` error.
    '''
    cdef bytes bs
    if name is None:
        return 0
    bs = name.encode('utf-8') + bytes([0])
    return int(libgamma_value_of_error(bs))
    

def strerror(error : int) -> str:
    '''
    Get a textual description of an error.
    
    @param   error  The number of the error.
    @return         The description of the error.
    '''
    cdef const char* text
    cdef bytes bs
    text = c_strerror(<int>error)
    bs = text
    return bs.decode('utf-8', 'strict')

