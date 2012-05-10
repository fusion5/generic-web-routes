module Paths_generic_web_routes (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/dragos/.cabal/bin"
libdir     = "/home/dragos/.cabal/lib/generic-web-routes-0.1/ghc-7.0.3"
datadir    = "/home/dragos/.cabal/share/generic-web-routes-0.1"
libexecdir = "/home/dragos/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "generic_web_routes_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "generic_web_routes_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "generic_web_routes_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "generic_web_routes_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
