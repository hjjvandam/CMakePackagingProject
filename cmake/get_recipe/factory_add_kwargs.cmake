################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(get_recipe/get_from_disk/ctor_add_kwargs)
include(get_recipe/get_from_url/factory_add_kwargs)

function(_cpp_GetRecipe_factory_add_kwargs _cGfak_kwargs)
    _cpp_GetFromDisk_ctor_add_kwargs(${_cGfak_kwargs})
    _cpp_GetFromURL_factory_add_kwargs(${_cGfak_kwargs})
    _cpp_Kwargs_add_keywords(${_cGfak_kwargs} OPTIONS SOURCE_DIR URL)
endfunction()