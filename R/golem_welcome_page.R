#' Welcome Page
#'
#' @import shiny
#'
#' @export
golem_welcome_page <- function() {
  tagList(
    tags$head(
      tags$style("
        body {
          background-color: #7176b8;
        }

          h1 {
            font-family: 'Rubik', sans-serif;
            font-weight: 700;
            font-size: 3rem;
            color: #ffffff;
          }

          .main {
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            gap: 2rem;
            padding-top: 2rem;
          }

          .title {
            display: flex;
            justify-content: center;
            align-items: center;
          }

          .golem_section {
            display: flex;
            flex-direction: column;
            align-items: center;
            border: 2.5px solid #4b5178;
            border-radius: 15px;
            padding: 1.4rem 7rem;
            width: 50%;
            margin-top: 40px;
          }

          .golem_section:hover, .doc_content:hover {
            box-shadow: 0px 0px 18px -6px #38424f;
          }

          .golem_content {
            display: grid;
            grid-template-rows: 40px auto;
            grid-row-gap:4rem;
            row-gap: 1rem;
          }

          .golem_logo {
            top: -54px;
            position: relative;
            display: flex;
            justify-content: center;
          }

          .description {
            font-family: 'Rubik', sans-serif;
            font-size: 1.5rem;
            color: #ffffff;
            line-height: 1.8;
          }

          .description a, .description span {
            color: #ffffff;
            text-decoration: none;
            background-color: #38424f61;
            padding: .35rem .60rem;
            border-radius: 5px;
            line-height: 2;
          }

          .description a {
            cursor: pointer;
          }

          .center-text {
            text-align: center;
          }

          .doc_section {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 2rem;
            width: 50%;
          }

          @media ( max-width: 850px ) {
            .doc_section {
              grid-template-columns: 1fr;
            }
          }

          .doc_content {
            padding: 1rem 2rem;
            border-radius: 10px;
            background-color: #38424f61;
            gap: 1rem;
            border: 2.5px solid #4b5178
          }

          .doc_content:hover {
            text-decoration: none;
          }

          .doc_modules {
            display: grid;
            gap: 2rem;
          }
        ")
    ),
    div(
      class = "main",
      div(
        class = "title",
        style = "",
        h1("Welcome to Golem!")
      ),
      div(
        class = "golem_section",
        div(
          class = "golem_content",
          div(
            class = "golem_logo",
            img(
              style = "height:80px;",
              src = "https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png",
            )
          ),
          div(
            p(
              class = "description center-text",
              "Remove this welcome message by removing ",
              span(
                class = "code",
                "golem_welcome_page()"
              ),
              "in",
              tags$a(
                "app_ui.R",
                href = "https://thinkr-open.github.io/golem/",
                target = "_blank"
              ),
              "with your own code."
            )
          )
        )
      ),
      div(
        class = "doc_section",
        div(
          class = "doc_modules",
          a(
            class = "doc_content",
            href = "https://golemverse.org/",
            target = "_blank",
            h4(
              class = "description",
              "Golemverse"
            ),
            p(
              class = "description",
              "Golem comes with a set of packages to help you build your Shiny App.",
              br(),
              span(class = "code", "{brochure}"),
              span(class = "code", "{shinipsum}"),
              span(class = "code", "{shinidraw}"),
              span(class = "code", "{dockerfiler}"),
              br(),
              "Explore the Golemverse and discover tools to build beautiful app."
            )
          ),
          a(
            class = "doc_content",
            href = "https://github.com/ThinkR-open/golem",
            target = "_blank",
            h4(
              class = "description",
              "Feedbacks are welcome"
            ),
            p(
              class = "description",
              "If you have any idea or suggestions, please open an issue on our repo.",
            )
          )
        ),
        a(
          class = "doc_content",
          href = "https://engineering-shiny.org/",
          target = "_blank",
          h4(
            class = "description",
            "Documentation"
          ),
          p(
            class = "description",
            "Discover and explore all the possibilities offered by Golem to level up.",
            br(),
            "Read our book and learn how to build a production-ready Shiny App."
          )
        )
      )
    )
  )
}
