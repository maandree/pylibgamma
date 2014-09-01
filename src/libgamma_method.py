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



LIBGAMMA_METHOD_DUMMY = 0
'''
The identifier for the dummy adjustment method.
This method can be configured and is useful for
testing your program's ability to handle errors.
'''

LIBGAMMA_METHOD_X_RANDR = 1
'''
The identifier for the adjustment method with
uses the RandR protocol under the X display server.
'''

LIBGAMMA_METHOD_X_VIDMODE = 2
'''
The identifier for the adjustment method with
uses the VidMode protocol under the X display server.
This is an older alternative to RandR that can
work on some drivers that are not supported by RandR,
however it can only control the primary CRTC per
screen (partition).
'''

LIBGAMMA_METHOD_LINUX_DRM = 3
'''
The identifier for the Direct Rendering Manager
adjustment method that is available in Linux
(built in to the Linux kernel with a userland
library for access) and is a part of the
Direct Rendering Infrastructure. This adjustment
method all work when you are in non-graphical
mode; however a display server cannnot be
started while this is running, but it can be
started while a display server is running.
'''

LIBGAMMA_METHOD_W32_GDI = 4
'''
The identifier for the Graphics Device Interface
adjustment method that is available in Windows.
This method is not well tested; it can be compiled
to be available under X.org using a translation layer.
'''

LIBGAMMA_METHOD_QUARTZ_CORE_GRAPHICS = 5
'''
The identifier for the CoreGraphics adjustment
method that is available in Mac OS X that can
adjust gamma ramps under the Quartz display server.
This method is not well tested; it can be compiled
to be available under X.org using a translation layer.
'''


LIBGAMMA_METHOD_MAX = 5
'''
The index of the last gamma method, neither it
nor any index before it may actually be supported
as it could have been disabled at compile-time
'''

LIBGAMMA_METHOD_COUNT = (LIBGAMMA_METHOD_MAX + 1)
'''
The number adjustment methods provided by this library.
Note however that this includes adjstment methods that
have been removed at compile-time.
'''


class MethodCapabilities:
    '''
    Capabilities of adjustment methods
    
    ---- Integer variables ----
    
    @variable  crtc_information               OR of the CRTC information fields in `CRTCInformation`
                                              that may (but can fail) be read successfully.
    
    ---- Boolean variables ----
    
    @variable  default_site_known             Whether the default site is known, if true the site is integrated
                                              to the system or can be determined using environment variables.
    @variable  multiple_sites                 Whether the adjustment method supports multiple sites rather
                                              than just the default site.
    @variable  multiple_partitions            Whether the adjustment method supports multiple partitions
                                              per site.
    @variable  multiple_crtcs                 Whether the adjustment method supports multiple CRTC:s
                                              per partition per site.
    @variable  partitions_are_graphics_cards  Whether the partition to graphics card is a bijection.
    @variable  site_restore                   Whether the adjustment method supports `site_restore`.
    @variable  partition_restore              Whether the adjustment method supports `partition_restore`.
    @variable  crtc_restore                   Whether the adjustment method supports `crtc_restore`.
    @variable  identical_gamma_sizes          Whether the `red_gamma_size`, `green_gamma_size` and
                                              `blue_gamma_size` fields in `CRTCInformation` will always
                                              have the same values as each other for the adjustment method.
    @variable  fixed_gamma_size               Whether the `red_gamma_size`, `green_gamma_size` and
                                              `blue_gamma_size` fields in `CRTCInformation` will always be
                                              filled with the same value for the adjustment method.
    @variable  fixed_gamma_depth              Whether the `gamma_depth` field in `CRTCInformation` will
                                              always be filled with the same value for the adjustment method.
    @variable  real                           Whether the adjustment method will actually perform adjustments.
    @variable  fake                           Whether the adjustment method is implement using a translation
                                              layer.
    '''
    
    def __init__(self, crtc_information : int = 0, booleans : int = 0):
        '''
        Constructor
        
        @param  crtc_information  The value for `CRTCInformation`
        @param  booleans          The value for each booleanic variable
        '''
        self.crtc_information              = crtc_information
        self.default_site_known            = (booleans & (1 <<  0)) != 0
        self.multiple_sites                = (booleans & (1 <<  1)) != 0
        self.multiple_partitions           = (booleans & (1 <<  2)) != 0
        self.multiple_crtcs                = (booleans & (1 <<  3)) != 0
        self.partitions_are_graphics_cards = (booleans & (1 <<  4)) != 0
        self.site_restore                  = (booleans & (1 <<  5)) != 0
        self.partition_restore             = (booleans & (1 <<  6)) != 0
        self.crtc_restore                  = (booleans & (1 <<  7)) != 0
        self.identical_gamma_sizes         = (booleans & (1 <<  8)) != 0
        self.fixed_gamma_size              = (booleans & (1 <<  9)) != 0
        self.fixed_gamma_depth             = (booleans & (1 << 10)) != 0
        self.real                          = (booleans & (1 << 11)) != 0
        self.fake                          = (booleans & (1 << 12)) != 0


class CRTCInformation:
    '''
    Cathode ray tube controller information data structure.
    
    @variable  edid:bytes                The Extended Display Identification Data associated with
                                         the attached monitor. This is raw byte array that is usually
                                         128 bytes long.
    @variable  edid_error:int            Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  width_mm:int              The phyical width, in millimetres, of the viewport of the
                                         attached monitor, as reported by the adjustment method. This
                                         value may be incorrect, which is a known issue with the X
                                         server where it is the result of the X server attempting
                                         the estimate the size on its own.
                                         Zero means that its is not applicable, which is the case
                                         for projectors.
    @variable  width_mm_error:int        Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    @variable  height_mm:int             The phyical height, in millimetres, of the viewport of the
                                         attached monitor, as reported by the adjustment method. This
                                         value may be incorrect, which is a known issue with the X
                                         server where it is the result of the X server attempting
                                         the estimate the size on its own.
                                         Zero means that its is not applicable, which is the case
                                         for projectors.
    @variable  height_mm_error:int       Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  width_mm_edid:int         The phyical width, in millimetres, of the viewport of the
                                         attached monitor, as reported by it the monitor's Extended
                                         Display Information Data. This value can only contain whole
                                         centimetres, which means that the result is always zero
                                         modulus ten. However, this could change with revisions of
                                         the EDID structure.
                                         Zero means that its is not applicable, which is the case
                                         for projectors.
    @variable  width_mm_edid_error:int   Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    @variable  height_mm_edid:int        The phyical height, in millimetres, of the viewport of the
                                         attached monitor, as reported by it the monitor's Extended
                                         Display Information Data. This value can only contain whole
                                         centimetres, which means that the result is always zero
                                         modulus ten. However, this could change with revisions of
                                         the EDID structure.
                                         Zero means that its is not applicable, which is the case
                                         for projectors.
    @variable  height_mm_edid_error:int  Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  red_gamma_size:int        The size of the encoding axis of the red gamma ramp.
    @variable  green_gamma_size:int      The size of the encoding axis of the green gamma ramp.
    @variable  blue_gamma_size:int       The size of the encoding axis of the blue gamma ramp.
    @variable  gamma_size_error:int      Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  gamma_depth:int           The bit-depth of the value axes of gamma ramps,
                                         -1 for single precision floating point, and -2 for
                                         double precision floating point.
    @variable  gamma_depth_error:int     Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  gamma_support:int         Non-zero gamma ramp adjustments are supported.
    @variable  gamma_support_error:int   Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  subpixel_order:int        The layout of the subpixels.
                                         You cannot count on this value — especially for CRT:s —
                                         but it is provided anyway as a means of distinguishing monitors.
    @variable  subpixel_order_error:int  Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  active:bool               Whether there is a monitors connected to the CRTC.
    @variable  active_error:int          Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  connector_name:str        The name of the connector as designated by the display
                                         server or as give by this library in case the display
                                         server lacks this feature.
    @variable  connector_name_error:int  Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  connector_type:int        The type of the connector that is associated with the CRTC.
    @variable  connector_type_error:int  Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    
    @variable  gamma_red:float           The gamma characteristics of the monitor as reported
                                         in its Extended Display Information Data. The value
                                         holds the value for the red channel. If you do not have
                                         and more accurate measurement of the gamma for the
                                         monitor this could be used to give a rought gamma
                                         correction; simply divide the value with 2.2 and use
                                         the result for the red channel in the gamma correction.
    @variable  gamma_green:float         The gamma characteristics of the monitor as reported
                                         in its Extended Display Information Data. The value
                                         holds the value for the green channel. If you do not have
                                         and more accurate measurement of the gamma for the
                                         monitor this could be used to give a rought gamma
                                         correction; simply divide the value with 2.2 and use
                                         the result for the green channel in the gamma correction.
    @variable  gamma_blue:float          The gamma characteristics of the monitor as reported
                                         in its Extended Display Information Data. The value
                                         holds the value for the blue channel. If you do not have
                                         and more accurate measurement of the gamma for the
                                         monitor this could be used to give a rought gamma
                                         correction; simply divide the value with 2.2 and use
                                         the result for the blue channel in the gamma correction.
    @variable  gamma_error:int           Zero on success, positive it holds the value `errno` had
                                         when the reading failed, otherwise (negative) the value
                                         of an error identifier provided by this library.
    '''
    
    def __init__(self):
        '''
        Constructor
        '''
        pass


LIBGAMMA_CONNECTOR_TYPE_Unknown = 0
'''
The adjustment method does not know the connector's type
(This could be considered an error).
'''

LIBGAMMA_CONNECTOR_TYPE_VGA = 1
'''
Video Graphics Array (VGA).
'''

LIBGAMMA_CONNECTOR_TYPE_DVI = 2
'''
Digital Visual Interface, unknown type.
'''

LIBGAMMA_CONNECTOR_TYPE_DVII = 3
'''
Digital Visual Interface, integrated (DVI-I).
'''

LIBGAMMA_CONNECTOR_TYPE_DVID = 4
'''
Digital Visual Interface, digital only (DVI-D).
'''

LIBGAMMA_CONNECTOR_TYPE_DVIA = 5
'''
Digital Visual Interface, analogue only (DVI-A).
'''

LIBGAMMA_CONNECTOR_TYPE_Composite = 6
'''
Composite video.
'''

LIBGAMMA_CONNECTOR_TYPE_SVIDEO = 7
'''
Separate Video (S-video).
'''

LIBGAMMA_CONNECTOR_TYPE_LVDS = 8
'''
Low-voltage differential signaling (LVDS).
'''

LIBGAMMA_CONNECTOR_TYPE_Component = 9
'''
Component video, usually separate cables for each channel.
'''

LIBGAMMA_CONNECTOR_TYPE_9PinDIN = 10
'''
9 pin DIN (Deutsches Institut für Normung) connector.
'''

LIBGAMMA_CONNECTOR_TYPE_DisplayPort = 11
'''
DisplayPort.
'''

LIBGAMMA_CONNECTOR_TYPE_HDMI = 12
'''
High-Definition Multimedia Interface (HDMI), unknown type.
'''

LIBGAMMA_CONNECTOR_TYPE_HDMIA = 13
'''
High-Definition Multimedia Interface, type A (HDMI-A).
'''

LIBGAMMA_CONNECTOR_TYPE_HDMIB = 14
'''
High-Definition Multimedia Interface, type B (HDMI-B).
'''

LIBGAMMA_CONNECTOR_TYPE_TV = 15
'''
Television, unknown connector.
'''

LIBGAMMA_CONNECTOR_TYPE_eDP = 16
'''
Embedded DisplayPort (eDP).
'''

LIBGAMMA_CONNECTOR_TYPE_VIRTUAL = 17
'''
A virtual connector.
'''

LIBGAMMA_CONNECTOR_TYPE_DSI = 18
'''
Display Serial Interface (DSI).
'''

LIBGAMMA_CONNECTOR_TYPE_LFP = 19
'''
LFP connector.
(If you know what this is add it to Wikipedia.)
'''


LIBGAMMA_CONNECTOR_TYPE_COUNT = 20
'''
The number of `LIBGAMMA_CONNECTOR_*` values defined.
'''



LIBGAMMA_SUBPIXEL_ORDER_UNKNOWN = 0
'''
The adjustment method does not know the order of the subpixels.
(This could be considered an error.)
'''

LIBGAMMA_SUBPIXEL_ORDER_NONE = 1
'''
There are no subpixels in the monitor.
'''

LIBGAMMA_SUBPIXEL_ORDER_HORIZONTAL_RGB = 2
'''
The subpixels are ordered red, green and then blue, from left to right.
'''

LIBGAMMA_SUBPIXEL_ORDER_HORIZONTAL_BGR = 3
'''
The subpixels are ordered blue, green and then red, from left to right.
'''

LIBGAMMA_SUBPIXEL_ORDER_VERTICAL_RGB = 4
'''
The subpixels are ordered red, green and then blue, from the top down.
'''

LIBGAMMA_SUBPIXEL_ORDER_VERTICAL_BGR = 5
'''
The subpixels are ordered blue, green and then red, from the top down.
'''


LIBGAMMA_SUBPIXEL_ORDER_COUNT = 6
'''
The number of `LIBGAMMA_SUBPIXEL_ORDER_*` values defined.
'''



LIBGAMMA_CRTC_INFO_EDID  = 1 << 0
'''
For a `CRTCInformation` fill in the
values for `edid` and `edid_length` and report errors to `edid_error`.
'''

LIBGAMMA_CRTC_INFO_WIDTH_MM = 1 << 1
'''
For a `CRTCInformation` fill in the
value for `width_mm` and report errors to `width_mm_error`.
'''

LIBGAMMA_CRTC_INFO_HEIGHT_MM = 1 << 2
'''
For a `CRTCInformation` fill in the
value for `height_mm` and report errors to `height_mm_error`.
'''

LIBGAMMA_CRTC_INFO_WIDTH_MM_EDID = 1 << 3
'''
For a `CRTCInformation` fill in the
value for `width_mm_edid` and report errors to `width_mm_edid_error`.
'''

LIBGAMMA_CRTC_INFO_HEIGHT_MM_EDID = 1 << 4
'''
For a `CRTCInformation` fill in the
value for `height_mm_edid` and report errors to `height_mm_edid_error`.
'''

LIBGAMMA_CRTC_INFO_GAMMA_SIZE = 1 << 5
'''
For a `CRTCInformation` fill in the
values for `red_gamma_size`, `green_gamma_size` and `blue_gamma_size`.
and report errors to `gamma_size_error`
'''

LIBGAMMA_CRTC_INFO_GAMMA_DEPTH = 1 << 6
'''
For a `CRTCInformation` fill in the
value for `gamma_depth` and report errors to `gamma_depth_error`.
'''

LIBGAMMA_CRTC_INFO_GAMMA_SUPPORT = 1 << 7
'''
For a `CRTCInformation` fill in the
value for `gamma_support` and report errors to `gamma_support_error`.
'''

LIBGAMMA_CRTC_INFO_SUBPIXEL_ORDER = 1 << 8
'''
For a `CRTCInformation` fill in the
value for `subpixel_order` and report errors to `subpixel_order_error`.
'''

LIBGAMMA_CRTC_INFO_ACTIVE = 1 << 9
'''
For a `CRTCInformation` fill in the
value for `active` and report errors to `active_error`.
'''

LIBGAMMA_CRTC_INFO_CONNECTOR_NAME = 1 << 10
'''
For a `CRTCInformation` fill in the
value for `connector_name` and report errors to `connector_name_error`.
'''

LIBGAMMA_CRTC_INFO_CONNECTOR_TYPE = 1 << 11
'''
For a `CRTCInformation` fill in the
value for `connector_type` and report errors to `connector_type_error`.
'''

LIBGAMMA_CRTC_INFO_GAMMA = 1 << 12
'''
For a `CRTCInformation` fill in the
values for `gamma_red`, `gamma_green` and `gamma_blue`
and report errors to `gamma_error`.
'''


LIBGAMMA_CRTC_INFO_COUNT = 13
'''
The number of `LIBGAMMA_CRTC_INFO_*` values defined.
'''



LIBGAMMA_CRTC_INFO_MACRO_EDID_VIEWPORT = LIBGAMMA_CRTC_INFO_WIDTH_MM_EDID |
                                         LIBGAMMA_CRTC_INFO_HEIGHT_MM_EDID
'''
Macro for both `CRTCInformation` fields
that can specify the size of the monitor's viewport
as specified in the monitor's Extended Display
Information Data.
'''

LIBGAMMA_CRTC_INFO_MACRO_EDID = LIBGAMMA_CRTC_INFO_EDID |
				LIBGAMMA_CRTC_INFO_MACRO_EDID_VIEWPORT |
				LIBGAMMA_CRTC_INFO_GAMMA
'''
Macro for all `CRTCInformation` fields
that can be filled if the adjustment method have
support for reading the monitors' Extended Display
Information Data.
'''

LIBGAMMA_CRTC_INFO_MACRO_VIEWPORT = LIBGAMMA_CRTC_INFO_WIDTH_MM |
                                    LIBGAMMA_CRTC_INFO_HEIGHT_MM
'''
Macro for both `CRTCInformation` fields
that can specify the size of the monitor's viewport
as provided by the adjustment method without this
library having to parse the monitor's Extended Display
Information Data.
'''

LIBGAMMA_CRTC_INFO_MACRO_RAMP = LIBGAMMA_CRTC_INFO_GAMMA_SIZE |
                                LIBGAMMA_CRTC_INFO_GAMMA_DEPTH
'''
Macro for the `CRTCInformation` fields
that specifies the CRTC's gamma ramp sizes and gamma
ramp depth.
'''

LIBGAMMA_CRTC_INFO_MACRO_CONNECTOR = LIBGAMMA_CRTC_INFO_CONNECTOR_NAME |
                                     LIBGAMMA_CRTC_INFO_CONNECTOR_TYPE
'''
Macro for the `CRTCInformation` fields
that specifies the CRTC's connector type and the
partition unique name of the connector.
'''

LIBGAMMA_CRTC_INFO_MACRO_ACTIVE = LIBGAMMA_CRTC_INFO_MACRO_EDID |
				  LIBGAMMA_CRTC_INFO_MACRO_VIEWPORT |
				  LIBGAMMA_CRTC_INFO_SUBPIXEL_ORDER |
				  LIBGAMMA_CRTC_INFO_ACTIVE
'''
Macro for the `CRTCInformation` fields
that required there is a monitor attached to the connector,
and that status itself.
'''

