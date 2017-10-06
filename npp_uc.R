# Author: Yanni Zhan
# Date  : 02/01/2017
# For NPP unit convert into tCha-1


rm(list=ls())
require(raster)

######
#first copy to the same directory, easy to manipulate all the files
#folder="/data1/NPP/outputs"
#files = list.files(path=folder,pattern="*.Npp_500m.tif",full.names=T)
#file.copy(files[],"/data3/rstudio/rain_use_index",copy.mode=T,recursive=T)
#?file.copy

#files  = list.files(path="/data3/rstudio/rain_use_index/NPP",pattern = paste("*.tif",sep=""),full.names=T)  
#merged = list()

#for ( i in 1:length(files) ) {
#    print(paste("Loading",files[i]))

#    temp  = raster(files[i])
#    values  = values(temp)
#    values = values*1000
#    values(temp) = values

#    merged[[i]] = temp
#    writeRaster(merged[[i]], file=files[[i]],format="GTiff", overwrite=T)
#}
######


#set the permission environment for the working folder to enable mulple users to output on the server without permission errors
#folder="/data3/rstudio/rain_use_index"
#system(command=paste("chmod -R 2775",folder))


unit="tCha-1"



############ unit convert

setwd("/data3/rstudio/rain_use_index/NPP")

#parameters from usgs website
gain    = 0.0001
valid   = c(-3000,32700)

#list the NPP files in the folder
files_name  = list.files(path="./before_rescale",pattern = "*.Npp_500m.tif",full.names=T)
files_name

#new output
#dir.create("./tCha-1",showWarnings=T,mode="2775")

outputs=substring(files_name,18,nchar(files_name)-4) 
outputs=paste("./",unit,"/",outputs,"_",unit,".tif",sep="")
outputs

# Bulk unit convert +save function
merged = list()

for ( i in 1:length(files_name) ) {
  print(paste("Loading",files_name[i]))
  
  temp  = raster(files_name[i])
  values  = values(temp)
  values[ values<valid[1] | values>valid[2] ] = NA
  values = values*gain*10
  values(temp) = values
  
  merged[[i]] = temp
  
  writeRaster(merged[[i]], file=outputs[[i]],format="GTiff", overwrite=T)
}
