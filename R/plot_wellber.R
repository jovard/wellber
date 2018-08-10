#' Plot wellber object
#'
#' @param obj An object of class \code{wellber} output from \code{\link{select_wellber}}
#' @param num_var A flag to indicate whether to plot the indicator or indicator class data
#' @param ... Other arguments to plot
#'
#' @return Nothing is returned - plot is rendered
#' @export
#' @import ggplot2
#' @importFrom dplyr "%>%"
#' @importFrom magrittr "extract2"
#' @importFrom stats "reorder"
#' @seealso \code{\link{load.wellber}}, \code{\link{select.wellber}}
#' @examples
#' data_object = load_wellber()
#' subset_data = selector(data_object, country = 'Austria',
#' qual_ind = 'Air pollution', samp_type = 'Total', wind_size = 'small')
#' plot(subset_data, num_var = 1)
#' plot(subset_data, num_var = 2)
plot = function(obj, num_var, ...) {
  UseMethod('plot')
}
plot.wellber = function(obj, num_var, ...) {

  ### Required packages: ggplot2

  plot_data <- obj %>% extract2(num_var)

  p = ggplot(plot_data, aes(reorder(LOCATION, Rank), Value, fill = In_focus )) +
    geom_bar(stat = "identity") +
    geom_text(aes(label=Rank), position=position_dodge(width=0.5), vjust=-0.5) +

    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    scale_fill_manual( values = c( "yes"="tomato", "no"="grey" ), guide = FALSE )

  if (num_var == 1){
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
