# RainUseIndex
Africa Soil Information Service (AfSIS)
Rain-use efficiency index using NPP and CHIRPS for the continent of Africa

RUE is the ratio of vegetation productivity to annual precipitation and has been suggested as a measure for assessing land degradation.  AfSIS is using MOD17A3H NPP (Net Primary Production) and CHIRPS (Climate Hazards Group InfraRed Precipitation with Station) with results in gCm-2mm-1 and tCha-1mm-1.

1. MOD17A3H (NPP) product is the annual sum. The valid range for this product is (-3000,32700) and the scaling factor is 0.0001.  After rescale the value for NPP ranging from -0.3 to 3.27 (unit: kg C m-2), original res=500 m.
2. CHIRPS is calculated by the command line in R adding all the observation values in one year together, mainly ranging from 0 to ~5000 (unit: mm), original res=5000 m.
3. The final results have been resampled to 1000 m and reprojected to Lambert azimuthal equal-area.

There are 2 versions for the Rain Use Efficiency Index (annual sum NPP/ annual sum CHIRPS) 
	

	| - using g C m-2 mm-1: the amount of biomass produced (in grams of Carbon Mass per meter square) per milimeter of rainfall

	| - using t C ha-1 mm-1: the amount of biomass produced (tons of Carbon Mass per hectare) per milimeter of rainfall




MOD17A3H: MODIS/Terra Net Primary Production Yearly L4 Global 500 m SIN Grid V006 
Citation:
S. Running, Q. Mu, M. Zhao. “MOD17A3H MODIS/Terra Net Primary Production Yearly L4 Global 500m SIN Grid V006.” NASA EOSDIS Land Processes DAAC, 2015. Available: https://doi.org/10.5067/MODIS/MOD17A3H.006.

The MOD17A3H Version 6 product provides information about annual (yearly) Net Primary Production at 500 meter pixel resolution.  Annual NPP is derived from the sum of the 45, 8-day Net Photosynthesis  (PSN) products (MOD17A2H) from the given year.  The PSN value is the difference of the GPP and the Maintenance Respiration (MR) (GPP-MR).


Climate Hazards Group InfraRed Precipitation with Station (CHIRPS) data for Africa. 
Citation: 
Funk, Chris, Pete Peterson, Martin Landsfeld, Diego Pedreros, James Verdin, Shraddhanand Shukla, Gregory Husak, James Rowland, Laura Harrison, Andrew Hoell & Joel Michaelsen.
"The climate hazards infrared precipitation with stations—a new environmental record for monitoring extremes". Scientific Data 2, 150066. doi:10.1038/sdata.2015.66 2015. 
http://chg.geog.ucsb.edu/data/chirps/#_Data


Additional details can be found on github: https://github.com/AfSIS-at-CIESIN

#####
For any questions, please contact afsis.info@africasoils.net

#####

