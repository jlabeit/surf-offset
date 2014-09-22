require(tikzDevice) 
source("../../external/sdsl-lite/benchmark/basic_functions.R")


mypaste <- function(...){
    paste(...,sep="")
}

my_format2 <- function(...){
   format(..., nsmall=2,digits=2, big.mark=",")
}

tikz("experiment3.tex", width = 6.3, height = 6.3, standAlone = F)

raw <- data_frame_from_key_value_pairs("../results/experiment3.txt")
raw2 <- data_frame_from_key_value_pairs("../../external/sdsl-lite/benchmark/document_retrieval/results/all.txt")
names(raw2) <- gsub("TC_ID","collection_file",names(raw2))
names(raw2) <- gsub("IDX_ID","index_name",names(raw2))
raw3 <- data_frame_from_key_value_pairs("../../external/sdsl-lite/benchmark/document_retrieval/results/all_int.txt")
names(raw3) <- gsub("TC_ID","collection_file",names(raw3))
names(raw3) <- gsub("IDX_ID","index_name",names(raw3))

data <- rbind( 
    raw[c("collection_file","index_name","query_len","time_per_query","TLE")],
    raw2[c("collection_file","index_name","query_len","time_per_query","TLE")],
    raw3[c("collection_file","index_name","query_len","time_per_query","TLE")])
data <- subset(data,data[["TLE"]]==0)

data[["collection_file"]] <- gsub("../collections/","",data[["collection_file"]])
data[["index_name"]] <- as.character( data[["index_name"]] )

d <- split(data, data$collection_file)
collections <- names(d)

idx2pch <- list()
idx2pch[["IDX_NNX"]] <- 1
idx2pch[["IDX_NNX_INT"]] <- 1
idx2pch[["GREEDY"]] <- 2 
idx2pch[["GREEDYINT"]] <- 2 
idx2pch[["SORT"]] <- 3
idx2pch[["SORTINT"]] <- 3

idx2name <- list()
idx2name[["IDX_NNX"]] <- "IDX\\_NNX"
idx2name[["IDX_NNX_INT"]] <- "IDX\\_NNX\\_INT"
idx2name[["GREEDY"]] <- "GREEDY"
idx2name[["GREEDYINT"]] <- "GREEY\\_INT"
idx2name[["SORT"]] <- "SORT"
idx2name[["SORTINT"]] <- "SORT\\_INT"

par(mfrow=c(2,2))
par(las=1)

#for ( collection in collections ){
for ( collection in c("ENWIKISML","ENWIKIBIG","ENWIKISMLINT","ENWIKIBIGINT") ){
#    collection <- "ENWIKIBIG"
    cat(collection)
    cat("\n")
    d2 <- d[[collection]]
    d3 <- split(d2,d2[["index_name"]])
    if ( length(d3) > 1 ) {
        plot(NA, xlim=c(1,20),ylim=c(10,100000), log="y",
             main=collection,
             xlab="Pattern length",
             ylab="Avg time per query [$\\mu secs$]")
        ff <- seq(1,9)
        abline(h=c(ff*10,ff*100,ff*1000,ff*10000,100000),col="gray")
        
        for ( idx in names(d3) ) {
            lines(d3[[idx]][["query_len"]], d3[[idx]][["time_per_query"]], 
                  pch=idx2pch[[idx]], type="b")
        }
        legend("topright",
                legend=as.character(unlist(idx2name[names(d3)])),
                pch=as.vector(unlist(idx2pch[names(d3)])),
                bty="n", cex=0.9
              )

    }
}

dev.off()