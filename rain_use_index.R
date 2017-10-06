# Author: Yanni Zhan
# Date  : 12/12/2016
# For 1km resolution Rain Use Efficiency Index (NPP/CHIRPS) bulk calculation

######
#set the permission environment for the working folder to enable mulple users to output on the server without permission errors
#folder="/data3/rstudio/rain_use_index"
#system(command=paste("chmod -R 2775",folder))
######


rm(list=ls())
require(raster)

mapset="ruiyzhan"
unit="gCm-2"
#unit="tCha-1" 





############ Step 1. resample into 1km ######################

#### npp
#list all the npp files of your chosing unit as inputs
nip  = list.files(path = paste("/data3/rstudio/rain_use_index/NPP/",unit,sep=""),pattern = paste("*.tif",sep=""),full.names=T)
if (unit == "gCm-2"){
  nip2 = substring(nip,41,nchar(nip)-14)
} else {
  nip2 = substring(nip,42,nchar(nip)-15)
}
nip2

#create a new name as output
nop  = paste("/data3/rstudio/rain_use_index/NPP/",nip2,unit,"_1km_laea.tif",sep="")
nop

#bulk reproject to laea & resample to 1000m
for (j in 1:length(nip)) {
  system(command = paste("gdalwarp -overwrite -r average -tr 1000 1000 -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -multi -wm 500",
                        nip[j],
                        nop[j]))
}


#### chirps
#list all the files of your chosing year as inputs
cip  = list.files(path="/data3/rstudio/rain_use_index/CHIRPS/geo",pattern = "CHIRPS.*.tif",full.names = T) 
cip2 = substring(cip,42,nchar(cip)-4)
cip2

#create a new name as output
cop  = paste("/data3/rstudio/rain_use_index/CHIRPS/",cip2,"_1km_laea.tif",sep="")
cop

#bulk reproject to laea & resample to 1000m
for (j in 1:length(cip)) {
  system(command = paste("gdalwarp -r near -tr 1000 1000 -overwrite -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -multi -wm 5000",
                        cip[j],
                        cop[j]))
}





############ Step 2. clipped into 1km ###############

### npp
setwd("/data2/scripts")
system(command=paste("bash clip_rasters.sh -c /data2/gadm2 -i /data3/rstudio/rain_use_index/NPP -m /data3/grassdata/lambert/",mapset," -r 1000",sep=""))


### chirps
system(command=paste("bash clip_rasters.sh -c /data2/gadm2 -i /data3/rstudio/rain_use_index/CHIRPS -m /data3/grassdata/lambert/",mapset," -r 1000",sep=""))






############ Step 3. import clipped NPP & CHIRPS ###############

setwd("/data3/rstudio/rain_use_index")

##NPP
#list all the .tif files for NPP
files_NPP = list.files(path="./NPP/clipped",pattern=paste("*.",unit,".*.tif",sep=""),full.names=T)
files_NPP


##CHIRPS
#list all the .tif files for CHIRPS
files_CHIRPS = list.files(path="./CHIRPS/clipped",pattern="*.tif",full.names=T)
files_CHIRPS







############ Step 4. calculate the index ###############

#create a new output name for the index
outputs=substring(files_CHIRPS,28,32) 
outputs=paste("./outputs/RUE_index",outputs,"_1km_",unit,"_laea.tif",sep="")
outputs

#bulk calculation
merged = list()

for(i in 1:length(files_NPP)){
  print(paste("Loading",files_NPP[i]))
  
  #turning into vectors, faster to calculate
  temp_NPP  = raster(files_NPP[i])
  values_NPP  = values(temp_NPP)

  temp_CHIRPS  = raster(files_CHIRPS[i])
  values_CHIRPS  = values(temp_CHIRPS)
  values_CHIRPS[ values_CHIRPS == 0 ] = NA  #remove 0 for the denominator (CHIRPS), avoid "inf" in the final result
  
  #calculate the index by vector
  values_index = values_NPP/values_CHIRPS
  
  #create a raster for the vector
  index = temp_CHIRPS
  values(index) = values_index
  
  #bulk write the result
  merged[[i]] = index
  writeRaster(merged[[i]], file=outputs[[i]],format="GTiff", overwrite=T)
}

#set no values from -1.69999999999999994e+308 to NaN
setwd("/data2/scripts")
system(command=paste("bash clip_rasters.sh -c /data2/gadm2 -i /data3/rstudio/rain_use_index/outputs -m /data3/grassdata/lambert/",mapset," -r 1000",sep=""))

#change the permission
folder="/data3/rstudio/rain_use_index/outputs"
system(command=paste("chmod -R 2775",folder))

##end
