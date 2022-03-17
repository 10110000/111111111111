cmake_minimum_required(VERSION 3.5)

project(LinGe_VScripts LANGUAGES CXX)

set(L4D2 ~/l4d2sv) # 仅Linux下需要用到游戏目录
set(HL2SDKL4D2 ../../L4D2_Dev/hl2sdk-l4d2)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD 11)

set(HL2PUB ${HL2SDKL4D2}/public)
set(HL2GAME ${HL2SDKL4D2}/game)

if(WIN32)
	link_directories(${HL2SDKL4D2}/lib/public)
	set(LINK_LIBRARY
		mathlib
		tier0
		tier1
		tier2
		vstdlib
		mathlib
	)
	add_compile_options(/wd4819)
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /NODEFAULTLIB:libc")
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /NODEFAULTLIB:libcd")
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /NODEFAULTLIB:libcmt")
elseif(UNIX)
	set(HL2LIB ${HL2SDKL4D2}/lib/linux)
	link_directories(${HL2SDKL4D2}/lib/linux ${CMAKE_CURRENT_SOURCE_DIR})
	set(LINK_LIBRARY
		libtier0_srv.so
		libvstdlib_srv.so
		libtier1_i486.a
		libtier2_i486.a
		libtier3_i486.a
		libmathlib_i486.a
		# *.a 四个静态库需要自行加上lib前缀
	)
	set(CMAKE_CXX_FLAGS	"${CMAKE_CXX_FLAGS} -D_LINUX -DL4D2 -m32 \
		-Dstricmp=strcasecmp -D_stricmp=strcasecmp -D_strnicmp=strncasecmp \
		-Dstrnicmp=strncasecmp -D_snprintf=snprintf -D_vsnprintf=vsnprintf \
		-D_alloca=alloca -Dstrcmpi=strcasecmp -Wall -Wno-switch \
		-Wno-error=uninitialized -Wno-unused -Wno-error=delete-non-virtual-dtor \
		-mfpmath=sse -msse -DHAVE_STDINT_H \
		-Wno-non-virtual-dtor -fno-rtti -fno-threadsafe-statics \
		-Wno-overloaded-virtual -fpermissive \
		-m32 -ldl -lm -static-libgcc -static-libstdc++ -shared"
	)
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -funroll-loops -pipe -fno-strict-aliasing")
endif()

add_library(LinGe_VScripts SHARED)

target_sources(LinGe_VScripts PRIVATE
	LinGe_VScripts.cpp
	sdkapi/MemoryUtils/MemoryUtils.cpp
	sdkapi/sdkapi.cpp
	sdkapi/signature.cpp
)

target_include_directories(LinGe_VScripts PRIVATE
	${HL2PUB}
	${HL2PUB}/tier0
	${HL2PUB}/tier1
	${HL2PUB}/tier2
	${HL2PUB}/tier3
	${HL2GAME}/shared
	${HL2GAME}/server
	${HL2GAME}/client
)

target_link_libraries(LinGe_VScripts PRIVATE ${LINK_LIBRARY})

# add_custom_command(TARGET LinGe_VScripts
# 	PRE_BUILD
# 	COMMAND ${PRE_CMD}
# )