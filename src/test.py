#!/usr/bin/env python3
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

import libgamma
from time import sleep


method = libgamma.list_methods(0)[0]
assert libgamma.is_method_available(method) == True

print(libgamma.method_capabilities(method).__dict__)
print()

print(repr(libgamma.method_default_site_variable(method)))
print(repr(libgamma.method_default_site(method)))
print

print(repr(libgamma.unhex_edid('0123456789ABCDEF')))
print(repr(libgamma.unhex_edid('0123456789abcdef')))
print(repr(libgamma.behex_edid(libgamma.unhex_edid('0123456789abcdef'))))
print(repr(libgamma.behex_edid_lowercase(libgamma.unhex_edid('0123456789abcdef'))))
print(repr(libgamma.behex_edid_uppercase(libgamma.unhex_edid('0123456789abcdef'))))
print()

print(libgamma.group.gid)
libgamma.group.gid = 10
print(libgamma.group.gid)
print()

print(repr(libgamma.group.name))
libgamma.group.name = 'group'
print(repr(libgamma.group.name))
print()

libgamma.perror('test', 0)
libgamma.perror('test', libgamma.LIBGAMMA_ERRNO_SET)
libgamma.perror('test', libgamma.LIBGAMMA_NO_SUCH_ADJUSTMENT_METHOD)
print()

print(repr(libgamma.name_of_error(libgamma.LIBGAMMA_NO_SUCH_SITE)))
print(repr(libgamma.value_of_error('LIBGAMMA_NO_SUCH_SITE')))
print(libgamma.LIBGAMMA_NO_SUCH_SITE)
print()

print(libgamma.create_error(1))
print(libgamma.create_error(0))
print(libgamma.create_error(-1))
print(libgamma.create_error(-2))
print()

site = libgamma.Site(method)
print(site.partitions_available)
partition = libgamma.Partition(site, 0)
print(partition.crtcs_available)
crtc = libgamma.CRTC(partition, 0)
info = crtc.information(~0)[0]
print(info.__dict__)
print()

ramp_sizes = (info.red_gamma_size, info.green_gamma_size, info.blue_gamma_size)
ramps = libgamma.GammaRamps(*ramp_sizes, depth = info.gamma_depth)
crtc.get_gamma(ramps)
print(list(ramps.red))
print()
print(list(ramps.green))
print()
print(list(ramps.blue))
print()

saved_red = list(ramps.red)
saved_green = list(ramps.green)
saved_blue = list(ramps.blue)

ramps.red[:] = list(map(lambda x : x // 2, saved_red))
ramps.green[:] = list(map(lambda x : x // 2, saved_green))
ramps.blue[:] = list(map(lambda x : x // 2, saved_blue))

crtc.set_gamma(ramps)

sleep(1)

ramps.red[:] = saved_red
ramps.green[:] = saved_green
ramps.blue[:] = saved_blue

crtc.set_gamma(ramps)

# If not done expressively, if in the root scope,
# we sometimes get ignored errors on exit
del site
del partition
del crtc
del ramps

