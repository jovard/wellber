#' Plot wellber object
#'
#' @param obj An object of class \code{wellber} output from \code{\link{selector}}
#' @param ind_class A flag to indicate whether to plot the indicator or indicator class data
#' @param ... Other arguments to plot
#'
#' @return Nothing is returned - plot is rendered
#' @export
#' @import ggplot2
#' @importFrom dplyr "%>%"
#' @importFrom magrittr "extract2"
#' @importFrom stats "reorder"
#' @seealso \code{\link{load.wellber}}, \code{\link{selector}}
#' @examples
#' data_object = load.wellber()
#' subset_data = selector(data_object, country = 'Chile',
#' qual_ind = 'Housing expenditure', samp_type = 'Total', wind_size = 'Small')
#' plot(subset_data, ind_class = 0)
#' plot(subset_data, ind_class = 1)
plot = function(obj, ind_class, ...) {
  UseMethod('plot')
}

#' @export
plot.wellber = function(obj, ind_class=0, ...) {

  # Create global variables to avoid annoying CRAN notes
  LOCATION = Value = Rank = In_focus = NULL

  plot_data <- obj %>% extract2(ind_class+1)

  p = ggplot2::ggplot(plot_data, aes(reorder(LOCATION, Rank), Value, fill = In_focus )) +
    geom_bar(stat = "identity") +
    geom_text(aes(label=Rank), position=position_dodge(width=0.5), vjust=-0.5) +

    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    scale_fill_manual( values = c( "yes"="tomato", "no"="grey" ), guide = FALSE )

  if (ind_class == 0){
    min <- obj$min_max[1]
    max <- obj$min_max[2]

    p + ggtitle(paste0(plot_data$Indicator)) +
    xlab("Country") + ylab(paste0(plot_data$Unit)) +

    geom_hline(aes(yintercept = min, alpha=0.5), color="black", linetype="dashed",show.legend=F) +
    geom_hline(aes(yintercept = max, alpha=0.5), color="black", linetype="dashed",show.legend=F)
  }
  else {
    p + ggtitle(paste0(plot_data$Class)) +
    xlab("Country") + ylab("Score")
  }
}
