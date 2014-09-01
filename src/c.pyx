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

from libc.string cimport strerror as c_strerror


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

