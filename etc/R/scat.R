# Stolen from http://biostatmatt.com/archives/491
scat <- function(y, x, cols=50, rows=20, pch="*") {
    #make an ASCII scatterplot on a rows X cols grid
    #pch is the ASCII character plotted
    #check arguments
    y <- as.numeric(y)
    if(missing(x)) x <- 1:length(y)
    else x <- as.numeric(x)
    if(length(y) != length(x))
        stop("lengths of y and x differ")
    rows <- as.numeric(rows)
    cols <- as.numeric(cols)
    if(rows < 1 || cols < 1)
        stop("rows and cols must be > 1")
    if(nchar(pch)!=1) 
        stop("pch must be exactly one character")

    #map the y and x values to rows and cols
    #FIXME values in y or x could be NA or NaN
    #FIXME division by zero when max(y)-min(y) == 0
    #FIXME any better way to do this?
    ymap <- floor((y-min(y))/(max(y)-min(y))*(rows-1))
    xmap <- floor((x-min(x))/(max(x)-min(x))*(cols-1))
    
    #sort the mapped values so that the are drawn in
    #left-to-right top-to-bottom order, because thats
    #how they will be printed, unique because we can
    #only print one character in a cell
    bitmap <- unique(cbind(ymap,xmap)[order(-ymap, xmap),])

    #initialize row and col positions
    #last plotted character row and column
    row <- rows - 1
    col <- 0
    cat(" ", rep("_", cols+4), "\n|  ", sep="")
    cat(rep(" ", cols), "  |\n|  ", sep="")
    for(bit in 1:nrow(bitmap)) {
        while(bitmap[bit,1] != row) {
            if(cols-col > 0)
                cat(rep(" ", cols-col), sep="")
            cat("  |\n|  ")
            row <- row - 1
            col <- 0
        }
        if(bitmap[bit,2]-col > 0)
            cat(rep(" ", bitmap[bit,2]-col), sep="")
        cat(pch)
        col <- bitmap[bit, 2] + nchar(pch)
    }
    if(cols-col > 0)
        cat(rep(" ", cols-col), sep="")
    cat("  |\n|", rep("_", cols+4), "|\n", sep="")
    invisible(bitmap)
}
