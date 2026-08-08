local workspace_name = "turbostroi"
local workspace_add_debug = false
local project_serverside = true

if not multiprocessorcompile then multiprocessorcompile = function() end end
if not linktimeoptimization then linktimeoptimization = function() end end

newoption({
    trigger = "gmcommon",
    description = "Sets the path to the garrysmod_common",
    value = "path to garrysmod_common directory"
})

local gmcommon = assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
    "you didn't provide a path to your garrysmod_common")
include(gmcommon .. "/generator.v3.lua")

CreateWorkspace({
    name = workspace_name,
})

CreateProject({
    serverside = project_serverside,
})

links {
    "boost_thread",
    "boost_chrono",
    "boost_system"
}

includedirs {
    gmcommon .. "/sourcesdk-minimal/public"
}

files {
    "external/metamod-source/core/sourcehook/sourcehook.cpp",
    "external/metamod-source/core/sourcehook/sourcehook_hookmangen.cpp",
    "external/metamod-source/core/sourcehook/sourcehook_impl_chookidman.cpp",
    "external/metamod-source/core/sourcehook/sourcehook_impl_chookmaninfo.cpp",
    "external/metamod-source/core/sourcehook/sourcehook_impl_cproto.cpp",
    "external/metamod-source/core/sourcehook/sourcehook_impl_cvfnptr.cpp" 
}

filter("system:windows")
    nuget { "boost-vc142:1.71.0", "boost:1.71.0", "boost_thread-vc142:1.71.0", "boost_date_time-vc142:1.71.0", "boost_chrono-vc142:1.71.0", "boost_atomic-vc142:1.71.0" }

filter({})

removefiles { "source/guicon.cpp", "source/guicon.h" }
includedirs { "external/gmod-module-base/include", "external/luajit", "external/metamod-source/core/sourcehook" }

removeincludedirs { gmcommon .. "/include", gmcommon .. "/helpers/include" }
includedirs { gmcommon .. "/include", gmcommon .. "/helpers/include" }

filter({"system:windows", "architecture:x86"})
    libdirs("external/luajit/x86")
    
filter({"system:windows", "architecture:x86_64"})
    libdirs("external/luajit/x64")

filter("system:windows or macosx")
    links("lua51", "luajit")

filter({"system:linux", "architecture:x86"})
    libdirs("external/luajit/linux32")
    links("lua51", "luajit")

filter({"system:linux", "architecture:x86_64"})
    libdirs { 
        "external/luajit/linux64", 
        "external/garrysmod_common/sourcesdk-minimal/lib/public/linux64" 
    }
    links {
        "lua51", 
        "tier0_srv", 
        "vstdlib_srv", 
        "boost_thread", 
        "boost_chrono", 
        "boost_system" 
    }

filter({})

IncludeHelpersExtended()
IncludeSDKCommon()
IncludeSDKTier0()
IncludeSDKTier1()
IncludeSDKMathlib() 
