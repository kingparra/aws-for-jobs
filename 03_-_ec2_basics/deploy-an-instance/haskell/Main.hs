#!/usr/bin/env stack
-- stack script --resolver lts-20.18 --package aws --package text --package lens
{-# LANGUAGE OverloadedStrings #-}
import Control.Lens
import Network.AWS
import Network.AWS.EC2
import Network.AWS.Types
import Network.AWS.Auth
import qualified Data.Text.IO as T


main :: IO ()
main = do

  creds <- loadCredentialsFromINIFile (fromFilePath "/home/chris/.aws/credentials")

  myregion <- loadRegionFromINIFile (fromFilePath "/home/user/.aws/config")

  let cfg = configure (set region myregion) creds

  ec2 <- newEnv cfg >>= newResourceT . runAWS (within NVirginia) . newEC2

  res <- send $ runInstances "ami-0c55b159cbfafe1f0" 1 1
    & riInstanceType ?~ T2_Micro
--    & riKeyName ?~ "my-key-pair"
--    & riSubnetId ?~ "subnet-12345678"
--    & riSecurityGroupIds .~ ["sg-12345678"]
    & riTagSpecifications .~ [newTagSpecification & tsResourceType ?~ "instance"
                                                  & tsTags .~ [newTag & tagKey ?~ "Name"
                                                                      & tagValue ?~ "my-instance"]]
  T.putStrLn $ res ^. irsInstanceIds . to head
