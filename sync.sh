#!/bin/bash

git add .
git commit -m 'autosync'
git push
sleep 3
sudo emerge --sync neruthes
sudo eix-update
