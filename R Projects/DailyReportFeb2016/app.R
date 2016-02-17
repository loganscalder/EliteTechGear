ui <- fluidPage(
    titlePanel("BSR"),
    fluidRow(
        column(3,
               wellPanel(
                   h4("Password"), # Heading 4 (the title of the well panel)
                   textInput("password", "Password"),
                   sliderInput("year", "Year released", 1940, 2014, value = c(1970, 2014)), # a slider with two inputs
                   sliderInput("oscars", "Minimum number of Oscar wins (all categories)",
                               0, 4, 0, step = 1),
                   sliderInput("boxoffice", "Dollars at Box Office (millions)", # a slider with two inputs
                               0, 800, c(0, 800), step = 1),
                   selectInput("genre", "Genre (a movie can have multiple genres)",
                               c("All", "Action", "Adventure", "Animation", "Biography", "Comedy",
                                 "Crime", "Documentary", "Drama", "Family", "Fantasy", "History",
                                 "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi",
                                 "Short", "Sport", "Thriller", "War", "Western")
                   ),
                   textInput("director", "Director name contains (e.g., Miyazaki)"),
                   textInput("cast", "Cast names contains (e.g. Tom Hanks)")
               )
        ),
        column(9,
               ggvisOutput("plot1")
        )
    )
)

server<- function(input, output){

    
    vis <-reactive({
        bsr %>% 
        ggvis(x = ~Date, y = ~BSR, stroke = ~SKU) %>%
        group_by(SKU) %>%
        layer_paths() 
    })
    
    correctPassword = reactive({input$password == "asdf"})
    
#     if(correctPassword()){
        vis %>% bind_shiny("plot1")
#     }
    
}

shinyApp(ui,server)
