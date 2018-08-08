plot.wellber = function(obj, num_var, ...) {

  ### Required packages: ggplot2

  plot_data <- obj %>% extract2(num_var)
  print(plot_data)
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
