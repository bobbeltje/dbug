
#' Debug module - execute R code in a running application
#'
#' Use `debug_ui("module_name")` inside the UI part of the application and
#' `callModule(debug_server, "module_name")` inside the server function.
#'
#' @param id Module id
#' @param env The environment in which the R code should be running (e.g., the server function)
#'
#' @examples
#' shinyApp(
#'   ui=fluidPage(
#'     debug_ui('foo')
#'   ),
#'   server=function(input, output, session){
#'     callModule(debug_server, 'foo', env=environment())
#'   }
#' )
#' @name debug_module
NULL

#' @rdname debug_module
#' @export
debug_ui <- function(id){
  ns <- NS(id)
  div(
    textAreaInput(ns('input'), NULL, placeholder='Enter R code', rows=5),
    actionButton(ns('run'), 'run'),
    verbatimTextOutput(ns('result'))
  )
}

#' @rdname debug_module
#' @export
debug_server <- function(input, output, session, env=environment()){

  r <- eventReactive(input$run, {
    x <- try(eval(parse(text=input$input), envir=env), silent=TRUE)
    x
  })

  output$result <- renderPrint({
    r()
  })
}

