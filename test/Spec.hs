{-# LANGUAGE ViewPatterns #-}

import Control.Monad (forM_)
import Data.Maybe (mapMaybe)
import Lib

leftToMaybe :: Either a b -> Maybe a
leftToMaybe (Right _) = Nothing
leftToMaybe (Left a) = Just a

assertions :: [(String, String)]
assertions =
  [ ("<a>", "<a>"),
    ("<a href=\"b\">", "<a href=\"b\">"),
    ("<a href=\"/\">", "<a href=\"/prefix/\">"),
    ("<form action=\"/\">", "<form action=\"/prefix/\">")
  ]

data TestError = TestError String String String

main :: IO ()
main =
  let testResults = map runTest assertions
      badTestResults = mapMaybe leftToMaybe testResults
   in forM_ badTestResults $ \(TestError from got expected) ->
        putStrLn $ "Failed test: run '" ++ from ++ "' == '" ++ got ++ "' /= '" ++ expected ++ "'"
  where
    runTest :: (String, String) -> Either TestError ()
    runTest (from@(run prefs -> got), expected)
      | got == expected = Right ()
      | otherwise = Left (TestError from got expected)

    prefs =
      Preferences
        { prefix = "/prefix"
        }
