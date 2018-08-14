#' Executes app to compared country well-being data
#'
#' @return Nothing is returned but the app is run
#' @export
launch.wellber <- function() {
  app.dir <- system.file("wellber_app", package = "wellber")
  shiny::runApp(app.dir, display.mode = "normal")
}
