#' Save and summarize data
#'
#' @param df Data to be saved
#' @param key Defines key to dataset. Must be jointly unique. (WE MODIFY THE CODE TO ALLOW FOR MISSING VALUES IN KEYS)
#' @param missok If TRUE, missing values in the keys will be allowed. Default if FALSE.
#' @param outfile Path to saved data file. Possible file extensions are .csv, .dta, RData, and .RDS. If no file extension is provided, the data is saved as .RDS.
#' @param logfile Path to logfile. File contains standard summary statistics for numerical variables and displays variable types for all variables. If no path is specified, the log file is saved to the same directory as the output file. Type logfile = FALSE to not output a logfile.
#' @param appendlog If TRUE, an existing log file of the same name will not be overwritten but the information appended. Default is FALSE.
#' @param sortbykey If TRUE, the data will be sorted based on the keys provided. Default is TRUE.
#'
#' @seealso \link[data.table]{fwrite}, \link[base]{save}, \link[base]{saveRDS}, and \link[foreign]{write.dta},
#'
#' @examples
#' \dontrun{
#' #Save data to RDS
#' SaveData(data, "id", "path/output")
#'
#' #Multiple key variables
#' SaveData(data, c("country", "day"), "path/output")
#'
#' #Save to different file format
#' SaveData(data, "id", "path/output.csv")
#'
#' #Custom log file
#' SaveData(data, "id", "path/output.csv", "path/custom_logfile.log")
#' }
#'
#' @importFrom data.table fwrite
#' @importFrom data.table setorderv
#' @importFrom data.table setDT
#' @importFrom digest     digest
#' @importFrom dplyr      arrange mutate_if
#' @importFrom hash       keys hash
#' @importFrom foreign    write.dta
#' @importFrom knitr      kable
#' @importFrom tibble     rowid_to_column
#' @importFrom magrittr   %>%
#' @export

SaveData <- function(df, key, outfile, logfile = NULL, appendlog = FALSE, sortbykey = TRUE, missok = FALSE) {
  colSD  <- function(data) sapply(data, sd, na.rm = TRUE)
  colMin <- function(data) sapply(data, min, na.rm = TRUE)
  colMax <- function(data) sapply(data, max, na.rm = TRUE)
  reordered_colnames <- c(key, colnames(df[!colnames(df) %in% key]))


  DataDictionary <- function() {
    h <- hash()
    h[["csv"]]   <-   c("fwrite", "file = outfile")
    h[["dta"]]   <-   c("write.dta", "outfile")
    h[["RData"]] <-   c("save", "file = outfile")
    h[["RDS"]]   <-   c("saveRDS", "file = outfile")
    h[["Rds"]]   <-   c("saveRDS", "file = outfile")

    return(h)
  }

  CheckExtension <- function(outfile, h, logfile = NULL) {

    file <- basename(outfile)
    dir  <- dirname(outfile)
    extensions <- unlist(strsplit(file, "[.]"))

    if (length(extensions)  > 2) {
      stop("FileNameError: Cannot have '.' in filename.")
    } else if (length(extensions) == 2) {
      filetype = extensions[[2]]
    } else {
      filetype = "RDS"
      outfile = paste(outfile, ".RDS", sep="")
    }

    if (!any(filetype %in% keys(h))) {
      stop("FileType Error: Incorrect format. Only .csv, .dta, .RData, and .RDS are allowed.")
    }

    if (is.null(logfile)) {
      logfile <- paste("../report/", file, ".log", sep = "") #change default name and path
    }

    return(list("outfile" = outfile, "logfile" = logfile, "filetype" = filetype))
  }

  CheckKey <- function(df, key, colname_order = reordered_colnames) {        

    if (!all(key %in% colnames(df))) {

      stop("KeyError: One or more key variables are not in df.")
    }
        
    if (!missok) {
      missings <- sapply(df[key], function(x) sum(is.na(x)))
      if (sum(missings) > 0) {
        stop(paste("KeyError: There are rows with missing keys. Check the following keys:", paste(key[which(missings > 0)], collapse = ", ")))
      }
    }

    nunique <- nrow(unique(df[key]))

    if (nrow(df) != nunique) {

      stop("KeyError: Key variables do not uniquely identify observations.")

    } else {
      
      if (sortbykey) {
        setorderv(df, key)  # sort by key values
      }           

      df <- df[colname_order]

      return(df)
    }
  }


  WriteLog <- function(df, key, outfile, logfile = NULL, appendlog = TRUE,
                       colname_order = reordered_colnames) {

    if (logfile == FALSE) return(NULL)

    numeric_sum <- as.data.frame(cbind(colMeans(df[sapply(df, is.numeric)], na.rm = T),
                                       colSD(df[sapply(df, is.numeric)]),
                                       colMin(df[sapply(df, is.numeric)]),
                                       colMax(df[sapply(df, is.numeric)])))

    all_sum <- as.data.frame(cbind(colSums(!is.na(df)), sapply(df, class)))

    sum <- merge(numeric_sum, all_sum, by="row.names", all = T)
    
    sum <- sum[match(colname_order, sum$Row.names),]

    sum <- rowid_to_column(sum, "id")

    names(sum) <- c("id", "variable", "mean", "sd", "min", "max", "N", "type")

    row.names(sum) <- NULL

    hash <- digest(df, algo="md5")

    if (file.exists(logfile) & appendlog) cat('\n', file = logfile, append=T)

    cat("File: ", outfile, '\n', file = logfile, append=appendlog)
    cat("MD5:  ", hash, '\n',    file = logfile, append=T)
    cat("Key:  ", key, '\n','\n',file = logfile, append=T)
    
    df_rounded <- df %>% mutate_if(is.numeric, ~round(., digits=6)) %>% mutate_if(is.factor, as.character) # Rounding only applies to report, not actual data

    cat(paste(colnames(df), collapse=', '), '\n', file=logfile, append=T)
    cat(paste(as.character(df_rounded[1, ]), collapse=', '), '\n', file=logfile, append=T)
    cat(paste(as.character(df_rounded[2, ]), collapse=', '), '\n', file=logfile, append=T)
    cat("...", '\n', file=logfile, append=T)
    cat(paste(as.character(df_rounded[nrow(df)-1, ]), collapse=', '), '\n', file=logfile, append=T)
    cat(paste(as.character(df_rounded[nrow(df), ]), collapse=', '), '\n', file=logfile, append=T)

    s = capture.output(kable(sum, format="pipe", digits=3, align="lccccccc"))
    cat(paste(s,"\n"),file=logfile,append=T)

  }

  WriteData <- function(df, outfile, filetype, h) {
    setDT(df)

    do.call(h[[filetype]][1], list(df, eval(parse(text=h[[filetype]][2]))))

    print(paste0("File '", outfile, "' saved successfully."))

  }

  h <- DataDictionary()
  files <- CheckExtension(outfile, h, logfile)

  df <- CheckKey(df, key)
  WriteLog(df, key, files$outfile, files$logfile, appendlog)
  WriteData(df, files$outfile, files$filetype, h)

}

