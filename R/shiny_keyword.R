## Semantic network for anger and fear sadness---------------------
library(quanteda)
library(quanteda.textplots)
library(shinydashboard)
library(shiny)
library(reactable)
library(shinyjqui)
library(shinyalert)


shiny_keyword <- function(df){
  require(shiny)
  require(reactable)
  shinyApp(
    ui = navbarPage(
      sidebarLayout(
        sidebarPanel(
        sliderInput("top_n", "Bins", 5, 200, 20),
        textInput("keyword", "Keyword", "cultura"),
        textInput("hub", "Hub Keyword", "libro")),
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Keyword Network", plotOutput("keyword_Network")),
                      tabPanel("Keyword table", reactableOutput("keyword_table")),
                      tabPanel("Keyword hub Network", plotOutput("keyword_hub"))
          )
        )
      )
    ),
    server = function(input,output) {
      fcm_local <- reactive({
        toks <- tokens(df$text, remove_punct = TRUE, remove_symbols = TRUE, verbose = TRUE)
        toks <- tokens_tolower(toks)
        toks <- tokens_remove(toks, padding = FALSE, min_nchar =3)
        #toks <- tokens_wordstem(toks, language = language)

        ## A feature co-occurrence matrix
        fcmat <-quanteda::fcm(toks, context = "window", tri = FALSE)

        ##reduce only top words
        feat <-  names(topfeatures(fcmat, input$top_n))

        ##subset top 40 words
        fcm_1 <- fcm_select(fcmat, pattern = feat)
        fcm_1 <- fcm_remove(fcm_1, input$keyword)
        ##draw semantic network plot

      })

      output$keyword_Network <- renderPlot(
        textplot_network(fcm_local(), min_freq = 1, edge_color = "grey",vertex_color ="#538797"), height = 800, width = 1000 )

      toks_df <- reactive({
        toks <- tokens(df$text, remove_punct = TRUE, remove_symbols = TRUE, verbose = TRUE)
      toks <- tokens_tolower(toks)
      toks <- tokens_remove(toks, padding = FALSE, min_nchar =3)
      hash_dfm <- dfm(toks) # Document-feature matrix
      hash_dfm <- dfm_remove(hash_dfm,input$keyword)
      toptag <- sort(topfeatures(hash_dfm, input$top_n), decreasing = TRUE)
      toptag <- data.frame(toptag)
      toptag <- tibble::rownames_to_column(toptag, "keyword")
      colnames(toptag) <- c("keyword", "freq")
      toptag
      })
      output$keyword_table <- renderReactable({
        reactable::reactable(toks_df(),
                             filterable = TRUE,
                             searchable = TRUE,
                             bordered = TRUE,
                             striped = TRUE,
                             highlight = TRUE,
                             showSortable = TRUE,
                             defaultSortOrder = "desc",
                             defaultPageSize = 25,
                             showPageSizeOptions = TRUE
        )
      })

      fcm_hub <- reactive({
        toks <- tokens(df$text, remove_punct = TRUE, remove_symbols = TRUE, verbose = TRUE)
        toks <- tokens_tolower(toks)
        toks <- tokens_remove(toks, padding = FALSE, min_nchar =3)

        fcmat <-quanteda::fcm(toks, context = "window", tri = FALSE)

          ##selecting keywords inside fcmat
        tmp <- fcmat[, input$hub]
        tmp <- convert(tmp, to = "data.frame")
        colnames(tmp) <- c("nodes", "degree")
        tmp <- tmp[tmp$degree > 0, ]

        nodes_degree <- tmp[tmp$nodes == input$hub, ]$degree
        high_nodes <- tmp[tmp$degree > nodes_degree, ]$nodes

        fcm_local <- fcm_select(fcmat, pattern = c(tmp, input$hub))
        fcm_local <- fcm_remove(fcm_local, high_nodes)

        ##reduce only top words
        feat <-  names(topfeatures(fcm_local, input$top_n))

        ##subset top 40 words
        fcm_hub <- fcm_select(fcm_local, pattern = feat)

        fcm_hub
      })

      output$keyword_hub <- renderPlot(

        quanteda.textplots::textplot_network(fcm_hub(), min_freq = 1, edge_color = "grey",vertex_color ="#538797"), height = 800, width = 1000 )
}

  )
}





