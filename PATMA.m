% PATMA Ver 0.3
%
% <Software>
%The PATMA software is capable of automatically finding and extracting
%cores from archival images of the tissue microarrays. Tissue microarray
%slides are often scanned to perform computer-aided histopathological
%analysis of the tissue cores. For processing the image, splitting the
%whole virtual slide into images of individual cores is required. This
%software aids the scientists who want to perform further image processing
%on single cores.
%
% <Reference> 
% Lukasz Roszkowiak and Carlos Lopez "PATMA: Parser of archival
% tissue microarray", PeerJ 4 (2016): e2741.
% DOI: https://doi.org/10.7717/peerj.2741
% 

clc
clear all
close all


%% Run GUI
punchGUI;
