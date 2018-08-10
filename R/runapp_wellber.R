#' Executes app to compared country well-being data
#'
#' @return Nothing is returned but the app is run
#' @export
run = function() {
  UseMethod('run')
}

run.wellber <- function() {
  app.dir <- system.file("wellber_app", package = "wellber")
  shiny::runApp(app.dir, display.mode = "normal")
}
