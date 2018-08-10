#' Load the 2017 OECD Better Life data
#'
#' @return A list containing the 2017 OECD Better Life Index data in \code{\link{tibble}}
#' form with indicator classes now included
#' @export
#' @importFrom repmis "source_data"
#' @importFrom tibble "as_tibble"
#' @importFrom dplyr "%>%" "select" "left_join"
#' @seealso \code{\link{select.wellber}}, \code{\link{plot.wellber}}
#' @examples data = load_wellber()
load_wellber = function() {

  ### Required packages: repmis, dplyr, magrittr, tibble

  # Read in RDA data
  #load("~/Documents/MSc Data Analytics/Year_3/Adv Data Prog with R (STAT40830)/Wk_11/qualifer/R/sysdata.rda")

  # Read in RDA data from GitHub link
  source_data("https://github.com/jovard/project_data/blob/master/sysdata.rda?raw=True",
              cache = FALSE)

  # Convert to Tibble
  data_ <- tibble::as_tibble(raw_data)

  # Create lookup tibble to find Class group for each Indicator
  Index <- c("ES_EDUA","ES_EDUEX","ES_STCS",
           "PS_REPH","PS_FSAFEN",
           "WL_EWLH","SW_LIFS","WL_TNOW",
           "CG_VOTO","CG_SENG",
           "JE_EMPL","JE_LMIS","JE_LTUR",
           "SC_SNTWS",
           "EQ_WATER","EQ_AIRP",
           "JE_PEARN","IW_HADI","IW_HNFW",
           "HS_SFRH","HS_LEB",
           "HO_NUMR","HO_BASE","HO_HISH")

  Class <- c(rep("Education",3),
              rep("Safety",2),
              rep("Life_Satisfaction",3),
              rep("Civic_Engagement",2),
              rep("Jobs",3),
              rep("Community",1),
              rep("Environment",2),
              rep("Income",3),
              rep("Health",2),
              rep("Housing",3))

  # Create lookup to link Indicator with a Class label
  lookup <- as_tibble(cbind(Index,Class))
  lookup$Index = factor(lookup$Index)

  # Filter data based on arg, join to identify class and subset
  data_out <- data_ %>%
    select(LOCATION:Unit, Value:Flag.Codes) %>%
    left_join(lookup, by = c("INDICATOR" = "Index")) %>%
    select(LOCATION, Country, INDICATOR, Indicator, Inequality, Unit, Value, Class)

  # Put it all in a list and return
  out_list = list(data_obj = data_out)

  class(out_list) = 'wellber'

  return(out_list)
}
