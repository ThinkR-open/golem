#' Interact with JavaScript built-in Functions
#' 
#' \code{activate_js} is used to insert directly some JavaScript functions in your golem.
#'  By default [bundle_ressources()] load these function  automatically for you. 
#'  
#' These JavaScript functions can be called from 
#' the server with \code{invoke_js}. \code{invoke_js} can also be used 
#' to launch any JS function created inside a Shiny JavaScript handler. 
#' 
#' @param fun JS function to be invoked.
#' @param ... JSON-like messages to be sent to the triggered JS function
#' @param session The shiny session within which to call \code{sendCustomMessage}.
#' 
#' 
#' \describe{
#'   \item{show}{Show an element with the jQuery selector provided.}
#'   \item{hide}{Hide an element with the jQuery selector provided.}
#'   \item{showid}{Show an element with the id provided.}
#'   \item{hideid}{Hide an element with the id provided.}
#'   \item{showclass}{Same as showid, but with class.}
#'   \item{hideclass}{Same as hideid, but with class.}
#'   \item{showhref}{Same as showid, but with `a[href*=`}
#'   \item{hidehref}{Same as hideid, but with `a[href*=`}
#'   \item{clickon}{Click on an element. The full jQuery selector has to be used.}
#'   \item{disable}{Add "disabled" to an element. The full jQuery selector has to be used.}
#'   \item{reable}{Remove "disabled" from an element. The full jQuery selector has to be used.}
#'   \item{alert}{Open an alert box with the message(s) provided.}
#'   \item{prompt}{Open a prompt box with the message(s) provided. This function takes 
#'   a list with message and id `list(message = "", id = "")`. The output of the prompt 
#'   will be sent to `input$id`.}
#'   \item{confirm}{Open a confirm box with the message provided. This function takes 
#'   a list with message and id `list(message = "", id = "")`. The output of the prompt 
#'   will be sent to `input$id`.}
#' }
#'
#' @export
#' @rdname golem_js
#' @importFrom shiny includeScript
activate_js <- function(){
  includeScript(
    system.file("utils/golem-js.js", package = "golem")
  )
}

#' @export
#' @rdname golem_js
#' @examples 
#' if ( interactive() ){
#' library(shiny)
#' ui <- fluidPage(
#'   golem::activate_js(), #already loaded in your golem by bundle_resources()
#'   fluidRow(
#'   actionButton(inputId = "hidebutton1",label = "hide button1"),
#'   actionButton(inputId = "showbutton1",label = "show button1"),
#'   actionButton(inputId = "button1",label = "button1")
#' ),
#'   fluidRow(
#'   actionButton(inputId = "hideclassA",label = "hide class A"),
#'   actionButton(inputId = "showclassA",label = "show class A"),
#'   actionButton(inputId = "buttonA1",label = "button A1",class="A"),
#'   actionButton(inputId = "buttonA2",label = "button A2",class="A"),
#'   actionButton(inputId = "buttonA3",label = "button A3",class="A")
#' ),
#' 
#' fluidRow(
#'   actionButton(inputId = "clickhide",label = "click on 'hide button1' and 'hide class A'"),
#'   actionButton(inputId = "clickshow",label = "click on 'show button1' and 'show class A'")
#'   ),
#' 
#' fluidRow(
#'   
#'   actionButton(inputId = "disableA",label = "disable class A"),
#'   actionButton(inputId = "reableA",label = "reable class A")
#'   
#'   
#' )
#' ,
#' 
#' fluidRow(
#'   
#'   actionButton(inputId = "alertbutton",label = "alert button"),
#'   actionButton(inputId = "promptbutton",label = "prompt button"),
#'   actionButton(inputId = "confirmbutton",label = "confirm button")
#'   
#'   
#' )
#'   )
#' 
#' server <- function(input, output, session){
#'   
#'   observeEvent( input$hidebutton1 , {
#'   golem::invoke_js("hideid","button1")
#'   })
#'   observeEvent( input$showbutton1 , {
#'   golem::invoke_js("showid","button1")
#'   })
#'   
#'   observeEvent( input$hideclassA , {
#'   golem::invoke_js("hideclass","A")
#'   })
#'   observeEvent( input$showclassA , {
#'   golem::invoke_js("showclass","A")
#'   })
#'   
#'   observeEvent( input$clickhide , {
#'   golem::invoke_js("clickon","#hidebutton1")
#'   golem::invoke_js("clickon","#hideclassA")
#'   })
#'   
#'   observeEvent( input$clickshow , {
#'   golem::invoke_js("clickon","#showbutton1")
#'   golem::invoke_js("clickon","#showclassA")
#'   })
#'   
#'   observeEvent( input$disableA , {
#'   golem::invoke_js("disable",".A")
#'   })
#'   observeEvent( input$reableA , {
#'   golem::invoke_js("reable",".A")
#'   })
#'   
#'   observeEvent( input$alertbutton , {
#'   golem::invoke_js("alert","ALERT!!")
#'   })
#'   
#'   observeEvent( input$promptbutton , {
#'     golem::invoke_js("prompt", list(message ="what's your name", id  = "name") )
#'   })
#'     observeEvent( input$name , {
#'   message(paste("input$name",input$name))
#'   })
#'   
#'   observeEvent( input$confirmbutton , {
#'     golem::invoke_js("confirm", list(message ="Are you sure", id  = "sure") )
#'   })
#'     observeEvent( input$sure , {
#'     message(paste("input$sure",input$sure))
#'   })
#' }
#' shiny::shinyApp(ui,server)
#'}
invoke_js <- function( 
  fun, 
  ...,
  session = shiny::getDefaultReactiveDomain()
){
  attempt::stop_if(
    fun == "",
    msg = "Error: Empty string is not a valid JS handler name"
  )
  messages <- list(...)
  res <- lapply(
    messages,
    function(message, fun){
      session$sendCustomMessage(fun, message)
    },
    fun = fun
  )
  invisible(res)
}

