require("RPostgreSQL")
require("ggplot2")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "mimic",
                 host = "localhost", port = 5432,
                 user = "postgres", password = "postgres")
dbSendQuery(con, 'set search_path to mimiciii')
dbListTables(con)
iculos = dbGetQuery(con, "select los from icustays where los >= 0 and los <=20")
qplot(iculos$los, geom="histogram", binwidth = 1, main = "Length of stay in the ICU", 
      xlab = "Length of stay, days", fill=I("#9ebcda"), col=I("#FFFFFF"))



dbDisconnect(con)
dbUnloadDriver(drv)








---
  title: "Plotting a CONSORT Flow Diagram"
output:
  html_document: default
pdf_document: default
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

CONSORT Flow Diagrams can be used to plot the flow of data selection of a patient cohort.   
For more details, see:
  [http://www.consort-statement.org/consort-statement/flow-diagram](The CONSORT Flow Diagram)

```{r loadpackages, include=FALSE}
.packages <- c("diagram")
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) {
  install.packages(.packages[!.inst], repos = "http://cran.rstudio.com")
}
lapply(.packages, library, character.only=TRUE)
```

```{r plot, echo=FALSE}
# set margins and multiplot
par(mfrow = c(1, 1))
par(mar = c(0, 0, 0, 0))

# initialise a plot device
openplotmat()

# position of boxes
# 1st column indicates x axis position between 0 and 1
# 2nd column indicates y axis position between 0 and 1
# automatically assigns vertical position
num_of_boxes <- 6
auto_coords = coordinates(num_of_boxes)
vert_pos = rev(auto_coords[,1])
box_pos <- matrix(nrow = num_of_boxes, ncol = 2, data = 0)
box_pos[1,] = c(0.20, vert_pos[1]) # 1st box
box_pos[2,] = c(0.70, vert_pos[2]) # 2nd box
box_pos[3,] = c(0.70, vert_pos[3]) # 3rd box
box_pos[4,] = c(0.70, vert_pos[4]) # etc...
box_pos[5,] = c(0.70, vert_pos[5])
box_pos[6,] = c(0.20, vert_pos[6])

# content of boxes
box_content <- matrix(nrow = num_of_boxes, ncol = 1, data = 0)
box_content[1] = "All patients in MIMIC-III \n n = 58,976" # 1st box
box_content[2] = "Exclude patients with icd9 \n not between 300 and 316 \n n = 45,725" # 2nd box
box_content[3] = "Exclude duplicated records \n n = 3,564" # 3rd box
box_content[4] = "Exclude patient died during stay \n n = 856" # etc...
box_content[5] = "Exclude outliers (1.5*(Q3-Q1)) \n n = 3,754"
box_content[6] = "Study cohort - readmission within 30 days: \n n = 3588 (negative), \n n = 1489 (postive)"

# adjust the size of boxes to fit content
box_x <- c(0.20, 0.25, 0.25, 0.25, 0.25, 0.20)
box_y <- c(0.07, 0.07, 0.07, 0.07, 0.07, 0.07)

# Draw the arrows
straightarrow(from = c(box_pos[1,1],box_pos[2,2]), to = box_pos[2,], lwd = 1)  
straightarrow(from = c(box_pos[1,1],box_pos[3,2]), to = box_pos[3,], lwd = 1)  
straightarrow(from = c(box_pos[1,1],box_pos[4,2]), to = box_pos[4,], lwd = 1)  
straightarrow(from = c(box_pos[1,1],box_pos[5,2]), to = box_pos[5,], lwd = 1)  
straightarrow(from = box_pos[1,], to = box_pos[6,], lwd = 1)

# Draw the boxes
for (i in 1:num_of_boxes) {
  textrect(mid = box_pos[i,], radx = box_x[i], rady = box_y[i], 
           lab = box_content[i], 
           shadow.col = "grey")
}

```


