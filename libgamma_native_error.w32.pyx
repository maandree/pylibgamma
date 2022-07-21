# -*- python -*-
# See LICENSE file for copyright and license details.
cimport cython


cdef extern short libgamma_group_gid
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned
'''

cdef extern const char* libgamma_group_name
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
`NULL` if the name of the group `libgamma_group_gid`
cannot be determined
'''


cdef extern void libgamma_perror(const char *name, int error_code) nogil
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

@param  name   The text to add at the beginning
@param  value  The error code, may be an `errno` value
'''

cdef extern const char *libgamma_name_of_error(int value) nogil
'''
Returns the name of the definition associated with a `libgamma` error code

@param   value  The error code
@return         The name of the definition associated with the error code,
                `NULL` if the error code does not exist. The return string
                should not be `free`:d
'''

cdef extern int libgamma_value_of_error(const char *name) nogil
'''
Return the value of a `libgamma` error definition refered to by name

@param   name  The name of the definition associated with the error code
@return        The error code, zero if the name does is `NULL`
               or does not refer to a `libgamma` error
'''


def libgamma_native_get_group_gid() -> int:
    '''
    Getter
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned
    '''
    return int(libgamma_group_gid)


def libgamma_native_set_group_gid(gid : int):
    '''
    Setter
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned
    '''
    libgamma_group_gid = <int>gid


def libgamma_native_get_group_name() -> str:
    '''
    Getter
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
    `None` if the name of the group `libgamma_group_gid`
    cannot be determined
    '''
    cdef bytes bs
    if libgamma_group_name is NULL:
        return None
    bs = libgamma_group_name
    return bs.decode('utf-8', 'strict')


def libgamma_native_set_group_name(name : str):
    '''
    Setter
    
    Group that the user needs to be a member of if
    `LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
    `None` if the name of the group `libgamma_group_gid`
    cannot be determined
    '''
    cdef bytes bs
    if name is None:
        libgamma_group_name = <char *>NULL
        return
    bs = name.encode('utf-8') + bytes([0])
    libgamma_group_name = bs


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
    
    @param  name   The text to add at the beginning
    @param  value  The error code, may be an `errno` value
    '''
    cdef bytes bs
    bs = name.encode('utf-8') + bytes([0])
    libgamma_perror(bs, <int>error_code)


def libgamma_native_name_of_error(value : int) -> str:
    '''
    Returns the name of the definition associated with a `libgamma` error code
    
    @param   value  The error code
    @return         The name of the definition associated with the error code,
                    `None` if the error code does not exist. The return string
                    should not be `free`:d
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
    Return the value of a `libgamma` error definition refered to by name
    
    @param   name  The name of the definition associated with the error code
    @return        The error code, zero if the name is `None`,
                   or does not refer to a `libgamma` error
    '''
    cdef bytes bs
    if name is None:
        return 0
    bs = name.encode('utf-8') + bytes([0])
    return int(libgamma_value_of_error(bs))

