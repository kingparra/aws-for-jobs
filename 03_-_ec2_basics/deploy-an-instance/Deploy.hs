#!/usr/bin/env stack
-- stack --resolver nightly-2023-09-17 script --package hspec --package QuickCheck --package amazonka --package lens --package text

{-# LANGUAGE OverloadedStrings #-}
-- https://www.stackage.org/nightly-2023-09-17/package/amazonka-2.0
-- amazonka-2.0@sha256:3481da2fda6b210d15d41c1db7a588adf68123cfb7ea3882797a6230003259db,3505
import Amazonka.EC2
import Amazonka
import Control.Lens


main :: IO ()
main = do

  -- Set up AWS credentials and configuration
  env <- newEnv discover
  let cfg = env ^. envConfig

  -- Specify the instance parameters
  let instanceParams = runInstances "ami-0c55b159cbfafe1f0" 1 1
        & rInstanceType .~ Just "t2.micro"
        & rKeyName .~ Just "precision"
        -- & rSecurityGroupIds .~ ["sg-0123456789abcdef0"]
        -- & rSubnetId .~ Just "subnet-0123456789abcdef"

  -- Launch the instance
  runResourceT . runAWS cfg $ do
    resp <- send instanceParams
    liftIO $ print resp
