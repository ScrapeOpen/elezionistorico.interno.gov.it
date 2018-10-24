## From istat.it
require(rgdal)
reg.sp <-
  readOGR('Limiti01012016/Reg01012016/',
          'Reg01012016_WGS84')

open_shp_20161204_F.sp <- 
  readOGR('Limiti01012016/Com01012016/',
          'Com01012016_WGS84')

setwd('ScrapeOpen/elezionistorico.interno.gov.it') # Change this!
options(warn=2) # Warnings into errors!

dir <- "raw_csv_20161204_F/" # Change this
files <- list.files(dir)

splitFileName <- function(x) {
  regions <- 
    c("ABRUZZO","BASILICATA","CALABRIA","CAMPANIA",
      'EMILIA-ROMAGNA','FRIULI-VENEZIA_GIULIA','LAZIO',
      'LIGURIA','LOMBARDIA','MARCHE','MOLISE',
      'PIEMONTE','PUGLIA','SARDEGNA','SICILIA',
      'TOSCANA','UMBRIA',"VALLE_D'AOSTA", 
      "VENETO","TRENTINO-ALTO_ADIGE")
  require(stringr)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  this_type <- this_split[1]
  this_what <- this_split[2]
  this_date <- as.character(as.Date(this_split[3], "%d_%m_%Y"))
  this_where_1 <-  this_split[4] # area
  this_where_2_3 <- gsub("SCRUTINI-Referendum-04_12_2016-ITALIA-|-Comune\\.csv", "", x)
  this_where_2 <- str_extract(this_where_2_3, paste(regions, collapse="|"))
  this_where_3 <- gsub(paste(paste0(regions,"-"), collapse="|"), "", this_where_2_3)
  return(list(type = this_type,
              election = this_what,
              date = this_date,
              geo_lev_1 = this_where_1,
              geo_lev_2 = this_where_2,
              geo_lev_3 = this_where_3))
}

makeDF <- function(lst, dat) {
  details <- 
    data.frame(matrix(unlist(lst), nrow=1, byrow=T, 
                      dimnames = list(NULL, names(lst))))
  details <- 
    do.call("rbind", replicate(nrow(dat), details, simplify = FALSE))
  return(cbind(file_details, dat))
}

scrutini_dat <- data.frame()
for (f in files) {
  file_details <- splitFileName(f)
  
  library(readr)
  this_dat <- read.delim(paste0(dir, f), sep = ";", row.names = NULL, colClasses = 'character')

  this_dat <- this_dat[,1:8]
  colnames(this_dat) <-
    c("Ente", "Numero.scheda", "SI", "NO", "Numero.elettori", "Numero.votanti", "Schede.bianche",
      "Schede.non.valide")
  this_dat$Numero.elettori <- as.numeric(gsub("\\.", "", this_dat$Numero.elettori))
  this_dat$Numero.votanti <- as.numeric(gsub("\\.", "", this_dat$Numero.votanti))
  this_dat$Schede.bianche <- as.numeric(gsub("\\.", "", this_dat$Schede.bianche))
  this_dat$Schede.non.valide <- as.numeric(gsub("\\.", "", this_dat$Schede.non.valide))
  this_dat$SI <- as.numeric(gsub("\\.", "", this_dat$SI))
  this_dat$NO <- as.numeric(gsub("\\.", "", this_dat$NO))
  scrutini_dat <- 
    rbind(scrutini_dat, 
          makeDF(file_details, 
                 data.frame(geo_entity = this_dat$Ente,
                            registered_voters = this_dat$Numero.elettori,
                            effective_voters = this_dat$Numero.votanti,
                            blank_votes = this_dat$Schede.bianche,
                            invalid_votes = this_dat$Schede.non.valide,
                            yes_votes = this_dat$SI,
                            no_votes = this_dat$NO,
                            stringsAsFactors = F)))
  
}
Encoding(scrutini_dat$geo_entity) <- 'latin1'

# Region
labelRegion <- function(x) {
  library(stringr)
  x <- gsub("_"," ",x)
  x <- gsub("[0-9]","",x)
  x <- str_trim(x)
  x <- str_to_title(x)
  if (grepl('trentino',x,ignore.case = T)) {
    x <- "Trentino-Alto Adige/Südtirol"
  } else if(grepl('aosta',x,ignore.case = T)) {
    x <- "Valle d'Aosta/Vallée d'Aoste"
  }
  return(x)
}

scrutini_dat$region <-
  sapply(scrutini_dat$geo_lev_2, labelRegion, USE.NAMES = F)

scrutini_dat$COD_REG <- 
  reg.sp$COD_REG[match(scrutini_dat$region, reg.sp$DEN_REG)]

# Province
labelProvince <- function(x) {
  library(stringr)
  x <- gsub("_"," ",x)
  x <- str_trim(x)
  x <- str_to_title(x, locale = 'it')
  return(x)
}

scrutini_dat$province <-
  sapply(scrutini_dat$geo_lev_3, labelProvince, USE.NAMES = F)
scrutini_dat$province[scrutini_dat$province == "L'aquila"] <- "L'Aquila"
scrutini_dat$province[scrutini_dat$province == "Reggio Calabria"] <- "Reggio di Calabria"
scrutini_dat$province[scrutini_dat$province == "Reggio Nell'emilia"] <- "Reggio nell'Emilia"
scrutini_dat$province[scrutini_dat$province == "Monza E Della Brianza"] <- "Monza e della Brianza"
scrutini_dat$province[scrutini_dat$province == "Pesaro E Urbino"] <- "Pesaro e Urbino"
scrutini_dat$province[scrutini_dat$province == "Massa-Carrara"] <- "Massa Carrara"

unique(scrutini_dat$province[!scrutini_dat$province %in% as.character(prov.sp$DEN_PCM)])

# Match names
prepareNames <- function(x) {
  x <- gsub("/(.*)", "", x)
  x <- tolower(x)
  return(x)
}

matching_df <- data.frame()
library(stringdist)
for (i in 1:nrow(scrutini_dat)) {
  this_COD_REG <- scrutini_dat$COD_REG[i]
  this_label <- scrutini_dat$geo_entity[i]
  print(i)
  this_dat <- 
    open_shp_20161204_F.sp[
      open_shp_20161204_F.sp$COD_REG == this_COD_REG,]@data
  
  # String match 1
  this_PRO_COM_T <- 
    as.character(this_dat$PRO_COM_T[match(prepareNames(this_label), 
                                          prepareNames(this_dat$COMUNE))])
  if (!is.na(this_PRO_COM_T)) {
    if (length(this_PRO_COM_T) == 1) {
      matching_df <- 
        rbind(matching_df, 
              data.frame(COD_REG = this_COD_REG,
                         geo_entity = this_label,
                         PRO_COM_T = this_PRO_COM_T,
                         COMUNE = as.character(this_dat$COMUNE[
                           this_dat$PRO_COM_T == this_PRO_COM_T]),
                         dist = 0))
    }
  } else {
    these_dists <- 
      stringdist(prepareNames(this_label), 
                 prepareNames(this_dat$COMUNE))
    this_PRO_COM_T <- as.character(this_dat$PRO_COM_T[which.min(these_dists)])
    matching_df <- 
      rbind(matching_df, 
            data.frame(COD_REG = this_COD_REG,
                       geo_entity = this_label,
                       PRO_COM_T = this_PRO_COM_T,
                       COMUNE = as.character(this_dat$COMUNE[
                         this_dat$PRO_COM_T == this_PRO_COM_T]),
                       dist = min(these_dists)))
  }
}

matching_df$COMUNE <- as.character(matching_df$COMUNE)
matching_df$PRO_COM_T <- as.character(matching_df$PRO_COM_T)
matching_df$COD_REG <- as.character(matching_df$COD_REG)

# Manual
matching_df$COMUNE[matching_df$geo_entity == "BARZANO'"] <- 'Barzanò'
matching_df$PRO_COM_T[matching_df$geo_entity == "BARZANO'"] <- '097006'
matching_df$COD_REG[matching_df$geo_entity == "BARZANO'"] <- '3'

matching_df$COMUNE[matching_df$geo_entity == "CERRINA"] <- 'Cerrina Monferrato'
matching_df$PRO_COM_T[matching_df$geo_entity == "CERRINA"] <- '006059'
matching_df$COD_REG[matching_df$geo_entity == "CERRINA"] <- '1'

matching_df$COMUNE[matching_df$geo_entity == "SODDI'"] <- 'Soddì'
matching_df$PRO_COM_T[matching_df$geo_entity == "SODDI'"] <- '095078'
matching_df$COD_REG[matching_df$geo_entity == "SODDI'"] <- '20'

matching_df$COMUNE[matching_df$geo_entity == "ALI'"] <- 'Alì'
matching_df$PRO_COM_T[matching_df$geo_entity == "ALI'"] <- '083002'
matching_df$COD_REG[matching_df$geo_entity == "ALI'"] <- '19'

matching_df$COMUNE[matching_df$geo_entity == "REVO'"] <- 'Revò'
matching_df$PRO_COM_T[matching_df$geo_entity == "REVO'"] <- '022152'
matching_df$COD_REG[matching_df$geo_entity == "REVO'"] <- '4'

matching_df$COMUNE[matching_df$geo_entity == "CARRE'"] <- 'Carrè'
matching_df$PRO_COM_T[matching_df$geo_entity == "CARRE'"] <- '024024'
matching_df$COD_REG[matching_df$geo_entity == "CARRE'"] <- '5'

matching_df$COMUNE[matching_df$geo_entity == "MONTA'"] <- 'Montà'
matching_df$PRO_COM_T[matching_df$geo_entity == "MONTA'"] <- '004133'
matching_df$COD_REG[matching_df$geo_entity == "MONTA'"] <- '1'

matching_df$COMUNE[matching_df$geo_entity == "MUGGIO'"] <- 'Muggiò'
matching_df$PRO_COM_T[matching_df$geo_entity == "MUGGIO'"] <- '108034'
matching_df$COD_REG[matching_df$geo_entity == "MUGGIO'"] <- '3'

matching_df$COMUNE[matching_df$geo_entity == "VIGANO'"] <- 'Viganò'
matching_df$PRO_COM_T[matching_df$geo_entity == "VIGANO'"] <- '097090'
matching_df$COD_REG[matching_df$geo_entity == "VIGANO'"] <- '3'

matching_df$COMUNE[matching_df$geo_entity == "TREMOSINE"] <- 'Tremosine sul Garda'
matching_df$PRO_COM_T[matching_df$geo_entity == "TREMOSINE"] <- '017189'
matching_df$COD_REG[matching_df$geo_entity == "TREMOSINE"] <- '3'

matching_df$COMUNE[matching_df$geo_entity == "MELICUCCA'"] <- 'Tremosine sul Garda'
matching_df$PRO_COM_T[matching_df$geo_entity == "MELICUCCA'"] <- '080048'
matching_df$COD_REG[matching_df$geo_entity == "MELICUCCA'"] <- '18'

# open_shp_20161204_F.sp$COMUNE[!open_shp_20161204_F.sp$PRO_COM_T %in% matching_df$PRO_COM_T]

scrutini_dat <- cbind(scrutini_dat, matching_df[,3:4])
names(scrutini_dat)[14:18] <- c('region_nam', 'region_num', 'province_nam', 'istat_cod', 'istat_nam') 
scrutini_dat$province_nam <- NULL

open_shp_20161204_F.sp <- open_shp_20161204_F.sp[,c('PRO_COM_T','COMUNE','COD_REG')]
names(open_shp_20161204_F.sp) <- c('istat_cod','istat_nam','region_num')

write.csv(scrutini_dat, file = 'open_csv_20161204_F.csv', row.names = FALSE)
writeOGR(obj=open_shp_20161204_F.sp, 
         dsn='.',  
         layer='open_shp_20161204_F',
         driver="ESRI Shapefile")
