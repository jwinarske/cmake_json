# cmake_json
Example Project that uses JSON for storing dependency information

* Artifacts and project dependencies are defined in 
    * ${CMAKE_CURRENT_SOURCE_DIR}/configuration.json
* ExternalProjects are installed to a staging directory
    * `${CMAKE_CURRENT_BINARY_DIR}/staging/usr`

This was implemented as a proof for factoring out Hunter package management in the Luxonis depthai-core project.

To build

    git clone https://github.com/jwinarske/cmake_json
    mkdir build && cd build
    cmake ..
    make -j