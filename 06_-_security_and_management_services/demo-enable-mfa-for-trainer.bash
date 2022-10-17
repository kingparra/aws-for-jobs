#!/usr/bin/env bash

createMfaDev() {
  aws iam create-virtual-mfa-device \
    --virtual-mfa-device-name TrainerVritualMfaDevice \
    --outfile trainer_mfa.txt \
    --bootstrap-method Base32StringSeed
}

enableMfaDev() {
  # :: MfaArn -> AuthCode1 -> AuthCode2 -> IO ()
  aws iam enable-mfa-device \
    --user-name trainer \
    --serial-number "$1" \
    --authentication-code1 "$2" \
    --authentication-code2 "$3"
}

# MfaArn=arn:aws:iam::355626928841:user/trainer

