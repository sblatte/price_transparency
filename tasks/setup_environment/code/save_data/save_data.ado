program save_data
    version 11
    syntax anything(name=filename) [if], key(varlist) [outsheet csv log_replace log(str) missok* nopreserve logonly]
    local filenamestripped = subinstr(`"`filename'"',char(34),"",.)
    
    * Do not allow csv extension without 'csv' option and non dta extension if 'csv' option is not used
    if "`csv'"=="" & "`outsheet'"=="" {
        if regexm("`filenamestripped'", "\.csv$") {
            di "Error: '.csv' extension is not allowed without the 'csv' option."
            exit 198
        }
        if !regexm("`filenamestripped'", "\.dta$") {
            di "Error: '.dta' extension is mandatory if 'csv' option is not invoked."
            exit 198
        }
    }
    * Do not allow csv option without .csv extension
    if "`csv'"!="" | "`outsheet'"!="" {
        if !regexm("`filenamestripped'", "\.csv$") {
            di "Error: '.csv' extension is mandatory if 'csv' or 'outsheet' option is invoked."
            exit 198
        }
    }

    if "`preserve'"!="nopreserve" {
        preserve
    }

    if "`if'"!="" {
        keep `if'
    }
    isid `key', sort `missok'
    order `key', first
    compress

    * Define default log value
    if "`log'"=="" {
        if strpos("`filenamestripped'", "../output") local log = "../report/" + subinstr("`filenamestripped'","../output/","",1) + ".log"
        if strpos("`filenamestripped'", "../temp") local log = "../report/" + subinstr("`filenamestripped'","../temp/","",1) + ".log"
    }

    if "`logonly'"=="" { //The logonly option skips saving
    if "`outsheet'"!=""|"`csv'"!="" {
        export delimited using `filename', `options'
    }
    else {
        save `filename', `options'
    }
    }

    if "`log_replace'"!="" {
        print_info_to_log using `log', filename(`filename') key(`key') overwrite
    }
    else {
        print_info_to_log using `log', filename(`filename') key(`key')
    }

    //Remove date that 'describe' command prints in logfile
    shell sed -i.bak 's/[0-3]*[0-9] [JFMASOND][aceopu][bcglnprtvy] 202[2-9] [0-2][0-9]:[0-5][0-9]//' `log'
    //Remove tempfile path from CSV logfile
    shell sed -i.bak 's/^Contains data from \/var\/folders.*//' `log'
    shell sed -i.bak 's/^Contains data from \/tmp\/.*//' `log'
    shell sed -i.bak 's/Note: Dataset has changed since last saved.//' `log'
    
    //Add correct filename to description if saved as CSV
    local filenamesed = subinstr("`filenamestripped'","/","\/",.)
    local sedpattern = "'s/^Contains data from .*/Contains data from `filenamesed'/'"
    if "`csv'"!="" shell sed -i.bak `sedpattern' `log'
    rm `log'.bak

    if "`preserve'"!="nopreserve" {
        restore
    }
end

program print_info_to_log
    syntax using/, filename(str) key(varlist) [nolog overwrite]
    set linesize 100 //arbitrary selection

    if "`using'"~="none" {
        if "`overwrite'"!=""{
            qui log using `using', text replace name(save_data_log)
        }
        else{
            qui log using `using', text append name(save_data_log)
        }
    }
    di "=================================================================================================="
    if regexm("`filename'", "\.") == 0 {
        di "File: `filename'.dta"
    }
    else {
        di "File: `filename'"
    }
    di "Key: `key'"
    di "=================================================================================================="
    datasignature
    desc
    sum
    di ""
    cap log close save_data_log
end
