# See LICENSE file for copyright and license details.
from libgamma_method import MethodCapabilities


def list_methods(operation : int) -> list:
    '''
    List available adjustment methods by their order of preference based on the environment
    
    @param  operation    Allowed values
                           0: Methods that the environment suggests will work, excluding fake
                           1: Methods that the environment suggests will work, including fake
                           2: All real non-fake methods
                           3: All real methods
                           4: All methods
                         Other values invoke undefined behaviour
    @return  :list<int>  A list of available adjustment methods
    '''
    from libgamma_native_facade import libgamma_native_list_methods
    return libgamma_native_list_methods(operation)


def is_method_available(method : int) -> bool:
    '''
    Check whether an adjustment method is available, non-existing (invalid) methods will be
    identified as not available under the rationale that the library may be out of date
    
    @param   method  The adjustment method
    @return          Whether the adjustment method is available
    '''
    from libgamma_native_facade import libgamma_native_is_method_available
    return not libgamma_native_is_method_available(method) == 0


def method_capabilities(method : int) -> MethodCapabilities:
    '''
    Return the capabilities of an adjustment method
    
    @param  this    The data structure to fill with the method's capabilities
    @param  method  The adjustment method (display server and protocol)
    '''
    from libgamma_native_facade import libgamma_native_method_capabilities
    caps = libgamma_native_method_capabilities(method)
    return MethodCapabilities(*caps)


def method_default_site(method : int) -> str:
    '''
    Return the default site for an adjustment method
    
    @param   method  The adjustment method (display server and protocol)
    @return          The default site, `None` if it cannot be determined or
                     if multiple sites are not supported by the adjustment
                     method
    '''
    from libgamma_native_facade import libgamma_native_method_default_site
    return libgamma_native_method_default_site(method)


def method_default_site_variable(method : int) -> str:
    '''
    Return the default variable that determines
    the default site for an adjustment method
    
    @param   method  The adjustment method (display server and protocol)
    @return          The environ variables that is used to determine the
                     default site. `None` if there is none, that is, if
                     the method does not support multiple sites.
    '''
    from libgamma_native_facade import libgamma_native_method_default_site_variable
    return libgamma_native_method_default_site_variable(method)



def behex_edid(edid : bytes) -> str:
    '''
    Convert a raw representation of an EDID to a lowercase hexadecimal representation
    
    @param   edid  The EDID in raw representation
    @return        The EDID in lowercase hexadecimal representation
    '''
    return behex_edid_lowercase(edid)


def behex_edid_lowercase(edid : bytes) -> str:
    '''
    Convert a raw representation of an EDID to a lowercase hexadecimal representation
    
    @param   edid  The EDID in raw representation
    @return        The EDID in lowercase hexadecimal representation
    '''
    rc = ''
    for b in edid:
        rc += '0123456789abcdef'[(b >> 4) & 15]
        rc += '0123456789abcdef'[(b >> 0) & 15]
    return rc


def behex_edid_uppercase(edid : bytes) -> str:
    '''
    Convert a raw representation of an EDID to an uppercase hexadecimal representation
    
    @param   edid  The EDID in raw representation
    @return        The EDID in uppercase hexadecimal representation
    '''
    rc = ''
    for b in edid:
        rc += '0123456789ABCDEF'[(b >> 4) & 15]
        rc += '0123456789ABCDEF'[(b >> 0) & 15]
    return rc


def unhex_edid(edid : str) -> bytes:
    '''
    Convert an hexadecimal representation of an EDID to a raw representation
    
    @param   edid  The EDID in hexadecimal representation
    @return        The EDID in raw representation
    '''
    rc = []
    edid = edid.lower()
    for i in range(0, len(edid), 2):
        a, b = edid[i + 0], edid[i + 1]
        a = '0123456789abcdef'.find(a) << 4
        b = '0123456789abcdef'.find(b) << 0
        rc.append(a | b)
    return bytes(rc)
