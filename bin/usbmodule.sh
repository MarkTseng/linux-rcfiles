#!/bin/bash
cat modules.alias | awk -F' ' '{ if (NR!=1) print "vid:" substr($2,6,4) ",pid:" substr($2,11,4) ",driver:"$3}'
