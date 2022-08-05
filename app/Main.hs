{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE BangPatterns #-}

module Main where

import System.Console.CmdArgs
import Lib

data Args = Args {prefix_arg :: Maybe String} deriving (Data, Typeable)

cmdargs =
  Args
    { prefix_arg = def &= help "Prefix to use" &= explicit &= name "prefix"
    }
    &= program "filter"
    &= summary "Prepend a prefix to URLs"

main :: IO ()
main = do
  args <- cmdArgs cmdargs
  let !p = case prefix_arg args of
        Nothing -> error "Missing --prefix argument"
        Just p -> p
      preferences =
        Preferences
          { prefix = p
          }
  interact $ run preferences
