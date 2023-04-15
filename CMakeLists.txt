cmake_minimum_required(VERSION 3.5)

project(QtQmlProject VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message("CMAKE_SYSROOT " ${CMAKE_SYSROOT})
message("CMAKE_LIBRARY_ARCHITECTURE " ${CMAKE_LIBRARY_ARCHITECTURE})

#find_package(QT NAMES Qt6 Qt5 COMPONENTS Quick REQUIRED)
#find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Quick REQUIRED)

find_package(Qt6 COMPONENTS Core Quick REQUIRED)

set(PROJECT_SOURCES
        main.cpp
        baosKnxIF.cpp
        baosKnxIF.h
        qml.qrc
)

qt_add_executable(qtqmlproto MANUAL_FINALIZATION ${PROJECT_SOURCES})


target_link_libraries(qtqmlproto PRIVATE Qt6::Core Qt6::Quick)

set_target_properties(qtqmlproto PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

qt_finalize_executable(qtqmlproto)

