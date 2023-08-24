{-# LANGUAGE OverloadedStrings #-}
module Main where
import Amazonka
import Amazonka.EC2
import Control.Lens ((^.), (?~))
import Data.Text hiding (map)


data Options = Options {
      ami_id :: Text
    , vpc_id :: Text
} deriving Show


main :: IO ()
main = do
  putStrLn "Stub for program that launches an EC2 instance"
