#' Determine range based on choosen country index and plot window size
#'
#' @param tar_ctry_ind Target, or choosen country rank
#' @param size Plot window size, either small (5), medium (11) or large (15)
#'
#' @return Returns a list of sequential country ranking IDs that include the ID for the choosen country
#' @export
#' @examples id.range = find.range.wellber(tar_ctry_ind=3, size=11)
find.range.wellber <- function(tar_ctry_ind, size){
  # Conditional loop based on rank for 39 countries in dataset
  if ((39 - tar_ctry_ind) < ((size-1)/2)){
    return(c(seq(39-(size-1),39,1)))
  }
  else if ((tar_ctry_ind - 1) < ((size-1)/2)){
    return(c(seq(1,size,1)))
  }
  else {
    return(c(seq(tar_ctry_ind - ((size-1)/2),
             tar_ctry_ind + ((size-1)/2),
           1)))
  }
}

#' Filters well-being data based on country, indicator, sample type and window size
#'
#' @param obj An object of class \code{wellber} from \code{\link{load_wellber}}
#' @param country The selected OECD country to compare against, of which there are 39
#' @param qual_ind The selected well-being indicator, of which there are 24
#' @param samp_type The sample type to be considered, either total, men, women
#' @param wind_size The size of the plot range, either small, medium or large
#'
#' @return Returns a list of class \code{wellber} that includes the filtered indicator dataset, with min and max values, and an indicator class dataset based on the indicator variable selected
#' @export
#' @importFrom dplyr "%>%" "filter" "arrange" "mutate" "desc" "row_number" "case_when" "group_by" "summarise" "slice"
#' @importFrom magrittr "extract2"

#' @seealso \code{\link{load_wellber}}, \code{\link{plot}}
#' @examples
#' data_object = load_wellber()
#' subset_data = selector(data_object, country = 'Austria',
#' qual_ind = 'Air pollution', samp_type = 'Total', wind_size = 'small')
selector = function(obj, country, qual_ind, samp_type, wind_size) {
  UseMethod('selector')
}

#' @export
selector.wellber = function(obj, country, qual_ind, samp_type, wind_size) {

  # Create global variables to avoid annoying CRAN notes
  LOCATION = Value = Indicator = Inequality = Class = Rank = In_focus = NULL

  data <- obj %>% extract2(1) %>% # extract variable data_obj from obj
    filter(Inequality == samp_type & Indicator == qual_ind) %>% # Filter accordingly
    arrange(desc(Value)) %>% # Sort by value
    mutate(Rank = row_number(), # Country rank order for a choosen indicator
           In_focus = case_when(Country == country ~ "yes", # A flag for use in colour plotting
                                Country != country ~ "no"))

  # Find max and min data values for choosen indicator
  max_val <- max(data$Value)
  min_val <- min(data$Value)

  # Translate window_size to an integer size
  size = switch(wind_size,
                small = 5,
                medium = 11,
                large = 15)

  # Locate country index and use to slice data based on variable size
  ctry_index <- which(data$Country == country)
  range <- find.range.wellber(ctry_index, size)
  data_sub_out <- data %>% slice(range) # Slice dataset

  tar_class <- as.character(unique(data_sub_out[,'Class']))

  ctry_index <- which(data_sub_out$In_focus == "yes")
  ctry_acronym = levels(data_sub_out$LOCATION)[as.numeric(data_sub_out[ctry_index,"LOCATION"])]

  data_class <- obj %>% extract2(1) %>%
    filter(Inequality == samp_type, Class == tar_class) %>%
    group_by(LOCATION) %>%
    summarise(Value = sum(Value)) %>%
    arrange(desc(Value)) %>%
    mutate(Class = tar_class, Rank = row_number(),
           In_focus = case_when(LOCATION == ctry_acronym ~ "yes",
                                LOCATION != ctry_acronym ~ "no")) %>%
    select(Class, LOCATION, Value, Rank, In_focus)

  # Locate country index and use to slice data based on variable size
  ctry_index <- which(data_class$LOCATION == ctry_acronym)
  class_range <- find.range.wellber(ctry_index, 5) # Default for indicator category size is 5
  data_class_out <- data_class %>% slice(class_range) # Slice dataset

  # Put it all in a list and return
  out_list = list(data_subset = data_sub_out,
                  data_class_totals = data_class_out,
                  min_max = c(min_val,max_val))

  class(out_list) = 'wellber'

  return(out_list)
}
