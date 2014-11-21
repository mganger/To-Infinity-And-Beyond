#!/bin/bash
octave --eval 'thetaD = 0*pi;  step1 = 0; step2 = 0; thetaDEnd = 32*pi;  step1End = 2*pi; step2End = 2*pi; iterStep = .01*pi; filename = "rand1.csv"' iterate.m &
octave --eval 'thetaD = 0*pi;  step1 = 0; step2 = 0; thetaDEnd = 32*pi;  step1End = 2*pi; step2End = 2*pi; iterStep = .01*pi; filename = "rand2.csv"' iterate.m &
octave --eval 'thetaD = 0*pi;  step1 = 0; step2 = 0; thetaDEnd = 32*pi;  step1End = 2*pi; step2End = 2*pi; iterStep = .01*pi; filename = "rand3.csv"' iterate.m &
octave --eval 'thetaD = 0*pi;  step1 = 0; step2 = 0; thetaDEnd = 32*pi;  step1End = 2*pi; step2End = 2*pi; iterStep = .01*pi; filename = "rand4.csv"' iterate.m &
