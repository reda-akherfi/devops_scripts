#!/usr/bin/env bash


virsh destroy --domain $1
virsh undefine --nvram $1
