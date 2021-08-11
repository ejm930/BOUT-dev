# FindHYPRE
# ---------
#
# Find HYPRE

include(FindPackageHandleStandardArgs)
if( NOT ${HYPRE_DIR} MATCHES "HYPRE_DIR-NOTFOUND")
   set(HYPRE_SEARCH_DIR ${HYPRE_DIR} CACHE STRING "HYPRE_SEARCH_DIR")
endif ()
message(STATUS "HYPRE_SEARCH_DIR: ${HYPRE_SEARCH_DIR}")
find_package(HYPRE QUIET NO_DEFAULT_PATH PATHS ${HYPRE_SEARCH_DIR}/lib64/cmake)
if (HYPRE_FOUND)
  message(STATUS "HYPRE FOUND cmake config")
  return()
endif()
message(STATUS "Find HYPRE did not find cmake config - looking for includes and lib instead: ${HYPRE_SEARCH_DIR}" )

find_path(HYPRE_INCLUDE_DIR   NAMES HYPRE.h
  DOC "HYPRE include directories"
  REQUIRED NO_DEFAULT_PATH PATHS ${HYPRE_SEARCH_DIR}/include
)

find_library(HYPRE_LIBRARY
  NAMES HYPRE
  DOC "HYPRE library"
  REQUIRED NO_DEFAULT_PATH PATHS ${HYPRE_SEARCH_DIR}
  PATH_SUFFIXES lib64 lib
  )

if (HYPRE_INCLUDE_DIR)
  file(READ "${HYPRE_INCLUDE_DIR}/HYPRE_config.h" HYPRE_CONFIG_FILE)
  string(REGEX MATCH ".*#define HYPRE_RELEASE_VERSION \"([0-9]+)\\.([0-9]+)\\.([0-9]+)\".*"
    _ "${HYPRE_CONFIG_FILE}")
  set(HYPRE_VERSION_MAJOR ${CMAKE_MATCH_1})
  set(HYPRE_VERSION_MINOR ${CMAKE_MATCH_2})
  set(HYPRE_VERSION_PATCH ${CMAKE_MATCH_3})
  set(HYPRE_VERSION "${HYPRE_VERSION_MAJOR}.${HYPRE_VERSION_MINOR}.${HYPRE_VERSION_PATCH}")
endif()
set(HYPRE_DEBUG True)
if (HYPRE_DEBUG)
  message(STATUS "[ ${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE} ]"
     " HYPRE_ROOT = ${HYPRE_SEARCH_DIR}"
    " HYPRE_INCLUDE_DIR = ${HYPRE_INCLUDE_DIR}"
    " HYPRE_LIBRARY = ${HYPRE_LIBRARY}"
    )
endif()

mark_as_advanced(HYPRE_INCLUDE_DIR HYPRE_LIBRARY)

find_package_handle_standard_args(HYPRE
  REQUIRED_VARS HYPRE_LIBRARY HYPRE_INCLUDE_DIR
  VERSION_VAR HYPRE_VERSION
  )

if (HYPRE_FOUND AND NOT TARGET HYPRE::HYPRE)
  add_library(HYPRE::HYPRE UNKNOWN IMPORTED)
  set_target_properties(HYPRE::HYPRE PROPERTIES
    IMPORTED_LOCATION "${HYPRE_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${HYPRE_INCLUDE_DIR}"
    )

endif()

