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

selector = function(obj, country, qual_ind, samp_type, wind_size) {
  UseMethod('selector')
}

# Function manipulates raw data prior to plotting and is based on
# inputted shiny variables.
selector.wellber = function(obj, country, qual_ind, samp_type, wind_size) {

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
