cmake_minimum_required(VERSION 3.16)

project(LogPilot)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_options("/W3;/WX;/EHsc")
add_compile_options("$<$<CONFIG:DEBUG>:/Zi;/Od;/RTC1;/MDd>")
add_compile_options("$<$<CONFIG:RELEASE>:/O2;/Ob2;/MD;/DNDEBUG>")


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install_debug)
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
  set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install_release)
endif()


find_package(Qt6 REQUIRED COMPONENTS
    Core
    Widgets
    Qml
    Quick
    Core5Compat
    ShaderTools
)

qt_standard_project_setup(REQUIRES 6.5)

list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/src/modules")
set(QML_IMPORT_PATH "${QML_DIRS}" CACHE STRING "" FORCE)


# Get git hash
execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

add_definitions("-DGIT_HASH=\"${GIT_HASH}\"")

message("GIT_HASH = " ${GIT_HASH})

# Get build time
string(TIMESTAMP CURRENT_DATE "%Y-%m-%d")
string(TIMESTAMP CURRENT_TIME "%H:%M:%S")

add_definitions("-DBUILD_DATE=\"${CURRENT_DATE}\"")
add_definitions("-DBUILD_TIME=\"${CURRENT_TIME}\"")

include(GNUInstallDirs)

include_directories(src/libs/WinExport)

add_subdirectory(src/libs)
add_subdirectory(src/modules)
add_subdirectory(src/app)
