#!/bin/bash

sed "s/tag-version/$1/g" template.yaml > ipapp-manifest.yaml