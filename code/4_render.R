# Render report

here::i_am(
  "code/4_render.R"
)

rmarkdown::render(
  here::here("report.Rmd")
)
