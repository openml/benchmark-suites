#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

checkPackages = function(pkgs) {

  obj = installed.packages()
  not.installed = which(!pkgs %in% rownames(obj))

  if(length(not.installed > 0)) {
    need = pkgs[not.installed]
    cat(paste0(" @ Missing packages: ", paste(need, collapse = ", "), "\n"))
    install.packages(pkgs = need, repo = "http://cran.uni-muenster.de/")

    if("scmamp" %in% not.installed) {
      if (!requireNamespace("BiocManager", quietly = TRUE)) {
          install.packages("BiocManager")
      # dependencies are not in CRAN
      BiocManager::install("Rgraphviz", version = "3.8")
      BiocManager::install("graph", version = "3.8")
      }
    }
  }
  cat(" @ All required packages installed.\n")
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
