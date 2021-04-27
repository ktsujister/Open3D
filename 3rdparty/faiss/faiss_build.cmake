include(ExternalProject)

# MKL_INSTALL_PREFIX contains MKL-TBB or BLAS static library.
# Faiss depends on MKL-TBB or BLAS. We put them in the same directory so that
# FAISS_LIBRARIES can refer to libraries in the same directory.
set(MKL_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/mkl_install)

ExternalProject_Add(
    ext_faiss
    PREFIX faiss
    GIT_REPOSITORY https://github.com/intel-isl/faiss.git
    GIT_TAG open3d_patch
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${MKL_INSTALL_PREFIX}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CUDA_FLAGS=${CUDA_GENCODES}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_CUDA_COMPILER=${CMAKE_CUDA_COMPILER}
        -DCMAKE_C_COMPILER_LAUNCHER=${CMAKE_C_COMPILER_LAUNCHER}
        -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
        -DCMAKE_CUDA_COMPILER_LAUNCHER=${CMAKE_CUDA_COMPILER_LAUNCHER}
        -DCUDAToolkit_ROOT=${CUDAToolkit_LIBRARY_ROOT}
        -DFAISS_ENABLE_GPU=${BUILD_CUDA_MODULE}
        -DFAISS_ENABLE_PYTHON=OFF
        -DFAISS_USE_SYSTEM_BLAS=OFF
        -DBUILD_TESTING=OFF
    CMAKE_CACHE_ARGS    # Lists must be passed via CMAKE_CACHE_ARGS
        -DCMAKE_CUDA_ARCHITECTURES:STRING=${CMAKE_CUDA_ARCHITECTURES}
    BUILD_BYPRODUCTS
        ${MKL_INSTALL_PREFIX}/${Open3D_INSTALL_LIB_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}faiss${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(FAISS_LIBRARIES faiss)
set(FAISS_INCLUDE_DIR "${MKL_INSTALL_PREFIX}/include/")
set(FAISS_LIB_DIR "${MKL_INSTALL_PREFIX}/${Open3D_INSTALL_LIB_DIR}")  # Must have no trailing "/".
