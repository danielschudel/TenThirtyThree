library(acs)

options(java.parameters = "-Xmx2048m")
suppressPackageStartupMessages(library(XLConnect))
if (FALSE == exists("wk")) {
    wk <- loadWorkbook("Data/tacticalatLEAMA-WYandTerr.xls")
    nc <- readWorksheet(wk, sheet="NC")
}

df <- as.data.frame(unique(nc[,c("Agency.Name")]))
df$county <- "unknown"
colnames(df) <- c("agencyName", "county")

interesting <- grepl("COUNTY", df$agencyName)
df[interesting, "county"] <- as.character(df[interesting, "agencyName"])

#interesting <- grepl(" CO ", df$agencyName)
#df[counties, "county"] <- as.character(df[interesting, "agencyName"])

interesting <- grepl("^NC", df$agencyName)
df[interesting, "county"] <- "State"

interesting <- grepl("^US", df$agencyName)
df[interesting, "county"] <- "Federal"

interesting <- grepl("AIRPORT", df$agencyName)
df[interesting, "county"] <- "Airports"

interesting <- grepl("UNIV|COLLEGE", df$agencyName)
df[interesting, "county"] <- "Universities"

df[df$agencyName == "BOILING SPRINGS LAKE POLICE DEPT",  "county"] <- "Cleveland County"
df[df$agencyName == "BUTNER PUBLIC SAFETY",              "county"] <- "Granville County"
df[df$agencyName == "CHARLOTTE MECKLENBURG POLICE DEPT", "county"] <- "Mecklenburg County"
df[df$agencyName == "EDEN POLICE DEPT",                  "county"] <- "Rockingham County"
df[df$agencyName == "FORSYTH ALCOHOLIC BEV CONTROL",     "county"] <- "Forsyth County"
df[df$agencyName == "FOXFIRE VILLAGE POLICE DEPT",       "county"] <- "Moore County"
df[df$agencyName == "FRANKLIN POLICE DEPT",              "county"] <- "Macon County"
df[df$agencyName == "GASTON CO SHERIFF DEPT",            "county"] <- "Gaston County"
df[df$agencyName == "GASTONIA CITY POLICE DEPT",         "county"] <- "Gaston County"
df[df$agencyName == "HENDERSON POLICE DEPT",             "county"] <- "Vance County"
df[df$agencyName == "JACKSON POLICE DEPT",               "county"] <- "Northampton County"
df[df$agencyName == "KING POLICE DEPT",                  "county"] <- "Stokes County"
df[df$agencyName == "LAURINBURG POLICE DEPT",            "county"] <- "Scotland County"
df[df$agencyName == "MARION POLICE DEPT",                "county"] <- "McDowll County"
df[df$agencyName == "NEWTON POLICE DEPT",                "county"] <- "Catawba County"
df[df$agencyName == "ROBBINS POLICE DEPT",               "county"] <- "Moore County"
df[df$agencyName == "ROCKINGHAM POLICE DEPT",            "county"] <- "Richmond County"
df[df$agencyName == "SAINT PAULS POLICE DEPT",           "county"] <- "Robeson County"
df[df$agencyName == "SPENCER POLICE DEPT",               "county"] <- "Rowan County"
df[df$agencyName == "SPRING LAKE POLICE DEPT",           "county"] <- "Cumberland County"
df[df$agencyName == "TOPSAIL BEACH POLICE DEPT",         "county"] <- "Pender County"
df[df$agencyName == "WAKEMED CAMPUS POLICE",             "county"] <- "Wake Med Campus Police"
df[df$agencyName == "WASHINGTON POLICE DEPT",            "county"] <- "Beaufort County"
df[df$agencyName == "WELDON POLICE DEPT",                "county"] <- "Halifax County"
df[df$agencyName == "WINSTON SALEM POLICE DEPT",         "county"] <- "Forsyth County"

translate <- function(d) {
    agency <- d[[1]]
    county <- d[[2]]

    lookup <- agency
    lookup <- sub(" POLICE DEPT", "", lookup)
    lookup <- sub(" POLICE",      "", lookup)

    lookup <- tolower(lookup)

    # capitalize first letter
    lookup <- sub('^(\\w?)', '\\U\\1', lookup, perl=T)

    # capitalize letter following space
    lookup <- gsub(' (\\w?)', ' \\U\\1', lookup, perl=T)

    location <- geo.lookup(state="NC", place=lookup)


    if (2 == nrow(location)) {
        location <- location[!is.na(location$county.name),]

        if (is.na(location$county.name)) {
            return
        }
        if (is.null(location$county.name)) {
            return
        }
        df[df$agencyName  == agency, "county"] <<- location$county.name
    #   print(df[df$agencyName  == agency,])
    }
}

unknown <- df[df$county == "unknown",]

apply(unknown, 1, translate)


df$county <- gsub(" SHERIFF DEPT",   "", df$county)
df$county <- gsub(" SHERIFF OFFICE", "", df$county)
df$county <- gsub(" ALCOLHOLIC BEV CONTROL", "", df$county)
df$county <- sub('^(\\w?)', '\\U\\1', tolower(df$county), perl=T)
df$county <- gsub(' (\\w?)', ' \\U\\1', df$county, perl=T)

df$agencyType <- df$county
df[grepl("POLICE", df$agencyName), "agencyType"] <- "Police"
df[grepl("SHERIF", df$agencyName), "agencyType"] <- "Sheriff"
df[grepl("ALCOHO", df$agencyName), "agencyType"] <- "ABC"
df[grepl("County", df$agencyType), "agencyType"] <- "unknown"
df$agencyType <- factor(df$agencyType)

df[grepl("RALEIGH DURHAM INTL AIRPORT POLICE", df$agencyName), "county"] <- "Durham County, Wake County"

write.csv(df, file="Data/agencyCounty.csv", row.names=FALSE)
#print(unique(df$county))
#print(df[grepl(",", df$county),])
