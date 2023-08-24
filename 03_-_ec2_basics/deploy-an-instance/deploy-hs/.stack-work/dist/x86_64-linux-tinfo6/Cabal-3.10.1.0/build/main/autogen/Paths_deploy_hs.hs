{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_deploy_hs (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/bin"
libdir     = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/lib/x86_64-linux-ghc-9.6.2/deploy-hs-0.0.0-3Lof35ZKwHP2X5pYv4csxY-main"
dynlibdir  = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/lib/x86_64-linux-ghc-9.6.2"
datadir    = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/share/x86_64-linux-ghc-9.6.2/deploy-hs-0.0.0"
libexecdir = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/libexec/x86_64-linux-ghc-9.6.2/deploy-hs-0.0.0"
sysconfdir = "/var/home/chris/Projects/aws-for-jobs/03_-_ec2_basics/deploy-an-instance/deploy-hs/.stack-work/install/x86_64-linux-tinfo6/73d7ac471044ebd8caa34882e19d9883941aebc7024e0a0083d788a298be6ec2/9.6.2/etc"

getBinDir     = catchIO (getEnv "deploy_hs_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "deploy_hs_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "deploy_hs_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "deploy_hs_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "deploy_hs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "deploy_hs_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
