

# Create fake data --------------------------------------------------------


group <- data.frame(age=c(24, 45, 23, 45, 53, 34, 32), 
                      weight = c(65, 74, 56, 59, 86, 79, 70), 
                      city = c("Freiburg", "Heidelberg", "Frankfurt", 
                               "Heidelberg", "Heidelberg", "Frankfurt", 
                               "Heidelberg"))

save(group, file = "data/group_1.RData")

group <- data.frame(age=c(56, 42, 23, 25, 63, 54, 38), 
                      weight = c(56, 40, 56, 37, 60, 27, 34), 
                      city = c("Colmar", "Karlsruhe", "Baden Baden", 
                               "Heidelberg", "Heidelberg", "Colmar", 
                               "Heidelberg"))

save(group, file = "data/group_2.RData")


# Create one markdown per group -------------------------------------------

n_groups <- 2
for (i in 1:n_groups) {
    rmarkdown::render("automatic_test.Rmd", params = list(group = i), 
         output_file = paste0("Survey Analysis group", i, ".pdf"))
}

