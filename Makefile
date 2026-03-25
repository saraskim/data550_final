report.html: report.Rmd code/4_render.R setup splitdata analysis data/test_data_with_predictions.rds
	Rscript code/4_render.R

setup: code/1_setup.R data/noro_for_data550.csv
	Rscript code/1_setup.R


splitdata: code/2_split_data.R data/noro_for_data550_clean.rds
	Rscript code/2_split_data.R

analysis: code/3_analysis.R data/train_data.rds data/test_data.rds
	Rscript code/3_analysis.R



.PHONY: clean
clean:
	rm -f data/*.rds && rm -f report.html