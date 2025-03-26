#!/usr/bin/env bash

fslmaths Hippocampus_LAnterior -bin tmp
fslmaths Hippocampus_RAnterior -bin -mul 2 -add tmp tmp
fslmaths Hippocampus_LPosterior -bin -mul 3 -add tmp tmp
fslmaths Hippocampus_RPosterior -bin -mul 4 -add tmp aphippo
