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



class LibgammaGroupGid:
    '''
    Data descriptor for accessing the
    `libgamma_group_gid` variable.
    '''
    
    def __init__(self):
        '''
        Constructor.
        '''
        pass
    
    def __get__(self, obj, obj_type = None) -> int:
        '''
        Getter.
        '''
        from libgamma_native_error import libgamma_native_get_group_gid
        return libgamma_native_get_group_gid()
    
    def __set__(self, obj, value : int):
        '''
        Setter.
        '''
        from libgamma_native_error import libgamma_native_set_group_gid
        return libgamma_native_set_group_gid(value)

group_gid = LibgammaGroupGid()
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned.
'''


class LibgammaGroupName:
    '''
    Data descriptor for accessing the
    `libgamma_group_name` variable.
    '''
    
    def __init__(self):
        '''
        Constructor.
        '''
        pass
    
    def __get__(self, obj, obj_type = None) -> str:
        '''
        Getter.
        '''
        from libgamma_native_error import libgamma_native_get_group_name
        return libgamma_native_get_group_name()
    
    def __set__(self, obj, value : str):
        '''
        Setter.
        '''
        from libgamma_native_error import libgamma_native_set_group_name
        return libgamma_native_set_group_name()

group_name = LibgammaGroupName()
'''
Group that the user needs to be a member of if
`LIBGAMMA_DEVICE_REQUIRE_GROUP` is returned,
`None` if the name of the group `group_gid`
cannot be determined.
'''


def perror(name : str, error_code : int):
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
    from libgamma_native_error import libgamma_native_perror
    libgamma_native_perror(name, error_code)


def name_of_error(value : int) -> str:
    '''
    Returns the name of the definition associated with a `libgamma` error code.
    
    @param   value  The error code.
    @return         The name of the definition associated with the error code,
                    `None` if the error code does not exist.
    '''
    from libgamma_native_error import libgamma_native_name_of_error
    return libgamma_native_name_of_error(value)


def value_of_error(name : str) -> int:
    '''
    Return the value of a `libgamma` error definition refered to by name.
    
    @param   name  The name of the definition associated with the error code.
    @return        The error code, zero if the name is `None`
                   or does not refer to a `libgamma` error.
    '''
    from libgamma_native_error import libgamma_native_value_of_error
    return libgamma_native_value_of_error(name)



LIBGAMMA_NO_SUCH_ADJUSTMENT_METHOD = -1
'''
The selected adjustment method does not exist
or has been excluded at compile-time.
'''

LIBGAMMA_ERRNO_SET = -2
'''
`errno` has be set with a standard error number
to indicate the what has gone wrong.
'''

LIBGAMMA_NO_SUCH_SITE = -3
'''
The selected site does not exist.
'''

LIBGAMMA_NO_SUCH_PARTITION = -4
'''
The selected partition does not exist.
'''

LIBGAMMA_NO_SUCH_CRTC = -5
'''
The selected CRTC does not exist.
'''

LIBGAMMA_IMPOSSIBLE_AMOUNT = -6
'''
Counter overflowed when counting the number
of available items.
'''

LIBGAMMA_CONNECTOR_DISABLED = -7
'''
The selected connector is disabled, it does
not have a CRTC.
'''

LIBGAMMA_OPEN_CRTC_FAILED = -8
'''
The selected CRTC could not be opened,
reason unknown.
'''

LIBGAMMA_CRTC_INFO_NOT_SUPPORTED = -9
'''
The CRTC information field is not supported
by the adjustment method.
'''

LIBGAMMA_GAMMA_RAMP_READ_FAILED = -10
'''
Failed to read the current gamma ramps for
the selected CRTC, reason unknown.
'''

LIBGAMMA_GAMMA_RAMP_WRITE_FAILED = -11
'''
Failed to write the current gamma ramps for
the selected CRTC, reason unknown.
'''

LIBGAMMA_GAMMA_RAMP_SIZE_CHANGED = -12
'''
The specified ramp sizes does not match the
ramps sizes returned by the adjustment methods
in response to the query/command.
'''

LIBGAMMA_MIXED_GAMMA_RAMP_SIZE = -13
'''
The specified ramp sizes are not identical
which is required by the adjustment method.
(Only returned in debug mode.)
'''

LIBGAMMA_WRONG_GAMMA_RAMP_SIZE = -14
'''
The specified ramp sizes are not supported
by the adjustment method.
(Only returned in debug mode.)
'''

LIBGAMMA_SINGLETON_GAMMA_RAMP = -15
'''
The adjustment method reported that the gamma
ramps size is 1, or perhaps even zero or negative.
'''

LIBGAMMA_LIST_CRTCS_FAILED = -16
'''
The adjustment method failed to list
available CRTC:s, reason unknown.
'''

LIBGAMMA_ACQUIRING_MODE_RESOURCES_FAILED = -17
'''
Failed to acquire mode resources from the
adjustment method.
'''

LIBGAMMA_NEGATIVE_PARTITION_COUNT = -18
'''
The adjustment method reported that a negative
number of partitions exists in the site.
'''

LIBGAMMA_NEGATIVE_CRTC_COUNT = -19
'''
The adjustment method reported that a negative
number of CRTC:s exists in the partition.
'''

LIBGAMMA_DEVICE_RESTRICTED = -20
'''
Device cannot be access becauses of
insufficient permissions.
'''

LIBGAMMA_DEVICE_ACCESS_FAILED = -21
'''
Device cannot be access, reason unknown.
'''

LIBGAMMA_DEVICE_REQUIRE_GROUP = -22
'''
Device cannot be access, membership of the
`group_gid` (named by `group_name` (can be
`None`, if so `errno` may have been set to
tell why)) is required.
'''

LIBGAMMA_GRAPHICS_CARD_REMOVED = -23
'''
The graphics card appear to have been removed.
'''

LIBGAMMA_STATE_UNKNOWN = -24
'''
The state of the requested information is unknown.
'''

LIBGAMMA_CONNECTOR_UNKNOWN = -25
'''
Failed to determine which connector the
CRTC belongs to.
'''

LIBGAMMA_CONNECTOR_TYPE_NOT_RECOGNISED = -26
'''
The detected connector type is not listed
in this library and has to be updated.
'''

LIBGAMMA_SUBPIXEL_ORDER_NOT_RECOGNISED = -27
'''
The detected subpixel order is not listed
in this library and has to be updated.
'''

LIBGAMMA_EDID_LENGTH_UNSUPPORTED = -28
'''
The length of the EDID does not match that
of any supported EDID structure revision.
'''

LIBGAMMA_EDID_WRONG_MAGIC_NUMBER = -29
'''
The magic number in the EDID does not match
that of any supported EDID structure revision.
'''

LIBGAMMA_EDID_REVISION_UNSUPPORTED = -30
'''
The EDID structure revision used by the
monitor is not supported.
'''

LIBGAMMA_GAMMA_NOT_SPECIFIED = -31
'''
The gamma characteristics field in the EDID
is left unspecified.
(This could be considered a non-error.)
'''

LIBGAMMA_EDID_CHECKSUM_ERROR = -32
'''
The checksum in the EDID is incorrect, all
request information has been provided
by you cannot count on it.
'''

LIBGAMMA_GAMMA_NOT_SPECIFIED_AND_EDID_CHECKSUM_ERROR = -33
'''
Both of the errors `LIBGAMMA_GAMMA_NOT_SPECIFIED`
and `LIBGAMMA_EDID_CHECKSUM_ERROR` have occurred.
'''

LIBGAMMA_GAMMA_RAMPS_SIZE_QUERY_FAILED = -34
'''
Failed to query the gamma ramps size from the
adjustment method, reason unknown.
'''

LIBGAMMA_OPEN_PARTITION_FAILED = -35
'''
The selected partition could not be opened,
reason unknown.
'''

LIBGAMMA_OPEN_SITE_FAILED = -36
'''
The selected site could not be opened,
reason unknown.
'''

LIBGAMMA_PROTOCOL_VERSION_QUERY_FAILED = -37
'''
Failed to query the adjustment method for
its protocol version, reason unknown.
'''

LIBGAMMA_PROTOCOL_VERSION_NOT_SUPPORTED = -38
'''
The adjustment method's version of its
protocol is not supported.
'''

LIBGAMMA_LIST_PARTITIONS_FAILED = -39
'''
The adjustment method failed to list
available partitions, reason unknown.
'''

LIBGAMMA_NULL_PARTITION = -40
'''
Partition exists by index, but the partition
at that index does not exist.
'''

LIBGAMMA_NOT_CONNECTED = -41
'''
There is not monitor connected to the
connector of the selected CRTC.
'''

LIBGAMMA_REPLY_VALUE_EXTRACTION_FAILED = -42
'''
Data extraction from a reply from the
adjustment method failed, reason unknown.
'''

LIBGAMMA_EDID_NOT_FOUND = -43
'''
No EDID property was found on the output.
'''

LIBGAMMA_LIST_PROPERTIES_FAILED = -44
'''
Failed to list properties on the output,
reason unknown.
'''

LIBGAMMA_PROPERTY_VALUE_QUERY_FAILED = -45
'''
Failed to query a property's value from
the output, reason unknown.
'''

LIBGAMMA_OUTPUT_INFORMATION_QUERY_FAILED = -46
'''
A request for information on an output
failed, reason unknown.
'''


LIBGAMMA_ERROR_MIN = -46
'''
The number of the libgamma error with the
lowest number. If this is lower than the
number your program thinks it should be sould
update your program for new errors.
'''

