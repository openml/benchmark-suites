#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

checkPackages = function(pkgs) {

  obj = installed.packages()
  not.installed = which(!pkgs %in% rownames(obj))

  if(length(not.installed > 0)) {
    need = pkgs[not.installed]
    cat(paste0(" - Missing packages: ", paste(need, collapse = ", "), "\n"))
    install.packages(pkgs = need, repo = "http://cran.uni-muenster.de/")
  }
  cat("- All required packages installed.\n")
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
