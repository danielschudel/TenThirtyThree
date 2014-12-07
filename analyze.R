suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(scales))

preferredPNGWidth  <- 1600
preferredPNGHeight <- 1024

fixupData <- function(data) {
    # TODO - use a function to camel case this
    colnames(data) <- c("agencyName", "state", "NSN", "itemName", "quantity", "UI", "acquisitionValue", "DEMILCode", "DEMILIC", "shipDate", "county", "agencyType")

    # Simplify names of agencies
    data$agencyName <- tolower(data$agencyName)
    data$agencyName <- gsub("sheriff dept",          "sheriff",    data$agencyName, ignore.case=TRUE)
    data$agencyName <- gsub("police dept",           "police",     data$agencyName, ignore.case=TRUE)
    data$agencyName <- gsub("sheriff office",        "sheriff",    data$agencyName, ignore.case=TRUE)
    data$agencyName <- gsub("county",                "co.",        data$agencyName, ignore.case=TRUE)
    data$agencyName <- gsub(" highway ",             " hwy ",      data$agencyName, ignore.case=TRUE)
    data$agencyName <- gsub("raleigh durham intl.*", "RDU Police", data$agencyName, ignore.case=TRUE)

    # Cleanup item names
    data$itemName   <- tolower(data$itemName)

    # These items are probably innocuous, remove them
    ignore <- paste(
                    "truck,utility",
                    "helicopter,observation",
                    "semitrailer,low bed",
                    "cargo",
                    "truck,van",
                    "^trailer$",
                    "^truck tractor$",
                    "^floodlight set,electric",
                    "shipping and storage container",
                    "shop equipment,electrical equipment,semi trailer mounted",
                    sep="|")
    data <- data[! grepl(ignore, data$itemName),]

    # Combine like terms
    data$itemName <- gsub("sight,night vision", "night vision sight",                     data$itemName)
    data$itemName <- gsub("night vision sight,","night vision sight",                     data$itemName)
    data$itemName <- gsub("^rifle.*$",          "rifle",                                  data$itemName)
    data$itemName <- gsub("^pistol.*$",         "pistol",                                 data$itemName)
    data$itemName <- gsub("^only complete.*vehicles$", "combat/assault/tactical vehicle", data$itemName)
    data$itemName <- gsub(",$", "", data$itemName)

    # Reduce factors
    data$state      <- factor(data$state)
    data$itemName   <- factor(data$itemName)
    data$agencyName <- factor(data$agencyName)
    data$NSN        <- factor(data$NSN)
    data$UI         <- factor(data$UI)
    data$DEMILCode  <- factor(data$DEMILCode)
    data$DEMILIC    <- factor(data$DEMILIC)

    data$one        <- 1

    # Orange County seems to have recieved something on the cheap. Let's fix that.
    vehicle <- data$itemName == "combat/assault/tactical vehicle"
    realCost <- mean(data[vehicle & data$acquisitionValue > 1.00 ,"acquisitionValue"])
    data[vehicle & data$acquisitionValue < 1.00 ,"acquisitionValue"] <- realCost

    data$shipYear <- as.numeric(format(data$shipDate, "%Y"))

    return(data)
}

mergeWithCounties <- function(data) {
    counties <- read.csv("Data/agencyCounty.csv")
    merged <- merge(data, counties, by.y="agencyName", by.x="Agency.Name", all=TRUE)
    return(merged)
}

give1033Data <- function() {
    if (FALSE == file.exists("Data/tacticalatLEAMA-WYandTerr.xls")) {
        print("Please decompress the data files into the Data directory")
    } else {
#       print("Loading NC Data")
        options(java.parameters = "-Xmx2048m")
        suppressPackageStartupMessages(library(XLConnect))
        wk <- loadWorkbook("Data/tacticalatLEAMA-WYandTerr.xls")
        df1033 <- readWorksheet(wk, sheet="NC")
#       print("Fixing NC Data")
        df1033 <- mergeWithCounties(df1033)
        df1033 <- fixupData(df1033)
#       print("NC Data Ready")
    }
    return(df1033)
}



valueByAgency <- function(data) {
    data <- ddply(data, .(agencyName), summarize, total=sum(acquisitionValue), count=sum(one))
    data <- data[with(data, order(total, decreasing=TRUE)),]
    return(data)
}

valueByItem <- function(data) {
    data <- ddply(data, .(itemName), summarize, total=sum(acquisitionValue), count=sum(one))
    data <- data[with(data, order(total, decreasing=TRUE)),]
    return(data)
}

plotValueByAgencyHistogram <- function(ordered) {
    png("Plots/transferTotalValueByAgencyHistogram.png", width=preferredPNGWidth, height=preferredPNGHeight)
    p <- ggplot(ordered, aes(x=total)) +
         geom_histogram() +
         scale_x_log10() +
         labs(title="Histogram of Transfer Values per Agency",
              x="Dollars",
              y="Count"
              ) +
         theme(axis.title   = element_text(size=40),
               axis.text    = element_text(size=40),
               axis.text.y  = element_text(size=30),
               axis.text.x  = element_text(size=30),
               plot.title   = element_text(size=60),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=20))
    print(p)
    dev.off()
}

plotValueByAgencyTopN <- function(ordered) {
    png("Plots/transferAgencyTotalValueTopN.png", width=preferredPNGWidth, height=preferredPNGHeight)
    p <- ggplot(ordered, aes(x=reorder(agencyName, total), y=total, fill=total)) +
         geom_bar(stat="identity") +
         coord_flip() +
         scale_y_continuous(labels=comma) +
         scale_fill_continuous(labels=comma) +
         labs(title="Top Agencies By Received Value",
              x="Agency",
              y="US Dollars",
              fill="US Dollars"
              ) +
         theme(axis.title   = element_text(size=40),
               axis.text    = element_text(size=40),
               axis.text.y  = element_text(size=30),
               axis.text.x  = element_text(size=30),
               plot.title   = element_text(size=60),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=20))
    print(p)
    dev.off()
}

plotValueByItemTopN <- function(ordered) {
    png("Plots/transferItemTotalValueTopN.png", width=preferredPNGWidth, height=preferredPNGHeight)
    p <- ggplot(ordered, aes(x=reorder(itemName, total), y=total, fill=count)) +
         geom_bar(stat="identity") +
         coord_flip() +
         scale_y_continuous(labels=comma) +
         scale_fill_continuous(labels=comma) +
         labs(title="Top Item By Transfer Value",
              x="Item",
              y="US Dollars",
              fill="Total Item Count"
              ) +
         theme(axis.title   = element_text(size=40),
               axis.text    = element_text(size=40),
               axis.text.y  = element_text(size=30),
               axis.text.x  = element_text(size=30),
               plot.title   = element_text(size=60),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=20))
    print(p)
    dev.off()
}

plotTransferDatesByTriangleCounties <- function(data) {
    p <- ggplot(data, aes(x=agencyName, y=shipYear)) +
         geom_boxplot() +
         coord_flip() +
         labs(title="Triangle Agencies\nBy Total Transfer Value",
              x="Agency",
              y="US Dollars",
              fill="Total Item Count"
              ) +
         theme(axis.title   = element_text(size=40),
               axis.text    = element_text(size=40),
               axis.text.y  = element_text(size=30),
               axis.text.x  = element_text(size=30),
               plot.title   = element_text(size=30),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=20))
    print(p)
#   dev.off()
}

plotValueByTriangleCounties <- function(data) {
#   png("Plots/transferItemTotalValueTriangle.png", width=preferredPNGWidth, height=preferredPNGHeight)

    data <- ddply(data,
                      .(agencyName),
                      summarize,
                      totalAcquisitionValue=sum(acquisitionValue),
                      totalAcquired=sum(quantity))

    p <- ggplot(data, aes(x=reorder(agencyName, totalAcquisitionValue), y=totalAcquisitionValue, fill=totalAcquired)) +
         geom_bar(stat="identity") +
         coord_flip() +
         scale_y_continuous(labels=comma) +
         scale_fill_continuous(labels=comma) +
         labs(title="Triangle Agencies\nBy Total Transfer Value",
              x="Agency",
              y="US Dollars",
              fill="Total Item Count"
              ) +
         theme(axis.title   = element_text(size=40),
               axis.text    = element_text(size=40),
               axis.text.y  = element_text(size=30),
               axis.text.x  = element_text(size=30),
               plot.title   = element_text(size=30),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=20))
    print(p)
#   dev.off()
}

plotItemsByTriangleCounties <- function(data) {
#   png("Plots/transferItemsToTriangle.png", width=preferredPNGWidth, height=preferredPNGHeight)

    data$combinedAgencyItem <- paste(data$agencyName, " (", data$itemName, ")", sep="")

    data <- ddply(data,
                      .(combinedAgencyItem),
                      summarize,
                      totalAcquisitionValue=sum(acquisitionValue),
                      totalAcquired=sum(quantity)
                      )

    p <- ggplot(data, aes(x=reorder(combinedAgencyItem, totalAcquisitionValue), y=totalAcquisitionValue, fill=totalAcquired)) +
         geom_bar(stat="identity") +
         coord_flip() +
         scale_y_continuous(labels=comma) +
         scale_fill_continuous(labels=comma) +
         labs(title="Triangle Agencies and Items\nBy Total Transfer Value",
              x="Agency",
              y="US Dollars",
              fill="Total\nItem\nCount"
              ) +
         theme(axis.title   = element_text(size=10),
               axis.text    = element_text(size=10),
               axis.text.y  = element_text(size=20),
               axis.text.x  = element_text(size=20),
               axis.title.y = element_blank(),
               axis.title.x = element_text(size=20),
               plot.title   = element_text(size=30),
               strip.text   = element_text(size=40),
               legend.title = element_text(size=20),
               legend.text  = element_text(size=15))
    print(p)
#   dev.off()
}

plotAll <- function() {
    agencyOderedByTotalValue <- valueByAgency(df1033)
    plotValueByAgencyHistogram(agencyOderedByTotalValue)
    plotValueByAgencyTopN(agencyOderedByTotalValue[1:20,])

    itemOderedByTotalValue <- valueByItem(df1033)
    plotValueByItemTopN(itemOderedByTotalValue[1:15,])

    triangle <- selectOutTriangle(df1033)
    plotValueByTriangleCounties(triangle)
    plotItemsByTriangleCounties(triangle)
}

triangleCounties <- paste("Orange",
                          "Durham",
                          "Wake",
                          "Chatham",
                          sep="|")

selectOutTriangle <- function(data) {
    triangle <- data[grepl(triangleCounties, data$county),]
    return(triangle)
}

analyzeTriangle <- function(data) {
    triangle <- selectOutTriangle(data)
    triangle <- ddply(triangle,
                      .(agencyName, itemName, acquisitionValue),
                      summarize,
                      totalAcquisitionValue=sum(acquisitionValue),
                      totalAcquired=sum(quantity))
    triangle <- triangle[with(triangle, order(acquisitionValue, agencyName, decreasing=TRUE)),]
    print(triangle)
}

analyzeAll <- function() {
    analyzeTriangle(df1033)
}
